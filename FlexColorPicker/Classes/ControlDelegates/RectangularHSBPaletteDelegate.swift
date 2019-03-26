//
//  RectangularHSBPaletteDelegate.swift
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

import Foundation

open class RectangularHSBPaletteDelegate: ColorPaletteDelegate {
    public private(set) var intWidth = 0
    public private(set) var intHeight = 0

    public var size: CGSize = .zero {
        didSet {
            intWidth = Int(size.width)
            intHeight = Int(size.height)
        }
    }
     /// When `true` the different values of color hue will correspond to different coordinates along x axis (that means that vertical lines will have same hue but different saturation). When `false`, different values of color hue will correspond to different coordinates along y axis.
    public var hueHorizontal = true

    public init() {}

    @inline(__always)
    open func hueAndSaturation(at point: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        let hue = hueHorizontal ? point.x / size.width : point.y / size.height
        let saturation = hueHorizontal ? point.y / size.height : point.x / size.width
        return (max (0, min(1, hue)), 1 - max(0, min(1, saturation)))
    }

    public func modifiedColor(from color: HSBColor, with point: CGPoint) -> HSBColor {
        let (hue, saturation) = hueAndSaturation(at: point)
        return color.withHue(hue, andSaturation: saturation)
    }

    open func foregroundImage() -> UIImage {
        var imageData = [UInt8](repeating: 1, count: (4 * intWidth * intHeight))
        for i in 0 ..< intWidth {
            for j in 0 ..< intHeight {
                let index = 4 * (i + j * intWidth)
                let (hue, saturation) = hueAndSaturation(at: CGPoint(x: i, y: j)) // rendering image transforms it as it it was mirrored around x = -y axis - adjusting for it by switching i and j here
                let (r, g, b) = rgbFrom(hue: hue, saturation: saturation, brightness: 1)
                imageData[index] = colorComponentToUInt8(r)
                imageData[index + 1] = colorComponentToUInt8(g)
                imageData[index + 2] = colorComponentToUInt8(b)
                imageData[index + 3] = 255
            }
        }
        return UIImage(rgbaBytes: imageData, width: intWidth, height: intHeight) ?? UIImage()
    }

    open func backgroundImage() -> UIImage? {
        let size = CGSize(width: intWidth, height: intHeight) // overriding size property to get same size of background image in situations when foreground image dimestions are rounded down to int
        if size.width == 0 || size.height == 0 {
            return nil
        }
        return UIImage.drawImage(ofSize: size, path: UIBezierPath(rect: CGRect(origin: .zero, size: size)), fillColor: .black)
    }

    open func closestValidPoint(to point: CGPoint) -> CGPoint {
        return CGPoint(x: min(size.width, max(0, point.x)), y: min(size.height, max(0, point.y)))
    }

    open func positionAndAlpha(for color: HSBColor) -> (position: CGPoint, foregroundImageAlpha: CGFloat) {
        let (hue, saturation, brightness) = color.asTupleNoAlpha()
        return (CGPoint(x: (hueHorizontal ? hue : 1 - saturation) * size.width, y: (hueHorizontal ? 1 - saturation : hue) * size.height), brightness)
    }

    open func supportedContentMode(for contentMode: UIView.ContentMode) -> UIView.ContentMode {
        return contentMode
    }
}
