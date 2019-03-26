//
//  RadialHSBPaletteDelegate.swift
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

open class RadialHSBPaletteDelegate: ColorPaletteDelegate {
    public private(set) var diameter: CGFloat = 0
    public private(set) var radius: CGFloat = 0
    public private(set) var midX: CGFloat = 0
    public private(set) var midY: CGFloat = 0
    public private(set) var ceiledDiameter: Int = 0

    open var size: CGSize = .zero {
        didSet {
            let diameter = min(size.width, size.height)
            self.diameter = diameter
            self.radius = diameter / 2
            self.midX = diameter / 2 + min(0, (size.width - diameter) / 2)
            self.midY = diameter / 2 + min(0, (size.height - diameter) / 2)
            self.ceiledDiameter = Int(ceil(diameter))
        }
    }

    public init() {}

    @inline(__always)
    open func hueAndSaturation(at point: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {
        let dy = (point.y - midY) / radius
        let dx = (point.x - midX) / radius
        let distance = sqrt(dx * dx + dy * dy)
        if distance <= 0 {
            return (0, 0)
        }
        let hue = acos(dx / distance) / CGFloat.pi / 2
        return (dy < 0 ? 1 - hue : hue, min(1, distance))
    }

    open func modifiedColor(from color: HSBColor, with point: CGPoint) -> HSBColor {
        let (hue, saturation) = hueAndSaturation(at: point)
        return color.withHue(hue, andSaturation: saturation)
    }

    open func foregroundImage() -> UIImage {
        var imageData = [UInt8](repeating: 255, count: (4 * ceiledDiameter * ceiledDiameter))
        for i in 0 ..< ceiledDiameter{
              for j in 0 ..< ceiledDiameter {
                let index = 4 * (i * ceiledDiameter + j)
                let (hue, saturation) = hueAndSaturation(at: CGPoint(x: j, y: i)) // rendering image transforms it as it it was mirrored around x = -y axis - adjusting for it by switching i and j here
                let (r, g, b) = rgbFrom(hue: hue, saturation: saturation, brightness: 1)
                imageData[index] = colorComponentToUInt8(r)
                imageData[index + 1] = colorComponentToUInt8(g)
                imageData[index + 2] = colorComponentToUInt8(b)
                imageData[index + 3] = 255
            }
        }

        guard let image = UIImage(rgbaBytes: imageData, width: ceiledDiameter, height: ceiledDiameter) else {
            return UIImage()
        }

        // clip the image to circle
        let imageRect = CGRect(x: 0,y: 0, width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, 0)
        UIBezierPath(ovalIn: imageRect).addClip()
        image.draw(in: imageRect)
        defer {
            UIGraphicsEndImageContext()
        }
        if let clippedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return clippedImage
        }
        return UIImage()
    }

    open func backgroundImage() -> UIImage? {
        let imageSize = CGSize(width: diameter, height: diameter)
        if imageSize == .zero {
            return nil
        }
        return UIImage.drawImage(ofSize: imageSize, path: UIBezierPath(ovalIn: CGRect(origin: .zero, size: imageSize)), fillColor: .black)
    }

    open func closestValidPoint(to point: CGPoint) -> CGPoint {
        let distance = point.distanceTo(x: midX, y: midY)
        if distance <= radius {
            return point
        }
        let x = midX + radius * ((point.x - midX) / distance)
        let y = midY + radius * ((point.y - midY) / distance)
        return CGPoint(x: x, y: y)
    }

    open func positionAndAlpha(for color: HSBColor) -> (position: CGPoint, foregroundImageAlpha: CGFloat) {
        let (hue, saturation, brightness) = color.asTupleNoAlpha()
        let radius = saturation * self.radius
        let x = self.radius + radius * cos(hue * 2 * CGFloat.pi)
        let y = self.radius + radius * sin(hue * 2 * CGFloat.pi)
        return (CGPoint(x: x, y: y), brightness)
    }

    open func supportedContentMode(for contentMode: UIView.ContentMode) -> UIView.ContentMode {
        switch contentMode {
        case .redraw, .scaleToFill, .scaleAspectFill: return .scaleAspectFit
        default: return contentMode
        }
    }
}
