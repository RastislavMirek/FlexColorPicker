//
//  ColorPickerControl.swift
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

/// Protocol to which all color picker controls must conform. This protocol defines contract of color controls.
///
/// A color control is standalone view that should subclass `UIControl` and which can be used to pick a color. Value of color control is stored in `selectedHSBColor` property.
///
/// Color control sends `UIControlEvents.valueChanged` events to registered targets when its value (`selectedHSBColor`) changes as consequence of user interaction with the control. A color control can also send `UIControlEvents.primaryActionTriggered` when user takes action to confirm current selected color as final.
///
/// A color control should be usable as standalone component but is usually used together with other color controls managed and synchronized by instance of `ColorPickerController`.
public protocol ColorControl: class {
    /// Override this and return `false` if you do not want `UIControlEvents.primaryActionTriggered` events sent by the color control to be considered confirmation of color selection.
    static var canConfirmColor: Bool { get }
    /// The value of this color control. Represents current selected color. Use `setSelectedHSBColor(_: isInteractive:)` to set value of this property.
    var selectedHSBColor: HSBColor { get }

    /// Sets `selectedHSBColor` and adjusts visual state of the control to its new value.
    ///
    /// - Parameters:
    ///   - hsbColor: New value to be set as selected color of this color control.
    ///   - isInteractive: Whether new selected color was specified programatically or by user via interaction with another control. This can used to determine if some animations should be played.
    func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive: Bool)
    
    func addTarget(_ target: Any?, action: Selector, for: UIControl.Event)
    func removeTarget(_ target: Any?, action: Selector?, for: UIControl.Event)
}

public extension ColorControl {
    /// Provides the default value for canConfirmColor. Returns true.
    static var canConfirmColor: Bool {
        return true
    }

    /// Currently selected color of the color control as `UIColor`. Convinience property: Value is backed by and changes are reflected to `selectedHSBColor`.
    var selectedColor: UIColor {
        get {
            return selectedHSBColor.toUIColor()
        }
        set {
            setSelectedHSBColor(selectedColor.hsbColor, isInteractive: false)
        }
    }
}
