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

@IBDesignable
open class ColorPreviewWithHex: UIViewWithCommonInit {
    private var labelHeightConstraint = NSLayoutConstraint()
    public let colorView = UIView()
    public let hexLabel = UILabel()

    @IBInspectable
    public var selectedColor: UIColor = defaultSelectedColor.toUIColor() {
        didSet {
            updateSelectedColor(with: selectedColor)
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
        updateSelectedColor(with: selectedColor) // set default color if it is not set, otherwise keep color set in storyboard via IBInspectable
        updateCornerRadius()
    }

    open func setDefaultBorder(on: Bool) {
        borderColor = UIColor(named: "BorderColor", in: flexColorPickerBundle)
        borderWidth = on ? defaultBorderWidth : 0
    }

    private func updateLabelHeight() {
        labelHeightConstraint.constant = displayHex ? hexHeight : 0
    }

    private func updateSelectedColor(with selectedColor: UIColor) {
        colorView.backgroundColor = selectedColor
        hexLabel.text = "#\(selectedColor.hexValue())"
    }

    private func updateCornerRadius() {
        cornerRadius_ = min(cornerRadius, bounds.height / 2, bounds.width / 2)
        if cornerRadius_ > 0 {
            clipsToBounds = true
        }
    }
}
