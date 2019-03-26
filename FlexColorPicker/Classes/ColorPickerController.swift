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

import UIKit

/// Principal class and the controller of FlexColorPicker (not to be confused with view controllers). Synchronizes selected color of separate color controls so they can cooperate as one system. Also responsible for notifying client code via delegate.
///
/// This can also be used from interface builder (e.g. a storyboard) as a class of custom object and the controls can be added to the controler by using Connection Inspector's outlets.
///
/// **See also:**
/// [CustomColorPickerViewController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/CustomColorPickerViewController.swift), [DefaultColorPickerViewController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/DefaultColorPickerViewController.swift)
open class ColorPickerController: NSObject, ColorPickerControllerProtocol { //subclassing NSObject is required to use this class as object in interface builder
    /// HSB representation of currently selected color.
    public private(set) var selectedHSBColor: HSBColor = defaultSelectedColor
    /// Array of all color controls currently managed by the color picker. These are the controls that the `ColorPickerController` receives updates from and synchonizes with each other.
    public private(set) var colorControls = [ColorControl]()
    /// Color picker delegate that gets called when selected color is updated or confirmed. The delegate is not retained.
    open weak var delegate: ColorPickerDelegate?

    /// Color currently selected by color picker.
    @IBInspectable
    open var selectedColor: UIColor {
        get {
            return selectedHSBColor.toUIColor()
        }
        set {
            setColor(newValue.hsbColor, exceptControl: nil, isInteractive: false)
        }
    }

    @IBOutlet open var colorPreview: ColorPreviewWithHex? {
        didSet {
            controlDidSet(newValue: colorPreview, oldValue: oldValue)
        }
    }

    @IBOutlet open var radialHsbPalette: RadialPaletteControl? {
        didSet {
            controlDidSet(newValue: radialHsbPalette, oldValue: oldValue)
        }
    }

    @IBOutlet open var rectangularHsbPalette: RectangularPaletteControl? {
        didSet {
            controlDidSet(newValue: rectangularHsbPalette, oldValue: oldValue)
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

    @IBOutlet open var customControl1: AbstractColorControl? {
        didSet {
            controlDidSet(newValue: customControl1, oldValue: oldValue)
        }
    }

    @IBOutlet open var customControl2: AbstractColorControl? {
        didSet {
            controlDidSet(newValue: customControl2, oldValue: oldValue)
        }
    }

    @IBOutlet open var customControl3: AbstractColorControl? {
        didSet {
            controlDidSet(newValue: customControl3, oldValue: oldValue)
        }
    }

    /// Adds a `ColorControl` to be managed. Color updates of added control are synchronized with other `ColorControl`s managed by this `ColorPickerController`. Overrides must call super implementation.
    ///
    /// - Parameter colorControl: Control to be added.
    open func addControl(_ colorControl: ColorControl) {
        colorControls.append(colorControl)
        colorControl.addTarget(self, action: #selector(colorPicked(by:)), for: .valueChanged)
        if type(of: colorControl).canConfirmColor {
            colorControl.addTarget(self, action: #selector(colorConfirmed(by:)), for: .primaryActionTriggered)
        }
    }


    /// Removes a `ColorControl` so that is no longer managed. Color updates of removed control will no longer be synchronized with other `ColorControl`s managed by this `ColorPickerController`. Overrides must call super implementation.
    ///
    /// - Parameter colorControl: Control to be removed.
    open func removeControl(_ colorControl: ColorControl) {
        colorControls = colorControls.filter { $0 !== colorControl}
        colorControl.removeTarget(self, action: nil, for: [.valueChanged, .primaryActionTriggered])
    }

    /// Called by a managed color control when new color is picked (valueChanged action occures). Distributes the event to all other color controls and notifies the `delegate`.
    ///
    /// - Parameter control: The control where color change originated.
    @objc
    open func colorPicked(by control: Any?) {
        guard let control = control as? ColorControl else {
            return
        }
        let selectedColor = control.selectedHSBColor
        setColor(selectedColor, exceptControl: control, isInteractive: true)
        delegate?.colorPicker(self, selectedColor: self.selectedColor, usingControl: control)
    }


    /// Called by a managed color control when user confirms currently selected color using that control (primaryActionTriggered event occures). Notifies the delegate.
    ///
    /// - Parameter control: Control used to confirm currently selected color.
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


    /// Override point, should not be called directly. Synchronizes `selectedHSBColor` values of all managed color controls.
    ///
    /// - Parameters:
    ///   - selectedColor: New value of selected color to be set to all managed controls.
    ///   - control: The source control of new value of selected color, if any.
    ///   - isInteractive: `true` if the value change of selected color is caused by user interaction with one of the color controls.
    open func setColor(_ selectedColor: HSBColor, exceptControl control: ColorControl?, isInteractive: Bool) {
        for c in colorControls where c !== control {
            c.setSelectedHSBColor(selectedColor, isInteractive: isInteractive)
        }
        selectedHSBColor = selectedColor
    }


    /// Adds a new color control to be managed by this `ColorPickerController` and removes an old one. Color updates of added control are synchronized with other `ColorControl`s managed by this controller.
    ///
    /// - Parameters:
    ///   - newValue: New color control to be added.
    ///   - oldValue: Color control to be removed.
    open func controlDidSet(newValue: ColorControl?, oldValue: ColorControl?) {
        oldValue?.remove(from: self)
        newValue?.setSelectedHSBColor(selectedHSBColor, isInteractive: false)
        newValue?.add(to: self)
    }
}

extension ColorControl {
    func add(to picker: ColorPickerController) {
        picker.addControl(self)
    }

    func remove(from picker: ColorPickerController) {
        picker.removeControl(self)
    }
}
