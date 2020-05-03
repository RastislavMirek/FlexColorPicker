//
//  FlexColorPickerController.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 27/5/18.
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

/// Customizable color picker view controller that can be subclassed or used from interface builder (or both). This class basically just delegates its exposed properties to wrapped `ColorPickerController`. It is convinience to support common practise that uses view controllers to attach outlets to.
///
/// When color controls are set to properties of this view controller via code or interface builder, they become managed by underlaying instance of `ColorPickerController` and thus their value (selected color) is synchronized.
///
/// **See also:**
/// [DefaultColorPickerViewController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/DefaultColorPickerViewController.swift), [ColorPickerController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/ColorPickerController.swift)
open class CustomColorPickerViewController: UIViewController, ColorPickerControllerProtocol {

    /// Color picker controller that synchonizes color controls. This is backing controller that this controller delegates interaction logic to. It is also instance of `ColorPickerController` passed to delegate calls.
    public let colorPicker = ColorPickerController()

    /// Color picker delegate that gets called when selected color is updated or confirmed. The delegate is not retained. This is just convinience property and getting or setting it is equivalent to getting or setting `colorPicker.delegate`.
    open var delegate: ColorPickerDelegate? {
        get {
            return colorPicker.delegate
        }
        set {
            colorPicker.delegate = newValue
        }
    }

    /// Color currently selected by color picker.
    @IBInspectable
    open var selectedColor: UIColor {
        get {
            return colorPicker.selectedColor
        }
        set {
            colorPicker.selectedColor = newValue
        }
    }

    @IBOutlet public var colorPreview: ColorPreviewWithHex? {
        get {
            return colorPicker.colorPreview
        }
        set {
            colorPicker.colorPreview = newValue
        }
    }

    @IBOutlet open var radialHsbPalette: RadialPaletteControl? {
        get {
            return colorPicker.radialHsbPalette
        }
        set {
            colorPicker.radialHsbPalette = newValue
        }
    }

    @IBOutlet open var rectangularHsbPalette: RectangularPaletteControl? {
        get {
            return colorPicker.rectangularHsbPalette
        }
        set {
            colorPicker.rectangularHsbPalette = newValue
        }
    }

    @IBOutlet open var saturationSlider: SaturationSliderControl? {
        get {
            return colorPicker.saturationSlider
        }
        set {
            colorPicker.saturationSlider = newValue
        }
    }

    @IBOutlet open var brightnessSlider: BrightnessSliderControl? {
        get {
            return colorPicker.brightnessSlider
        }
        set {
            colorPicker.brightnessSlider = newValue
        }
    }

    @IBOutlet open var redSlider: RedSliderControl? {
        get {
            return colorPicker.redSlider
        }
        set {
            colorPicker.redSlider = newValue
        }
    }

    @IBOutlet open var greenSlider: GreenSliderControl? {
        get {
            return colorPicker.greenSlider
        }
        set {
            colorPicker.greenSlider = newValue
        }
    }

    @IBOutlet open var blueSlider: BlueSliderControl? {
        get {
            return colorPicker.blueSlider
        }
        set {
            colorPicker.blueSlider = newValue
        }
    }

    @IBOutlet open var customControl1: AbstractColorControl? {
        get {
            return colorPicker.customControl1
        }
        set {
            colorPicker.customControl1 = newValue
        }
    }

    @IBOutlet open var customControl2: AbstractColorControl? {
        get {
            return colorPicker.customControl2
        }
        set {
            colorPicker.customControl2 = newValue
        }
    }

    @IBOutlet open var customControl3: AbstractColorControl? {
        get {
            return colorPicker.customControl3
        }
        set {
            colorPicker.customControl3 = newValue
        }
    }

    open override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        super.viewDidLoad()
    }
}
