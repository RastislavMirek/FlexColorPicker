//
//  ComponentSliderControls.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 2/6/18.
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

/// Color slider that allows to change saturation (in terms of HSB color model) of currently selected color by panning the slider line or by tapping it.
///
/// Tapping left end of the slider will select slider's current color modified to have 0% saturation. Tapping right edge of the slider will select current color modified to have 100% saturation.
@IBDesignable
final public class SaturationSliderControl: ColorSliderControl {
    public override func commonInit() {
        sliderDelegate = SaturationSliderDelegate()
        super.commonInit()
    }
}

/// Color slider that allows to change brightness (in terms of HSB color model) of currently selected color by panning the slider line or by tapping it.
///
/// Tapping left end of the slider will select slider's current color modified to have 100% brightness. Tapping right edge of the slider will select current color modified to have 0% brightness.
final public class BrightnessSliderControl: ColorSliderControl {
    public override func commonInit() {
        sliderDelegate = BrightnessSliderDelegate()
        super.commonInit()
    }
}

/// Color slider that allows to change red component (in terms of RGB color model) of currently selected color by panning the slider line or by tapping it.
///
/// Tapping left end of the slider will select slider's current color modified to have 0% red. Tapping right edge of the slider will select current color modified to have 100% red.
final public class RedSliderControl: ColorSliderControl {
    public override func commonInit() {
        sliderDelegate = RedSliderDelegate()
        super.commonInit()
    }
}

/// Color slider that allows to change green component (in terms of RGB color model) of currently selected color by panning the slider line or by tapping it.
///
/// Tapping left end of the slider will select slider's current color modified to have 0% green. Tapping right edge of the slider will select current color modified to have 100% green.
final public class GreenSliderControl: ColorSliderControl {
    public override func commonInit() {
        sliderDelegate = GreenSliderDelegate()
        super.commonInit()
    }
}

/// Color slider that allows to change blue component (in terms of RGB color model) of currently selected color by panning the slider line or by tapping it.
///
/// Tapping left end of the slider will select slider's current color modified to have 0% blue. Tapping right edge of the slider will select current color modified to have 100% blue.
final public class BlueSliderControl: ColorSliderControl {
    public override func commonInit() {
        sliderDelegate = BlueSliderDelegate()
        super.commonInit()
    }
}
