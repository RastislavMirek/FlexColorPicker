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
open class FlexColorPicker: NSObject {
    public private(set) var colorControls = [ColorControl]()
    open weak var delegate: FlexColorPickerDelegate?

    @IBOutlet public var colorPreview: ColorPreviewWithHex? {
        didSet {
            controlDidSet(newValue: colorPreview, oldValue: oldValue)
        }
    }

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

//    @IBOutlet open var customControl1: AbstractColorControl? {
//        didSet {
//            controlDidSet(newValue: customControl1, oldValue: oldValue)
//        }
//    }
//
//    @IBOutlet open var customControl2: AbstractColorControl? {
//        didSet {
//            controlDidSet(newValue: customControl2, oldValue: oldValue)
//        }
//    }
//
//    @IBOutlet open var customControl3: AbstractColorControl? {
//        didSet {
//            controlDidSet(newValue: customControl3, oldValue: oldValue)
//        }
//    }

    private(set) open var selectedHSBColor: HSBColor = defaultSelectedColor

    @IBInspectable
    open var selectedColor: UIColor {
        get {
            return selectedHSBColor.toUIColor()
        }
        set {
            setColor(newValue.hsbColor, exceptControl: nil)
        }
    }

    open func addControl(_ colorControl: ColorControl) {
        colorControls.append(colorControl)
        colorControl.addTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
        colorControl.addTarget(self, action: #selector(colorConfirmed(by:)), for: .primaryActionTriggered)
    }

    open func removeControl(_ colorControl: ColorControl) {
        colorControls = colorControls.filter { $0 !== colorControl}
        colorControl.removeTarget(self, action: nil, for: [.valueChanged, .primaryActionTriggered])
    }

    @objc
    open func colorPicked(by control: Any?) {
        guard let control = control as? ColorControl else {
            return
        }
        let selectedColor = control.selectedHSBColor
        setColor(selectedColor, exceptControl: control)
        delegate?.colorPicker(self, selectedColor: self.selectedColor, usingControl: control)
    }

    @objc
    open func colorConfirmed(by control: Any?) {
        guard let control = control as? ColorControl else {
            return
        }
        if selectedHSBColor != control.selectedHSBColor {
            colorPicked(by: control)
        }
        delegate?.colorPicker(self, confirmedColor: selectedColor, usingControl: control)
    }

    open func setColor(_ selectedColor: HSBColor, exceptControl control: ColorControl?) {
        for c in colorControls where c !== control {
            c.selectedHSBColor = selectedColor
        }
        selectedHSBColor = selectedColor
    }

    open func controlDidSet(newValue: ColorControl?, oldValue: ColorControl?) {
        oldValue?.remove(from: self)
        newValue?.selectedHSBColor = selectedHSBColor
        newValue?.add(to: self)
    }
}

extension ColorControl {
    func add(to picker: FlexColorPicker) {
        picker.addControl(self)
    }

    func remove(from picker: FlexColorPicker) {
        picker.removeControl(self)
    }
}
