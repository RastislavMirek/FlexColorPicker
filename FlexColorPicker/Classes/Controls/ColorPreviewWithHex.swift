//
//  ColorPreviewWithHex.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 1/6/18.
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

internal let colorPreviewWithHexIntristicContentSize = CGSize(width: 65, height: 90)
internal let defaultHexLabelHeight: CGFloat = 20
private let hexFont = UIFont.systemFont(ofSize: 12)
private let defaultCornerradius: CGFloat = 5

private let confirmAnimationScaleRatio: CGFloat = 0.87
private let confirmAnimationSpringDamping: CGFloat = 0.7
private let confirmAnimationDuration = 0.3

/// A color control that displays currently selected color. It allows the user to evaluate if it is the color they want.
///
/// When tapped, it animates and sends `primaryActionTriggered` event. This event is interpreted as user confirming current color as final picked color by the `ColorPickerController`.
@IBDesignable
open class ColorPreviewWithHex: AbstractColorControl {
    private var labelHeightConstraint = NSLayoutConstraint()

    /// A subview that shows example of selected color. It is set as its `backgroundColor`.
    public let colorView = UIView()
    /// A label subview that shows hex value of selected color as text.
    public let hexLabel = UILabel()

    /// Convinience layout anchor that corresponds to bottom edge of `colorView`. This might not be equivalent of `bottomAnchor` as the `hexLabel` is below `colorView` (it it is displayed).
    ///
    /// Use this to align other views to `colorView`.
    open var hexLabelToLayoutAnchor: NSLayoutYAxisAnchor {
        return hexLabel.topAnchor
    }

    /// Whether to show (`true`) or hide (`false`) the subview that shows hex value of currently selected color (the `hexLabel`).
    @IBInspectable
    public var displayHex: Bool = true {
        didSet {
            updateLabelHeight()
        }
    }

    /// The desired height of the area displaying hex value of currently selected color.
    @IBInspectable
    public var hexHeight: CGFloat = defaultHexLabelHeight {
        didSet {
            updateLabelHeight()
        }
    }

    /// Text color of the hex label that displys hex value of currently selected color.
    @IBInspectable
    public var textColor: UIColor = UIColor.colorPickerLabelTextColor {
        didSet {
            hexLabel.textColor = textColor
        }
    }

    /// Whether to display default thin border around the preview.
    @IBInspectable
    public var borderOn: Bool = true {
        didSet {
            updateBorder(visible: borderOn, view: self)
        }
    }

    /// Corner radius of the preview.
    ///
    /// You can set it to very high value to make the view oval (or circular if bounds are square).
    @IBInspectable
    public var cornerRadius: CGFloat = defaultCornerradius {
        didSet {
            updateCornerRadius()
        }
    }

    ///If `true`, the preview will respond to touches, animating and sending `primaryActionTriggered` event on `touchUpInside`.
    @IBInspectable
    public var tapToConfirm: Bool = true

    open override var bounds: CGRect {
        didSet {
            updateCornerRadius()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return colorPreviewWithHexIntristicContentSize
    }

    open override func commonInit() {
        super.commonInit()

        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(hexLabel)
        hexLabel.translatesAutoresizingMaskIntoConstraints = false

        colorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: hexLabel.topAnchor).isActive = true

        hexLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hexLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelHeightConstraint = hexLabel.heightAnchor.constraint(equalToConstant: hexHeight)
        labelHeightConstraint.priority = .init(999)
        labelHeightConstraint.isActive = true
        hexLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        updateLabelHeight()

        hexLabel.textColor = textColor
        hexLabel.textAlignment = .center
        hexLabel.font = hexFont
        updateBorder(visible: borderOn, view: self)
        setSelectedHSBColor(selectedHSBColor, isInteractive: false) // set default color if it is not set, otherwise keep color set in storyboard via IBInspectable
        updateCornerRadius()
    }

    open override func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive interactive: Bool) {
        super.setSelectedHSBColor(hsbColor, isInteractive: interactive)
        let color = hsbColor.toUIColor()
        colorView.backgroundColor = color
        hexLabel.text = "#\(color.hexValue())"
    }

    private func updateLabelHeight() {
        labelHeightConstraint.constant = displayHex ? hexHeight : 0
    }
    
    /// Updates  border color of the color preview when interface is changed to dark or light mode.
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *), traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle  {
            updateBorder(visible: borderOn, view: self)
        }
    }

    private func handleTouchDown() {
        if !tapToConfirm {
            return
        }
        UIView.animate(withDuration: confirmAnimationDuration, delay: 0, usingSpringWithDamping: confirmAnimationSpringDamping, initialSpringVelocity: 0, options: [], animations: {
            self.layer.transform = CATransform3DMakeScale(confirmAnimationScaleRatio, confirmAnimationScaleRatio, 1)
        }, completion: nil)
    }

    private func handleTouchUp(valid: Bool) {
        if !tapToConfirm {
            return
        }
        UIView.animate(withDuration: confirmAnimationDuration, delay: 0, usingSpringWithDamping: confirmAnimationSpringDamping, initialSpringVelocity: 0, options: [], animations:  {
            self.layer.transform = CATransform3DIdentity
        }) { _ in
            if valid {
                self.sendActions(for: .primaryActionTriggered)
            }
        }
    }

    private func updateCornerRadius() {
        cornerRadius_ = min(cornerRadius, bounds.height / 2, bounds.width / 2)
        if cornerRadius_ > 0 {
            clipsToBounds = true
        }
    }
}

extension ColorPreviewWithHex {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches), point(inside: location, with: event) else {
            return
        }
        handleTouchDown()
        super.touchesBegan(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        handleTouchUp(valid: point(inside: location, with: event))
        super.touchesEnded(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchUp(valid: false)
        super.touchesCancelled(touches, with: event)
    }

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
