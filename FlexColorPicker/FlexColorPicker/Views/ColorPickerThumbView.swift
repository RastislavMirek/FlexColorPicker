//
//  ColorPickerThumbView.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 28/5/18.
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

private let colorPickerThumbViewDiameter: CGFloat = 28
private let defaultBorderWidth: CGFloat = 6
private let defaultExpandedUpscaleRatio: CGFloat = 1.6
private let expansionAnimationDuration = 0.3
private let collapsingAnimationDelay = 0.1
private let brightnessToChangeToDark: CGFloat = 0.3
private let saturationToChangeToDark: CGFloat = 0.4

@IBDesignable
open class ColorPickerThumbView: UIViewWithCommonInit {
    public let borderView = CircleShapedView()
    public let colorView = CircleShapedView()
    var expandedUpscaleRatio: CGFloat = defaultExpandedUpscaleRatio {
        didSet {
            if isExpanded {
                setExpanded(true, animated: true)
            }
        }
    }
    open var color: UIColor = .clear {
        didSet {
            colorView.backgroundColor = color
            setDarkBorderIfNeeded()
        }
    }

    public private(set) var isExpanded = false

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: colorPickerThumbViewDiameter, height: colorPickerThumbViewDiameter)
    }

    var wideBorderWidth: CGFloat {
        return defaultBorderWidth
    }

    open override func commonInit() {
        addAutolayoutFillingSubview(borderView)
        addAutolayoutFillingSubview(colorView, edgeInsets: UIEdgeInsets(top: defaultBorderWidth, left: defaultBorderWidth, bottom: defaultBorderWidth, right: defaultBorderWidth))
        borderView.borderColor = UIColor(named: "BorderColor", in: flexColorPickerBundle)
        borderView.borderWidth = 1 / UIScreen.main.scale
        borderView.backgroundColor = UIColor(named: "ThumbViewWideBorderColor", in: flexColorPickerBundle)
    }

    open func setExpanded(_ expanded: Bool, animated: Bool) {
        let transform = expanded ? CATransform3DMakeScale(expandedUpscaleRatio, expandedUpscaleRatio, 1) : CATransform3DIdentity
        isExpanded = expanded
        UIView.animate(withDuration: animated ? expansionAnimationDuration : 0, delay: expanded ? 0 : collapsingAnimationDelay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.borderView.layer.transform = transform
            self.colorView.layer.transform = transform
        }, completion: nil)
    }

    open func setDarkBorderIfNeeded() {
        let (_, s, b) = color.hsbColor.asTupleNoAlpha()
        let isBorderGrey = 1 - b < brightnessToChangeToDark && s < saturationToChangeToDark

        UIView.animate(withDuration: 0.3) {
            self.borderView.borderColor = UIColor(named: isBorderGrey ? "BorderColor" : "LightBorderColor", in: flexColorPickerBundle)
            self.borderView.backgroundColor = UIColor(named: isBorderGrey ? "ThumbViewWideBorderDarkColor" : "ThumbViewWideBorderColor", in: flexColorPickerBundle)
        }

    }
}
