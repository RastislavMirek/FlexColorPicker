//
//  UIColorExtensions.swift
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

extension UIColor {
//    convenience init(hue: CGFloat, saturation: CGFloat) {
//        super.init(hue: hue, saturation: saturation, brightness: 1, alpha: 1)
//    }
//
    public var rgb: (red: CGFloat, green: CGFloat, b: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, a: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &a)
        return (red, green, blue)
    }

    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }

    public var hsb: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, a: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &a)
        return (hue, saturation, brightness)
    }

    public var alpha: CGFloat {
        return cgColor.alpha
    }

//    public func colorWithRed(_ red: CGFloat) -> UIColor {
//        let rgb = self.rgb
//        return UIColor(r: red, g: rgb.g, b: rgb.b, alpha: alpha)
//    }
//
//    public func colorWithGreen(_ green: CGFloat) -> UIColor {
//        let rgb = self.rgb
//        return UIColor(r: rgb.red, g: green, b: rgb.blue, alpha: alpha)
//    }
//
//    public func colorWithBlue(_ blue: CGFloat) -> UIColor {
//        let rgb = self.rgb
//        return UIColor(r: rgb.r, g: rgb.g, b: blue, alpha: alpha)
//    }

    public func withBrightness(_ brightness: CGFloat) -> UIColor {
        let (h, s, _) = self.hsb
        return  UIColor(hue: h, saturation: s, brightness: brightness, alpha: alpha)
    }
}

/// Translates color from HSB system to RGB, given constant Brightness value of 1.
/// @param hue Hue value in range from 0 to 1.
/// @saturation Saturation value in range from 0 to 1.
public func rgbFrom(hue: CGFloat, saturation: CGFloat, brightness: CGFloat = 1) -> (red: CGFloat, green: CGFloat, b: CGFloat) {
    let hPrime: Int = Int(hue * 6)
    let f = hue * 6 - CGFloat(hPrime)
    let p = brightness * (1 - saturation)
    let q = brightness * (1 - f * saturation)
    let t = brightness * (1 - (1 - f) * saturation)

    switch hPrime % 6 {
    case 0: return (brightness, t, p)
    case 1: return (q, brightness, p)
    case 2: return (p, brightness, t)
    case 3: return (p, q, brightness)
    case 4: return (t, p, brightness)
    default: return (brightness, p, q)
    }
}
