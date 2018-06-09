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

    open var sliderDelegate: ColorSliderDelegate = BrightnessSliderDelegate() {
        didSet {
            updateThumbAndGradient(isInteractive: false)
        }
    }

    open override var bounds: CGRect {
        didSet {
            updateCornerRadius()
            updateThumbAndGradient(isInteractive: false)
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
        updateThumbAndGradient(isInteractive: false)
        contentView.addSubview(thumbView)
        setDefaultBorder(on: borderOn)
    }

    open override func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive interactive: Bool) {
        super.setSelectedHSBColor(hsbColor, isInteractive: interactive)
        updateThumbAndGradient(isInteractive: interactive)
    }

    private func updateCornerRadius() {
        gradientBackgroundView.cornerRadius_ = contentBounds.height / 2
    }

    open func updateThumbAndGradient(isInteractive interactive: Bool) {
        layoutIfNeeded() //ensure that subview bounds are updated as we are working with contentView.bounds.midY
        let (value, gradientStart, gradientEnd) = sliderDelegate.valueAndGradient(for: selectedHSBColor)
        let gradientLength = contentBounds.width - thumbView.colorIdicatorRadius * 2 //cannot use self.bounds as that is extended compared to foregroundImageView.bounds when AdjustedHitBoxColorControl.hitBoxInsets are non-zero
        thumbView.frame = CGRect(center: CGPoint(x: thumbView.colorIdicatorRadius + gradientLength * min(max(0, value), 1), y: contentView.bounds.midY), size: thumbView.intrinsicContentSize)
        thumbView.setColor(selectedHSBColor.toUIColor(), animateBorderColor: interactive)
        gradientView.startOffset = thumbView.colorIdicatorRadius
        gradientView.endOffset = thumbView.colorIdicatorRadius
        gradientView.startColor = gradientStart //to keep the gradient realistic (you select exactly the same color that you tapped) we need to offset gradient as tapping first and last part of gradient (of length thumbView.colorIdicatorRadius) always selects max or min color
        gradientView.endColor = gradientEnd
    }

    open override func updateSelectedColor(at point: CGPoint) {
        let gradientLength = contentBounds.width - thumbView.colorIdicatorRadius * 2
        let value = max(0, min(1, (point.x - thumbView.colorIdicatorRadius) / gradientLength))
        thumbView.percentage = Int(round(value * 100))
        setSelectedHSBColor(sliderDelegate.modifiedColor(from: selectedHSBColor, with: min(max(0, value), 1)), isInteractive: true)
        sendActions(for: .valueChanged)
    }

    open func setDefaultBorder(on: Bool) {
        setDefaultBorder(on: on, forView: gradientBackgroundView)
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
