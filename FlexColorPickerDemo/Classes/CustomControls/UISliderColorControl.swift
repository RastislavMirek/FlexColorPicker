//
//  UISliderColorControl.swift
//  FlexColorPickerDemo
//
//  Created by Rastislav Mirek on 9/6/18.
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
import FlexColorPicker

@IBDesignable
class UISliderColorControl: UISlider, ColorControl {
    var selectedHSBColor: HSBColor = UIColor.white.hsbColor
    var delegate: ColorSliderDelegate {
        return BrightnessSliderDelegate()
    }

    static var canConfirmColor: Bool {
        return false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    func commonInit() {
        minimumTrackTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive: Bool) {
        selectedHSBColor = hsbColor
        let (value, _, _) = delegate.valueAndGradient(for: hsbColor)
        self.value = Float(value)
        thumbTintColor = hsbColor.toUIColor()
    }

    @objc
    func valueChanged() {
        selectedHSBColor = delegate.modifiedColor(from: selectedHSBColor, with: CGFloat(value))
        setSelectedHSBColor(selectedHSBColor, isInteractive: true)
    }
}

final class HueUISliderColorControl: UISliderColorControl {
    override var delegate: ColorSliderDelegate {
        return HueColorSliderDelegate()
    }
}

final class SaturationUISliderColorControl: UISliderColorControl {
    override var delegate: ColorSliderDelegate {
        return SaturationSliderDelegate()
    }

    override func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive: Bool) {
        super.setSelectedHSBColor(hsbColor, isInteractive: isInteractive)
        let (_, _, maxSaturationColor) = delegate.valueAndGradient(for: hsbColor)
        maximumTrackTintColor = maxSaturationColor
    }
}

extension UISliderColorControl {
    @IBInspectable
    var selectedColor: UIColor {
        get {
            return selectedHSBColor.toUIColor()
        }
        set {
            selectedHSBColor = newValue.hsbColor
        }
    }
}
