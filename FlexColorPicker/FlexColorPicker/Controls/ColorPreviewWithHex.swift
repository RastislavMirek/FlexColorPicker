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

private let hexFont = UIFont.systemFont(ofSize: 12)
private let defaultHexLabelHeight: CGFloat = 20
private let defaultCornerradius: CGFloat = 5

private let confirmAnimationScaleRatio: CGFloat = 0.87
private let confirmAnimationSpringDamping: CGFloat = 0.7
private let confirmAnimationDuration = 0.3

@IBDesignable
open class ColorPreviewWithHex: AbstractColorControl {
    private var labelHeightConstraint = NSLayoutConstraint()
    public let colorView = UIView()
    public let hexLabel = UILabel()

    open override var selectedHSBColor: HSBColor {
        didSet {
            updateSelectedColor(with: selectedHSBColor)
        }
    }

    @IBInspectable
    public var displayHex: Bool = true {
        didSet {
            updateLabelHeight()
        }
    }

    @IBInspectable
    public var hexHeight: CGFloat = defaultHexLabelHeight {
        didSet {
            updateLabelHeight()
        }
    }

    @IBInspectable
    public var textColor: UIColor = UIColor(named: "LabelTextsColor", in: flexColorPickerBundle) ?? .black {
        didSet {
            hexLabel.textColor = textColor
        }
    }

    @IBInspectable
    public var borderOn: Bool = true {
        didSet {
            setDefaultBorder(on: borderOn)
        }
    }

    @IBInspectable
    public var cornerRadius: CGFloat = defaultCornerradius {
        didSet {
            updateCornerRadius()
        }
    }

    @IBInspectable
    public var tapToConfirm: Bool = true

    open override var bounds: CGRect {
        didSet {
            updateCornerRadius()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: 65, height: 90)
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
        labelHeightConstraint.isActive = true
        hexLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        updateLabelHeight()

        hexLabel.textColor = textColor
        hexLabel.textAlignment = .center
        hexLabel.font = hexFont
        setDefaultBorder(on: borderOn)
        updateSelectedColor(with: selectedHSBColor) // set default color if it is not set, otherwise keep color set in storyboard via IBInspectable
        updateCornerRadius()
    }

    open func setDefaultBorder(on: Bool) {
        borderColor = UIColor(named: "BorderColor", in: flexColorPickerBundle)
        borderWidth = on ? defaultBorderWidth : 0
    }

    open func updateSelectedColor(with selectedColor: HSBColor) {
        let color = selectedColor.toUIColor()
        colorView.backgroundColor = color
        hexLabel.text = "#\(color.hexValue())"
    }

    private func updateLabelHeight() {
        labelHeightConstraint.constant = displayHex ? hexHeight : 0
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
        guard let location = locationForTouches(touches), hitTest(location, with: event) != nil else {
            return
        }
        handleTouchDown()
        super.touchesBegan(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        handleTouchUp(valid: hitTest(location, with: event) != nil)
        super.touchesEnded(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchUp(valid: false)
        super.touchesCancelled(touches, with: event)
    }
}
