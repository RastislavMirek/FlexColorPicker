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
private let defaultWideBorderWidth: CGFloat = 6
private let defaultExpandedUpscaleRatio: CGFloat = 1.6
private let expansionAnimationDuration = 0.3
private let collapsingAnimationDelay = 0.1
private let borderDarkeningAnimationDuration = 0.3
private let expansionAnimationSpringDamping: CGFloat = 0.7
private let brightnessToChangeToDark: CGFloat = 0.3
private let saturationToChangeToDark: CGFloat = 0.4
private let textLabelUpShift: CGFloat = 12
private let maxContrastRatioWithWhiteToDarken: CGFloat = 0.25
private let percentageTextFont = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)

@IBDesignable
open class ColorPickerThumbView: UIViewWithCommonInit {
    public let borderView: CircleShapedView = LimitedGestureCircleView()
    public let colorView: CircleShapedView = LimitedGestureCircleView()
    public let percentageLabel = UILabel()
    /// When `true` the border automatically darken when color is too bright to be contrast enought with white border.
    public var autoDarken: Bool = true
    /// Whether to show percentage label above the thumb view.
    public var showPercentage: Bool = true
    /// Whether the thumb view should be expanded when user is interacting with it.
    public var expandOnTap: Bool = true
    var delegate: LimitedGestureViewDelegate? {
        didSet {
            (borderView as? LimitedGestureCircleView)?.delegate = delegate
            (colorView as? LimitedGestureCircleView)?.delegate = delegate
        }
    }

    var expandedUpscaleRatio: CGFloat = defaultExpandedUpscaleRatio {
        didSet {
            if isExpanded {
                setExpanded(true, animated: true)
            }
        }
    }
    private(set) open var color: UIColor = defaultSelectedColor.toUIColor()

    open var percentage: Int = 0 {
        didSet {
            updatePercentage(percentage)
        }
    }

    public private(set) var isExpanded = false

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: colorPickerThumbViewDiameter, height: colorPickerThumbViewDiameter)
    }

    var wideBorderWidth: CGFloat {
        return defaultWideBorderWidth
    }

    open override func commonInit() {
        super.commonInit()
        addAutolayoutFillingSubview(borderView)
        addAutolayoutFillingSubview(colorView, edgeInsets: UIEdgeInsets(top: wideBorderWidth, left: wideBorderWidth, bottom: wideBorderWidth, right: wideBorderWidth))
        addAutolayoutCentredView(percentageLabel)
        borderView.viewBorderColor = UIColor.colorPickerBorderColor
        borderView.borderWidth = 1 / UIScreen.main.scale
        percentageLabel.font = percentageTextFont
        percentageLabel.textColor = UIColor.colorPickerLabelTextColor
        percentageLabel.textAlignment = .center
        percentageLabel.alpha = 0
        clipsToBounds = false // required for the text label to be displayed ourside of bounds
        borderView.backgroundColor = UIColor.colorPickerThumbViewWideBorderColor
        (borderView as? LimitedGestureCircleView)?.delegate = delegate
        (colorView as? LimitedGestureCircleView)?.delegate = delegate
        setColor(color, animateBorderColor: false)
    }

    open func setColor(_ color: UIColor, animateBorderColor: Bool) {
        self.color = color
        colorView.backgroundColor = color
        setDarkBorderIfNeeded(animated: animateBorderColor)
    }

    public func updatePercentage(_ percentage: Int) {
        percentageLabel.text = String(min(100, max(0, percentage))) + "%"
    }
}

extension ColorPickerThumbView {
    
    open func setExpanded(_ expanded: Bool, animated: Bool) {
        let transform = expanded && expandOnTap ? CATransform3DMakeScale(expandedUpscaleRatio, expandedUpscaleRatio, 1) : CATransform3DIdentity
        let textLabelRaiseAmount: CGFloat = expanded && expandOnTap ? (bounds.height / 2) * defaultExpandedUpscaleRatio + textLabelUpShift : (bounds.height / 2)  + textLabelUpShift
        let labelTransform = CATransform3DMakeTranslation(0, -textLabelRaiseAmount, 0)
        isExpanded = expanded

        UIView.animate(withDuration: animated ? expansionAnimationDuration : 0, delay: expanded ? 0 : collapsingAnimationDelay, usingSpringWithDamping: expansionAnimationSpringDamping, initialSpringVelocity: 0, options: [], animations: {
            self.borderView.layer.transform = transform
            self.colorView.layer.transform = transform
            self.percentageLabel.layer.transform = labelTransform
            self.percentageLabel.alpha = expanded && self.showPercentage ? 1 : 0
        }, completion: nil)
    }

    open func setDarkBorderIfNeeded(animated: Bool = true) {
        let (_, s, b) = color.hsbColor.asTupleNoAlpha()
        let isBorderDark = autoDarken && 1 - b < brightnessToChangeToDark && s < saturationToChangeToDark
//        let isBorderDark = autoDarken && color.constrastRatio(with: .white) < maxContrastRatioWithWhiteToDarken

        #if TARGET_INTERFACE_BUILDER
            setWideBorderColors(isBorderDark) //animations do not work
        #else
        UIView.animate(withDuration: animated ? borderDarkeningAnimationDuration : 0) {
            self.setWideBorderColors(isBorderDark)
        }
        #endif
    }

    open var colorIdicatorRadius: CGFloat {
        return bounds.width / 2 - wideBorderWidth
    }

    private func setWideBorderColors(_ isDark: Bool) {
        self.borderView.viewBorderColor = isDark ? UIColor.colorPickerBorderColor : UIColor.colorPickerLightBorderColor
        self.borderView.backgroundColor = isDark ? UIColor.colorPickerThumbViewWideBorderDarkColor : UIColor.colorPickerThumbViewWideBorderColor
    }
}

extension ColorPickerThumbView {
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let delegate = (borderView as? LimitedGestureCircleView)?.delegate else {
            return !(gestureRecognizer is UIPanGestureRecognizer)
        }
        return delegate.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
