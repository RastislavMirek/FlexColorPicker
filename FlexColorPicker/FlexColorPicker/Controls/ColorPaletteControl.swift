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

let defaultSelectedColor = UIColor.white

open class ColorPaletteControl: ColorControlWithThumbView, ColorPickerControl {
    /// The picture with hue and saturation color options.
    open let foregroundImageView = UIImageView()
    /// Black image in the background used to apply brightnes chnage by blending it with colorMapImageView.
    open let backgroundImageView = UIImageView()
    public var selectedColor = defaultSelectedColor {
        didSet {
            thumbView.color = selectedColor
            if oldValue != selectedColor {
                let (position, foregroundAlpha) = colorPalete.positionAndAlpha(for: selectedColor)
                thumbView.frame = CGRect(center: position, size: thumbView.intrinsicContentSize)
                foregroundImageView.alpha = foregroundAlpha
            }
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

    open override func commonInit() {
        for imageView in [backgroundImageView, foregroundImageView] {
            addAutolayoutFillingSubview(imageView)
            imageView.contentMode = .scaleAspectFit
        }
        updatePaleteImages()
        thumbView.frame = CGRect(center: colorPalete.positionAndAlpha(for: selectedColor).position, size: thumbView.intrinsicContentSize)
        thumbView.color = selectedColor
        addSubview(thumbView)
    }

    open func updatePaleteImages() {
        colorPalete.size = bounds.size
        foregroundImageView.image = colorPalete.renderForegroundImage()
        backgroundImageView.image = colorPalete.renderBackgroundImage()
    }

    open override func updateSelectedColor(at point: CGPoint) {
        let pointInside = colorPalete.closestValidPoint(to: point)
        selectedColor = colorPalete.modifyColor(selectedColor, with: pointInside)
        thumbView.frame = CGRect(center: pointInside, size: thumbView.intrinsicContentSize)
    }
}
