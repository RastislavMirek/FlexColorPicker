//
//  ColorPicker.swift
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

open class FlexColorPicker: NSObject {
    open private(set) var colorControls = [ColorPickerControl]()

    @IBOutlet public var radialPreview: RadialColorPreview?

    @IBOutlet open var radialHsbPalete: ColorPaletteControl? {
        didSet {
            oldValue?.remove(from: self)
            radialHsbPalete?.add(to: self)
        }
    }

    @IBOutlet open var saturationSlider: ColorSliderControl? {
        didSet {
            saturationSlider?.colorSlider = SaturationSlider()
            sliderDidSet(newValue: saturationSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var brightnessSlider: ColorSliderControl? {
        didSet {
            sliderDidSet(newValue: brightnessSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var redSlider: ColorSliderControl? {
        didSet {
            redSlider?.colorSlider = RedSlider()
            sliderDidSet(newValue: redSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var greenSlider: ColorSliderControl? {
        didSet {
            greenSlider?.colorSlider = GreenSlider()
            sliderDidSet(newValue: greenSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var blueSlider: ColorSliderControl? {
        didSet {
            blueSlider?.colorSlider = BlueSlider()
            sliderDidSet(newValue: blueSlider, oldValue: oldValue)
        }
    }

    open func addControl(_ colorControl: ColorPickerControl) {
        colorControls.append(colorControl)
        colorControl.addTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
    }

    open func removeControl(_ colorControl: ColorPickerControl) {
        colorControls = colorControls.filter { $0 !== colorControl}
        colorControl.removeTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
    }

    @objc
    open func colorPicked(by control: Any?) {
        guard let control = control as? ColorPickerControl else {
            return
        }
        let selectedColor = control.selectedHSBColor
        for control in colorControls.filter({ $0 !== control }) {
            control.selectedHSBColor = selectedColor
        }
        radialPreview?.selectedColor = selectedColor.toUIColor()
    }

    open func sliderDidSet(newValue: ColorPickerControl?, oldValue: ColorPickerControl?) {
        oldValue?.remove(from: self)
        newValue?.add(to: self)
    }
}

public extension ColorPickerControl {
    func add(to picker: FlexColorPicker) {
        picker.addControl(self)
    }

    func remove(from picker: FlexColorPicker) {
        picker.removeControl(self)
    }
}
