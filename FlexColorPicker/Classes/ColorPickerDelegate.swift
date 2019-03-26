//
//  FlexColorPickerDelegate.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 4/6/18.
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

/// Delegate that gets called when color picker's value (picked color) is changed or when user finishes color picking.
///
/// **See also:**
/// [DefaultColorPickerViewController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/DefaultColorPickerViewController.swift), [ColorPickerController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/ColorPickerController.swift)
public protocol ColorPickerDelegate: class {

    /// Called when a user changes color picker's current selected color.
    ///
    /// Current selected color can change frequently. If you are just interested in final selected color consider only using `colorPicker(_:, confirmedColor:, usingControl:)`
    ///
    /// - Parameters:
    ///   - colorPicker: Controller of the color picker whose `selectedColor` has changed. This is the representiation (principal class) of a color picker instance.
    ///   - selectedColor: New value of currently selected color.
    ///   - usingControl: The color control that was used to pick the new `selectedColor`.
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl)

    /// Called when a user has finished picking a color.
    ///
    /// - Parameters:
    ///   - colorPicker: Controller of color picker that finished picking color. This is the representiation (principal class) of color picker instance.
    ///   - confirmedColor: The final selected color.
    ///   - usingControl: The control that was used to confirm selected color (control that sent `primaryActionTriggered` event).
    func colorPicker(_ colorPicker: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl)
}
