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

private let defaultGradientViewHeight: CGFloat = 15
internal let defaultBorderWidth: CGFloat = 1 / UIScreen.main.scale

@IBDesignable
open class ColorSliderControl: ColorControlWithThumbView {

    private var gradientViewHeightConstraint: NSLayoutConstraint?
    public let gradientBackgroundView = UIImageView()
    public let gradientView = GradientView()

    open override var selectedHSBColor: HSBColor {
        didSet {
            updateThumbAndGradient()
        }
    }

    open var colorSlider: ColorSlider = BrightnessSlider() {
        didSet {
            updateThumbAndGradient()
        }
    }

    open override var bounds: CGRect {
        didSet {
            updateCornerRadius()
            updateThumbAndGradient()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: defaultGradientViewHeight)
    }

    open override func commonInit() {
        super.commonInit()
        contentView.addAutolayoutFillingSubview(gradientBackgroundView)
        gradientBackgroundView.addAutolayoutFillingSubview(gradientView)
        updateCornerRadius()
        gradientBackgroundView.clipsToBounds = true
        updateThumbAndGradient()
        contentView.addSubview(thumbView)
        setDefaultBorder(on: borderOn)
    }

    private func updateCornerRadius() {
        layoutIfNeeded() //ensure that subview bounds are updated
        gradientBackgroundView.cornerRadius_ = gradientBackgroundView.bounds.height / 2
    }

    open func updateThumbAndGradient() {
        layoutIfNeeded() //ensure that subview bounds are updated as we are working with contentView.bounds
        let (value, gradientStart, gradientEnd) = colorSlider.valueAndGradient(for: selectedHSBColor)
        let gradientLength = contentView.bounds.width - thumbView.colorIdicatorRadius * 2 //cannot use self.bounds as that is extended compared to foregroundImageView.bounds when AdjustedHitBoxColorControl.hitBoxInsets are non-zero
        thumbView.frame = CGRect(center: CGPoint(x: thumbView.colorIdicatorRadius + gradientLength * min(max(0, value), 1), y: contentView.bounds.midY), size: thumbView.intrinsicContentSize)
        thumbView.color = selectedHSBColor.toUIColor()
        gradientView.startOffset = thumbView.colorIdicatorRadius
        gradientView.endOffset = thumbView.colorIdicatorRadius
        gradientView.startColor = gradientStart
        gradientView.endColor = gradientEnd
    }

    open override func updateSelectedColor(at point: CGPoint) {
        layoutIfNeeded()
        let gradientLength = contentView.bounds.width - thumbView.colorIdicatorRadius * 2
        let value = max(0, min(1, (point.x - thumbView.colorIdicatorRadius) / gradientLength))
        thumbView.percentage = Int(round(value * 100))
        selectedHSBColor = colorSlider.modifyColor(selectedHSBColor, with: min(max(0, value), 1))
        sendActions(for: .valueChanged)
    }

    open func setDefaultBorder(on: Bool) {
        gradientBackgroundView.borderColor = UIColor(named: "BorderColor", in: flexColorPickerBundle)
        gradientBackgroundView.borderWidth = on ? defaultBorderWidth : 0
    }

    @IBInspectable
    public var borderOn: Bool = true {
        didSet {
            setDefaultBorder(on: borderOn)
        }
    }
}

extension ColorSliderControl {
    @IBInspectable
    public var autoDaken: Bool {
        get {
            return thumbView.autoDarken
        }
        set {
            thumbView.autoDarken = newValue
        }
    }

    @IBInspectable
    public var showPercentage: Bool {
        get {
            return thumbView.showPercentage
        }
        set {
            thumbView.showPercentage = newValue
        }
    }

    @IBInspectable
    public var expandOnTap: Bool {
        get {
            return thumbView.expandOnTap
        }
        set {
            thumbView.expandOnTap = newValue
        }
    }
}
