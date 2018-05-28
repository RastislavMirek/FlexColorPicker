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

open class ColorPaletteControl: UIControl {
    /// The picture with hue and saturation color options.
    open let colorMapImageView = UIImageView()
    /// Black image in the background used to apply brightnes chnage by blending it with colorMapImageView.
    open let backgroundImageView = UIImageView()
    public var thumbView = ColorPickerThumbView() {
        didSet {
            updateSelectedColor(at: colorPalete.position(for: color))
        }
    }
    public var color = UIColor(named: "DefaultSelectedColor", in: flexColorPickerBundle)! {
        didSet {
            thumbView.color = color
        }
    }
    open var colorPalete: ColorPalette = RadialColorPalette() {
        didSet {
            updatePaleteImages()
        }
    }
    open override var bounds: CGRect {
        didSet {
            if bounds.size != oldValue.size {
                updatePaleteImages()
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    open func commonInit() {
        for imageView in [backgroundImageView, colorMapImageView] {
            addAutolayoutFillingSubview(imageView)
            imageView.contentMode = .scaleAspectFit
        }
        updatePaleteImages()
        thumbView.frame = CGRect(center: colorPalete.position(for: color), size: thumbView.intrinsicContentSize)
        thumbView.color = color
        addSubview(thumbView)

//        addGestureRecognizer(touchRecognizer)
//        addGestureRecognizer(panGestureRecognizer)
    }

    open func updatePaleteImages() {
        colorPalete.size = bounds.size
        colorMapImageView.image = colorPalete.renderForegroundImage()
        backgroundImageView.image = colorPalete.renderBackgroundImage()
    }

    open func updateSelectedColor(at point: CGPoint) {
        let pointInside = colorPalete.closestPoint(to: point)
        color = colorPalete.color(at: pointInside)
        thumbView.frame = CGRect(center: pointInside, size: thumbView.intrinsicContentSize)
    }
}

extension ColorPaletteControl {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        thumbView.setExpanded(true, animated: true)
        updateSelectedColor(at: location)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        updateSelectedColor(at: location)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        updateSelectedColor(at: location)
        thumbView.setExpanded(false, animated: true)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        updateSelectedColor(at: location)
        thumbView.setExpanded(false, animated: true)
    }

    private func locationForTouches(_ touches: Set<UITouch>) -> CGPoint? {
        return touches.first?.location(in: self)
    }
}
