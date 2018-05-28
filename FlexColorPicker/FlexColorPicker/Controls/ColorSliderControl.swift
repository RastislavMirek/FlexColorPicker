//
//  ColorSliderControl.swift
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

private let defaultGradientViewHeight: CGFloat = 16

open class ColorSliderControl: ColorControlWithThumbView, ColorPickerControl {
    private var gradientViewHeightConstraint: NSLayoutConstraint?
    public let gradientBackgroundView = UIImageView()
    public let gradientView = GradientView()
    open var gradientViewHeight: CGFloat = defaultGradientViewHeight {
        didSet {
            gradientViewHeightConstraint?.constant = gradientViewHeight
        }
    }
    public var selectedColor: UIColor = .white {
        didSet {
            updateThumbAndGradient(with: selectedColor)
        }
    }
    open var colorSlider: ColorSlider = BrightnessSlider() {
        didSet {
            updateThumbAndGradient(with: selectedColor)
        }
    }

    open override var bounds: CGRect {
        didSet {
            updateCornerRadius()
        }
    }

    open override func commonInit() {
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientBackgroundView)
        gradientBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: thumbView.wideBorderWidth).isActive = true
        gradientBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -thumbView.wideBorderWidth).isActive = true
        gradientBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gradientViewHeightConstraint = gradientBackgroundView.heightAnchor.constraint(equalToConstant: gradientViewHeight)
        gradientViewHeightConstraint?.isActive = true
        gradientBackgroundView.addAutolayoutFillingSubview(gradientView)
        updateCornerRadius()
        gradientBackgroundView.clipsToBounds = true
        updateThumbAndGradient(with: selectedColor)
        addSubview(thumbView)
    }

    private func updateCornerRadius() {
        gradientBackgroundView.cornerRadius = gradientViewHeight / 2
    }

    open func updateThumbAndGradient(with color: UIColor) {
        let (value, gradientStart, gradientEnd) = colorSlider.valueAndGradient(for: color)
        let gradientLength = bounds.width - thumbView.frame.width
        thumbView.frame = CGRect(center: CGPoint(x: thumbView.frame.width / 2 + gradientLength * value, y: bounds.midY), size: thumbView.intrinsicContentSize)
        thumbView.color = color
        gradientView.startColor = gradientStart
        gradientView.endColor = gradientEnd
    }

    open override func updateSelectedColor(at point: CGPoint) {
        let gradientLength = bounds.width - thumbView.frame.width
        let value = 1 - (point.x - thumbView.intrinsicContentSize.width / 2) / gradientLength
        selectedColor = selectedColor.withBrightness(min(max(0, value), 1))
    }
}
