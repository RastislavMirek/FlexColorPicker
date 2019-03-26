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

import UIKit

/// Represetation of a color in HSB (Hue, Saturation, Brightness) color model. This model can be directly converted to and from RGB model.
/// - Note: HSB is better representation for color picker than RGB as its components often maps directly to user interactions.
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
        self.hue = max(0, min(1, hue))
        self.saturation = max(0, min(1, saturation))
        self.brightness = max(0, min(1, brightness))
        self.alpha = max(0, min(1, alpha))
    }
}

extension HSBColor {

    /// RGB representation of this HSBColor
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        return rgbFrom(hue: hue, saturation: saturation, brightness: brightness)
    }

    /// Initializes `HSBColor` instance that represents the same color as passed color.
    ///
    /// - Parameter color: A color to construct an equivalent `HSBColor` from.
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


    /// Returs `UIColor` that represents equivalent color as this instance.
    ///
    /// - Returns: `UIColor` equivalent to this `HSBColor`.
    public func toUIColor() -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withHue(_ hue: CGFloat, andSaturation saturation: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withSaturation(_ saturation: CGFloat, andBrightness brightness: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withHue(_ hue: CGFloat, andBrightness brightness: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withHue(_ hue: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withSaturation(_ saturation: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    public func withBrightness(_ brightness: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// Computes new HSL color based on given RGB values while keeping alpha value of original color.
    /// - Note: If the RGB values given specify achromatic color the hue of original color is kept.
    /// - Parameter red: Red component of new color specified as value from <0, 1>
    /// - Parameter green: Green component of new color specified as value from <0, 1>
    /// - Parameter blue: Blue component of new color specified as value from <0, 1>
    /// - Returns: Color specified by the given RGB values with the same alpha as current color.
    public func withRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> HSBColor {
        let red_ = min(1, max(0, red))
        let green_ = min(1, max(0, green))
        let blue_ = min(1, max(0, blue))

        let max_ = fmax (red_, fmax(green_, blue_))
        let min_ = fmin(red_, fmin(green_, blue_))

        var h: CGFloat = 0, b = max_
        let d = max_ - min_
        let s = max_ == 0 ? 0 : d / max_

        guard max_ != min_ else {
            return HSBColor(hue: hue, saturation: 1 - max_, brightness: b, alpha: alpha) //achromatic: keep the original hue (that is why this is an extension)
        }
        if max_ == red_ {
            h = (green_ - blue) / d + (green_ < blue_ ? 6 : 0)
        }
        else if max_ == green_ {
            h = (blue_ - red_) / d + 2
        }
        else if max_ == blue_ {
            h = (red_ - green_) / d + 4
        }
        h /= 6
        return HSBColor(hue: h, saturation: s, brightness: b, alpha: alpha)
    }

    public func withRed(_ red: CGFloat) -> HSBColor {
        let (_, g, b) = rgb
        return withRGB(red: red, green: g, blue: b)
    }

    public func withGreen(_ green: CGFloat) -> HSBColor {
        let (r, _, b) = rgb
        return withRGB(red: r, green: green, blue: b)
    }

    public func withBlue(_ blue: CGFloat) -> HSBColor {
        let (r, g, _) = rgb
        return withRGB(red: r, green: g, blue: blue)
    }

    public func withAlpha(_ alpha: CGFloat) -> HSBColor {
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}

extension HSBColor: Hashable {
    public static func == (l: HSBColor, r: HSBColor) -> Bool {
        return l.hue == r.hue && l.saturation == r.saturation && l.brightness == r.brightness && l.alpha == r.alpha
    }
}
