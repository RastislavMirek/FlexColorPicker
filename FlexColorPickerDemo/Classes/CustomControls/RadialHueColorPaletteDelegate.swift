//
//  RadialHueControlDelegate.swift
//  FlexColorPickerDemo
//
//  Created by Rastislav Mirek on 8/6/18.
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

import FlexColorPicker

//This class has some of code common with RadialHSBPalette but is it not its specialization so subclassing it would be incorrect object model
class RadialHueColorPaletteDelegate: ColorPaletteDelegate {

    private(set) var diameter: CGFloat = 0
    private(set) var radius: CGFloat = 0
    private(set) var midX: CGFloat = 0
    private(set) var midY: CGFloat = 0
    private(set) var ceiledDiameter: Int = 0

    var size: CGSize = .zero {
        didSet {
            let diameter = min(size.width, size.height)
            self.diameter = diameter
            self.radius = diameter / 2
            self.midX = diameter / 2 + min(0, (size.width - diameter) / 2)
            self.midY = diameter / 2 + min(0, (size.height - diameter) / 2)
            self.ceiledDiameter = Int(ceil(diameter))
        }
    }

    var indicatorDistance: CGFloat {
        return radius - radialHuePaletteStripWidth / 2
    }

    private func hue(at point: CGPoint) -> CGFloat {
        let dy = (point.y - midY) / radius
        let dx = (point.x - midX) / radius
        let distance = sqrt(dx * dx + dy * dy)
        if distance <= 0 {
            return 0
        }
        let hue = acos(dx / distance) / CGFloat.pi / 2
        return dy < 0 ? 1 - hue : hue
    }

    func modifiedColor(from color: HSBColor, with point: CGPoint) -> HSBColor {
        return color.withHue(hue(at: point))
    }

    func foregroundImage() -> UIImage {
        var imageData = [UInt8](repeating: 255, count: (4 * ceiledDiameter * ceiledDiameter))
        for i in 0 ..< ceiledDiameter{
            for j in 0 ..< ceiledDiameter {
                let index = 4 * (i * ceiledDiameter + j)
                let hue = self.hue(at: CGPoint(x: j, y: i)) // rendering image transforms it as it it was mirrored around x = -y axis - adjusting for it by switching i and j here
                let (r, g, b) = rgbFrom(hue: hue, saturation: 1, brightness: 1)
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
        let holeRect = CGRect(x: radialHuePaletteStripWidth, y: radialHuePaletteStripWidth, width: diameter - 2 * radialHuePaletteStripWidth, height: diameter - 2 * radialHuePaletteStripWidth)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(UIBezierPath(ovalIn: imageRect).cgPath)
        context?.addPath(UIBezierPath(ovalIn: holeRect).cgPath)
        context?.clip(using: .evenOdd)
        image.draw(in: imageRect)
        defer {
            UIGraphicsEndImageContext()
        }
        if let clippedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return clippedImage
        }
        return UIImage()
    }

    func backgroundImage() -> UIImage? {
        return nil
    }

    func closestValidPoint(to point: CGPoint) -> CGPoint {
        let distance = point.distanceTo(x: midX, y: midY)
        let x = midX + indicatorDistance * ((point.x - midX) / distance)
        let y = midY + indicatorDistance * ((point.y - midY) / distance)
        return CGPoint(x: x, y: y)
    }

    func positionAndAlpha(for color: HSBColor) -> (position: CGPoint, foregroundImageAlpha: CGFloat) {
        let (hue, _, _) = color.asTupleNoAlpha()
        let x = radius + radius * cos(hue * 2 * CGFloat.pi)
        let y = radius + radius * sin(hue * 2 * CGFloat.pi)
        return (closestValidPoint(to: CGPoint(x: x, y: y)), 1)
    }

    func supportedContentMode(for contentMode: UIView.ContentMode) -> UIView.ContentMode {
        switch contentMode {
        case .redraw, .scaleToFill, .scaleAspectFill: return .scaleAspectFit
        default: return contentMode
        }
    }
}

extension CGPoint {
    func distanceTo(x: CGFloat, y: CGFloat) -> CGFloat {
        let dx = self.x - x
        let dy = self.y - y
        return sqrt(dx * dx + dy * dy)
    }

    func distance(to point: CGPoint) -> CGFloat {
        return distanceTo(x: point.x, y: point.y)
    }
}
