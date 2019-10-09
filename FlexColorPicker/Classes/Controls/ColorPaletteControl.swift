//
//  ColorPaleteControl.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 27/5/18.
//  
//	MIT License
//  Copyright (c) 2018 Rastislav Mirek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

let minimumDistanceForInBoundsTouchFromValidPoint: CGFloat = 44
let defaultSelectedColor = UIColor.white.hsbColor

/// Color control that allows to select color by tapping or panning a palette that displays available color options.
///
/// Any subvies must be added to `contentView` only for this to work correctly inside `UIScrollView` and iOS 13 modal view controllers.
@IBDesignable
open class ColorPaletteControl: ColorControlWithThumbView {
    /// The image view providing preview of color option for each particular point. Its image might be e.g. hue/saturation map.
    public let foregroundImageView = UIImageView()
    /// Background image view that holds image which blends with image displayed by `foregroundImageView` when its alpha is less then 1, providing more accurate color options preview. E.g. black image that blends with hue/saturation map in foreground to show color map adjusted for brightness .
    public let backgroundImageView = UIImageView()

    /// A delegate that specifies what pallete color options look like (image of the palette) and how selecting a point on the palette is interpreted. It also specifies tappable region of the palette.
    open var paletteDelegate: ColorPaletteDelegate = RadialHSBPaletteDelegate() {
        didSet {
            updatePaletteImagesAndThumb(isInteractive: false)
        }
    }
    open override var bounds: CGRect {
        didSet {
            updatePaletteImagesAndThumb(isInteractive: false)
        }
    }
    
    open override var contentMode: UIView.ContentMode {
        didSet {
            updateContentMode()
            updateThumbPosition(position: paletteDelegate.positionAndAlpha(for: selectedHSBColor).position)
        }
    }

    open override func commonInit() {
        super.commonInit()
        contentView.addAutolayoutFillingSubview(backgroundImageView)
        backgroundImageView.addAutolayoutFillingSubview(foregroundImageView)
        updateContentMode()
        contentView.addSubview(thumbView)
        updatePaletteImagesAndThumb(isInteractive: false)
    }

    open override func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive interactive: Bool) {
        let hasChanged = selectedHSBColor != hsbColor
        super.setSelectedHSBColor(hsbColor, isInteractive: interactive)
        if hasChanged {
            thumbView.setColor(hsbColor.toUIColor(), animateBorderColor: interactive)
            let (position, foregroundAlpha) = paletteDelegate.positionAndAlpha(for: hsbColor)
            updateThumbPosition(position: position)
            foregroundImageView.alpha = foregroundAlpha
        }
    }

    /// Updates palette foreground and backround images and thumb view to reflect current state of this control (e.g. values of `selectedHSBColor` and `paletteDelegate`). Call this only if update of visual state of the pallete is necessary as this call has performance implications - new images are requested from palette delegate.
    ///
    /// Override this if you need update palette visual state differently on state change.
    ///
    /// - Parameter interactive:  Whether the change originated from user interaction or is programatic. This can be used to determine if certain animations should be played.
    open func updatePaletteImagesAndThumb(isInteractive interactive: Bool) {
        layoutIfNeeded() //force subviews layout to update their bounds - bounds of subviews are not automatically updated
        paletteDelegate.size = foregroundImageView.bounds.size //cannot use self.bounds as that is extended compared to foregroundImageView.bounds when AdjustedHitBoxColorControl.hitBoxInsets are non-zero
        foregroundImageView.image = paletteDelegate.foregroundImage()
        backgroundImageView.image = paletteDelegate.backgroundImage()
        assert(foregroundImageView.image!.size.width <= paletteDelegate.size.width && foregroundImageView.image!.size.height <= paletteDelegate.size.height, "Size of rendered image must be smaller or equal specified palette size")
        assert(backgroundImageView.image == nil || foregroundImageView.image?.size == backgroundImageView.image?.size, "foreground and background images rendered must have same size")
        updateContentMode()
        updateThumbPosition(position: paletteDelegate.positionAndAlpha(for: selectedHSBColor).position)
        thumbView.setColor(selectedColor, animateBorderColor: interactive)
    }

    /// Translates a point from given coordinate space to coordinate space of foreground image. Image coordinate space is used by the palette delegate.
    /// - Note: This translates from the coordiate space of the image itself not the coordinate space of its image view. Those can be different and the translation between them is dependent on current value of image view's `contentMode`.
    ///
    /// - Parameters:
    ///   - point: The point to translate.
    ///   - coordinateSpace: Source (current) coordinate space of the point to translate from.
    /// - Returns: Corresponding point in image coordinate space.
    open func imageCoordinates(point: CGPoint, fromCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return foregroundImageView.convertToImageSpace(point: foregroundImageView.convert(point, from: coordinateSpace))
    }

    /// Translates a point from coordinate space of foreground image to given coordinate space. Image coordinate space is used by the palette delegate.
    /// - Note: This translates to the coordiate space of the image itself not the coordinate space of its image view. Those can be different and the translation between them is dependent on current value of image view's `contentMode`.
    ///
    /// - Parameters:
    ///   - point: The point to translate.
    ///   - coordinateSpace: Target (destination) coordinate space to translate to.
    /// - Returns: Corresponding point in target coordinate space.
    open func imageCoordinates(point: CGPoint, toCoordinateSpace coordinateSpace: UICoordinateSpace) -> CGPoint {
        return foregroundImageView.convert(foregroundImageView.convertFromImageSpace(point: point), to: coordinateSpace)
    }

    open override func updateSelectedColor(at point: CGPoint, isInteractive: Bool) {
        let pointInside = paletteDelegate.closestValidPoint(to: imageCoordinates(point: point, fromCoordinateSpace: contentView))
        setSelectedHSBColor(paletteDelegate.modifiedColor(from: selectedHSBColor, with: pointInside), isInteractive: isInteractive)
        updateThumbPosition(position: pointInside)
        sendActions(for: .valueChanged)
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let maxTouchDistance = max(hitBoxInsets.bottom, hitBoxInsets.top, hitBoxInsets.left, hitBoxInsets.right, minimumDistanceForInBoundsTouchFromValidPoint)
        if imageCoordinates(point: paletteDelegate.closestValidPoint(to: imageCoordinates(point: point, fromCoordinateSpace: self)), toCoordinateSpace: self).distance(to: point) > maxTouchDistance {
            return nil
        }
        return super.hitTest(point, with: event)
    }

    private func updateThumbPosition(position: CGPoint) {
        thumbView.frame = CGRect(center: imageCoordinates(point: position, toCoordinateSpace: contentView), size: thumbView.intrinsicContentSize)
    }

    private func updateContentMode() {
        let contentMode = paletteDelegate.supportedContentMode(for: self.contentMode)
        backgroundImageView.contentMode = contentMode
        foregroundImageView.contentMode = contentMode
    }
}

extension ColorPaletteControl {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }
}
