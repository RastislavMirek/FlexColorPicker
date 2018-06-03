//
//  ColorPicker.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 28/5/18.
//
//    MIT License
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

@IBDesignable
internal class FlexColorPicker: NSObject {
    open private(set) var colorControls = [ColorPickerControl]()

    @IBOutlet public var colorPreview: ColorPreviewWithHex?

    @IBOutlet open var radialHsbPalete: ColorPaletteControl? {
        didSet {
            controlDidSet(newValue: radialHsbPalete, oldValue: oldValue)
        }
    }

    @IBOutlet open var saturationSlider: SaturationSliderControl? {
        didSet {
            controlDidSet(newValue: saturationSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var brightnessSlider: BrightnessSliderControl? {
        didSet {
            controlDidSet(newValue: brightnessSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var redSlider: RedSliderControl? {
        didSet {
            controlDidSet(newValue: redSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var greenSlider: GreenSliderControl? {
        didSet {
            controlDidSet(newValue: greenSlider, oldValue: oldValue)
        }
    }

    @IBOutlet open var blueSlider: BlueSliderControl? {
        didSet {
            controlDidSet(newValue: blueSlider, oldValue: oldValue)
        }
    }

    private(set) open var selectedHSBColor: HSBColor = defaultSelectedColor

    @IBInspectable
    public(set) open var selectedColor: UIColor {
        get {
            return selectedHSBColor.toUIColor()
        }
        set {
            setColor(newValue.hsbColor, exceptControl: nil)
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
        setColor(selectedColor, exceptControl: control)
    }

    open func setColor(_ selectedColor: HSBColor, exceptControl control: ColorPickerControl?) {
        for c in colorControls where c !== control {
            c.selectedHSBColor = selectedColor
        }
        selectedHSBColor = selectedColor
        colorPreview?.selectedColor = selectedColor.toUIColor()
    }

    open func controlDidSet(newValue: ColorPickerControl?, oldValue: ColorPickerControl?) {
        oldValue?.remove(from: self)
        newValue?.selectedHSBColor = selectedHSBColor
        newValue?.add(to: self)
    }
}

extension ColorPickerControl {
    func add(to picker: FlexColorPicker) {
        picker.addControl(self)
    }

    func remove(from picker: FlexColorPicker) {
        picker.removeControl(self)
    }
}
