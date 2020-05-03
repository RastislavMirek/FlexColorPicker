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
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let (red, green, blue, _) = rgba
        return (red, green, blue)
    }
    
    // neither of the following computed static properties can be made stored property - their current values need to computed at the time of accesing them
    public static var colorPickerBorderColor: UIColor {
        return pickColorForMode(lightModeColor: #colorLiteral(red: 0.7089999914, green: 0.7089999914, blue: 0.7089999914, alpha: 1), darkModeColor: #colorLiteral(red: 0.4203212857, green: 0.4203212857, blue: 0.4203212857, alpha: 1))
    }
    
    public static var colorPickerLabelTextColor: UIColor {
        return pickColorForMode(lightModeColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), darkModeColor: #colorLiteral(red: 0.6395837665, green: 0.6395837665, blue: 0.6395837665, alpha: 1))
    }
    
    public static var colorPickerLightBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.200000003)
    public static var colorPickerThumbViewWideBorderColor: UIColor {
      return pickColorForMode(lightModeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6999999881), darkModeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5995928578))
    }
    
    public static var colorPickerThumbViewWideBorderDarkColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3000000119)

    public var hsbColor: HSBColor {
        return HSBColor(color: self)
    }

    public func hexValue(alwaysIncludeAlpha: Bool = false) -> String {
        let (red, green, blue, alpha) = rgba
        let r = colorComponentToUInt8(red)
        let g = colorComponentToUInt8(green)
        let b = colorComponentToUInt8(blue)
        let a = colorComponentToUInt8(alpha)

        if alpha == 1 && !alwaysIncludeAlpha {
            return String(format: "%02lX%02lX%02lX", r, g, b)
        }
        return String(format: "%02lX%02lX%02lX%02lX", r, g, b, a)
    }

    /// Computes contrast ratio between this color and given color as a value from interval <0, 1> where 0 is contrast ratio of the same colors and 1 is contrast ratio between black and white.
    func constrastRatio(with color: UIColor) -> CGFloat {
        let (r1, g1, b1) = rgb
        let (r2, g2, b2) = color.rgb

        return (abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2)) / 3
    }
}

private func pickColorForMode(lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
    if #available(iOS 13, *) {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? darkModeColor : lightModeColor
        }
    }
    return lightModeColor
}

@inline(__always)
public func colorComponentToUInt8(_ component: CGFloat) -> UInt8 {
    return UInt8(max(0, min(255, round(255 * component))))
}

/// Translates color from HSB system to RGB, given constant Brightness value of 1.
/// @param hue Hue value in range from 0 to 1 (inclusive).
/// @param saturation Saturation value in range from 0 to 1 (inclusive).
/// @param brightness Brightness value in range from 0 to 1 (inclusive).
public func rgbFrom(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let hPrime = Int(hue * 6)
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

//code currently not used but might consider publishing it in the future as a color utilities - leaving here for reference
extension UIColor {
    //    public var alpha: CGFloat {
    //        return rgba.alpha
    //    }
    //
    //    public func withRed(_ red: CGFloat) -> UIColor {
    //        let (_, g, b, a) = self.rgba
    //        return UIColor(red: red, green: g, blue: b, alpha: a)
    //    }
    //
    //    public func withGreen(_ green: CGFloat) -> UIColor {
    //        let (r, _ , b, a) = self.rgba
    //        return UIColor(red: r, green: green, blue: b, alpha: a)
    //    }
    //
    //    public func withBlue(_ blue: CGFloat) -> UIColor {
    //        let (r, g, _, a) = self.rgba
    //        return UIColor(red: r, green: g, blue: blue, alpha: a)
    //    }
}
