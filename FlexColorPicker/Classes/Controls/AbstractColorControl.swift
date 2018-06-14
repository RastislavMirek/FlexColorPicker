//
//  UIControlWithCommonInit.swift
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

/// Contains common functionality for `ColorControl`. It is recomended to subclass this rather than `UIView` or `UIControl` when implementing customcolor control.
open class AbstractColorControl: UIControl, ColorControl {
    private(set) public var selectedHSBColor: HSBColor = defaultSelectedColor

    /// Currently selected color of the color control as `UIColor`. Convinience property: Value is backed by and changes are reflected to `selectedHSBColor`.
    @IBInspectable
    public var selectedColor: UIColor { //overriding default implementation from ColorControl to add @IBInspectable
        get {
            return selectedHSBColor.toUIColor()
            // do not do something like  return (self as ColorControl).selectedColor here as that breaks IBDesignable
        }
        set {
            selectedHSBColor = newValue.hsbColor // do not do something like  (self as ColorControl).selectedColor = newValue here as that breaks IBDesignable
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

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    /// This method is override point for initialization tasks that needs to be carried no matter how the view is constructed (e. g. via Interface Builder or from code). Overriders must call super implementation.
    open func commonInit() {
        isExclusiveTouch = true
    }

    open func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive: Bool) {
        selectedHSBColor = hsbColor
    }

    func locationForTouches(_ touches: Set<UITouch>) -> CGPoint? {
        return touches.first?.location(in: self)
    }

    func setDefaultBorder(on: Bool, forView view: UIView) {
        view.borderColor = UIColor(named: "BorderColor")
        view.borderWidth = on ? defaultBorderWidth : 0
    }
}
