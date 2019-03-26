//
//  ComponentSliderDelagates.swift
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

import UIKit

public struct SaturationSliderDelegate: ColorSliderDelegate {
    public init() {}

    public func modifiedColor(from color: HSBColor, with value: CGFloat) -> HSBColor {
        return color.withSaturation(value)
    }

    public func valueAndGradient(for color: HSBColor) -> (value: CGFloat, gradientStart: UIColor, gradientEnd: UIColor) {
        return (color.saturation, color.withSaturation(0).toUIColor(), color.withSaturation(1).toUIColor())
    }
}

public struct BrightnessSliderDelegate: ColorSliderDelegate {
    public init() {}

    public func modifiedColor(from color: HSBColor, with value: CGFloat) -> HSBColor {
        return color.withBrightness(1 - value)
    }

    public func valueAndGradient(for color: HSBColor) -> (value: CGFloat, gradientStart: UIColor, gradientEnd: UIColor) {
        return (1 - color.brightness, color.withBrightness(1).toUIColor(), color.withBrightness(0).toUIColor())
    }
}

public struct RedSliderDelegate: ColorSliderDelegate {
    public init() {}

    public func modifiedColor(from color: HSBColor, with value: CGFloat) -> HSBColor {
        return color.withRed(value)
    }

    public func valueAndGradient(for color: HSBColor) -> (value: CGFloat, gradientStart: UIColor, gradientEnd: UIColor) {
        return (color.rgb.red, color.withRed(0).toUIColor(), color.withRed(1).toUIColor())
    }
}

public struct GreenSliderDelegate: ColorSliderDelegate {
    public init() {}

    public func modifiedColor(from color: HSBColor, with value: CGFloat) -> HSBColor {
        return color.withGreen(value)
    }

    public func valueAndGradient(for color: HSBColor) -> (value: CGFloat, gradientStart: UIColor, gradientEnd: UIColor) {
        return (color.rgb.green, color.withGreen(0).toUIColor(), color.withGreen(1).toUIColor())
    }
}

public struct BlueSliderDelegate: ColorSliderDelegate {
    public init() {}
    
    public func modifiedColor(from color: HSBColor, with value: CGFloat) -> HSBColor {
        return color.withBlue(value)
    }

    public func valueAndGradient(for color: HSBColor) -> (value: CGFloat, gradientStart: UIColor, gradientEnd: UIColor) {
        return (color.rgb.blue, color.withBlue(0).toUIColor(), color.withBlue(1).toUIColor())
    }
}
