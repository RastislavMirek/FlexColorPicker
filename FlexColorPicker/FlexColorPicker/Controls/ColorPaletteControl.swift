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

let defaultSelectedColor = UIColor.white.hsbColor

@IBDesignable
open class ColorPaletteControl: ColorControlWithThumbView, ColorPickerControl {
    /// The picture with hue and saturation color options.
    public let foregroundImageView = UIImageView()
    /// Black image in the background used to apply brightnes chnage by blending it with colorMapImageView.
    public let backgroundImageView = UIImageView()

    public var selectedHSBColor: HSBColor = defaultSelectedColor {
        didSet {
            thumbView.color = selectedHSBColor.toUIColor()
            if oldValue != selectedHSBColor {
                let (position, foregroundAlpha) = colorPalete.positionAndAlpha(for: selectedHSBColor)
                thumbView.frame = CGRect(center: position, size: thumbView.intrinsicContentSize)
                foregroundImageView.alpha = foregroundAlpha
            }
        }
    }
    open var colorPalete: ColorPalette = RadialHSBPalette() {
        didSet {
            updatePaleteImagesAndThumb()
        }
    }
    open override var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                updatePaleteImagesAndThumb()
            }
        }
    }

    open override func commonInit() {
        super.commonInit()
        for imageView in [backgroundImageView, foregroundImageView] {
            addAutolayoutFillingSubview(imageView)
            imageView.contentMode = .scaleAspectFit
        }
        updatePaleteImagesAndThumb()
        addSubview(thumbView)
    }

    open func updatePaleteImagesAndThumb() {
        colorPalete.size = bounds.size
        foregroundImageView.image = colorPalete.renderForegroundImage()
        backgroundImageView.image = colorPalete.renderBackgroundImage()
        thumbView.frame = CGRect(center: colorPalete.positionAndAlpha(for: selectedHSBColor).position, size: thumbView.intrinsicContentSize)
        thumbView.color = selectedHSBColor.toUIColor()
    }

    open override func updateSelectedColor(at point: CGPoint) {
        let pointInside = colorPalete.closestValidPoint(to: point)
        selectedHSBColor = colorPalete.modifyColor(selectedHSBColor, with: pointInside)
        thumbView.frame = CGRect(center: pointInside, size: thumbView.intrinsicContentSize)
        sendActions(for: .valueChanged)
    }
}

extension ColorPaletteControl {
    @IBInspectable
    var selectedColor: UIColor {
        get {
            return selectedHSBColor.toUIColor()
        }
        set {
            selectedHSBColor = newValue.hsbColor
        }
    }
}
