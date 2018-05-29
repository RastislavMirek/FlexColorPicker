//
//  HSLColor.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 29/5/18.
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

//import UIKit

public struct HSBColor {
    /// Hue value in interval <0, 1>
    public let hue: CGFloat
    /// Saturation value in interval <0, 1>
    public let saturation: CGFloat
    /// Brightness value in interval <0, 1>
    public let brightness: CGFloat
    /// Alpha value in interval <0, 1>
    public let alpha: CGFloat

    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat = 1) {
//        assert(hue >= 0 && hue <= 1, "Hue value out of range <0, 1>: \(hue)")
//        assert(saturation >= 0 && saturation <= 1, "Saturation value out of range <0, 1>: \(saturation)")
//        assert(brightness >= 0 && brightness <= 1, "Brightness value out of range <0, 1>: \(brightness)")
//        assert(alpha >= 0 && alpha <= 1, "Alpha value out of range <0, 1>: \(alpha)")

        self.hue = max(0, min(1, hue))
        self.saturation = max(0, min(1, saturation))
        self.brightness = max(0, min(1, brightness))
        self.alpha = max(0, min(1, alpha))
    }
}

extension HSBColor {
    var red: CGFloat {
        return toUIColor().rgb.red
    }

    var green: CGFloat {
        return toUIColor().rgb.green
    }

    var blue: CGFloat {
        return toUIColor().rgb.blue
    }

    init(color: UIColor) {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func asTuple() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        return (hue, saturation, brightness, alpha)
    }

    public func asTupleNoAlpha() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        return (hue, saturation, brightness)
    }

    public func toUIColor() -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withHue(_ hue: CGFloat, andSaturation saturation: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withSaturation(_ saturation: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withBrightness(_ brightness: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withRed(_ red: CGFloat) -> HSBColor {
        return toUIColor().withRed(red).hsbColor
    }

    public func withGreen(_ green: CGFloat) -> HSBColor {
        return toUIColor().withGreen(green).hsbColor
    }

    public func withBlue(_ blue: CGFloat) -> HSBColor {
        return toUIColor().withBlue(blue).hsbColor
    }

    public func withAlpha(_ alpha: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

private let multiplyForHashing: CGFloat = 255
extension HSBColor: Hashable {
    public var hashValue: Int {
        var hash = 17
        hash = 31 * hash + Int(hue * multiplyForHashing)
        hash = 31 * hash + Int(saturation * multiplyForHashing)
        hash = 31 * hash + Int(brightness * multiplyForHashing)
        hash = 31 * hash + Int(alpha * multiplyForHashing)
        return hash
    }

    public static func == (l: HSBColor, r: HSBColor) -> Bool {
        return l.hue == r.hue && l.saturation == r.saturation && l.brightness == r.brightness && l.alpha == r.alpha
    }
}
