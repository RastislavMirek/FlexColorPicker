
//
//  UIImageViewExtension.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 4/6/18.
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

extension UIImageView {
    func convertToImageSpace(point: CGPoint) -> CGPoint {
        return transform(point: point, toImageSpace: true)
    }

    func convertFromImageSpace(point: CGPoint) -> CGPoint {
        return transform(point: point, toImageSpace: false)
    }

    private func transform(point: CGPoint, toImageSpace: Bool) -> CGPoint {
        guard let contentSize = image?.size else {
            return point
        }
        let multiplier: CGFloat = toImageSpace ? -1 : 1
        let verticalDiff = (bounds.height - contentSize.height) * multiplier
        let horizontalDiff = (bounds.width - contentSize.width) * multiplier
        return CGPoint(
            x: adjustedCoordinate(for: point.x, axisAlignment: contentMode.horizontalAlighnment, difference: horizontalDiff),
            y: adjustedCoordinate(for: point.y, axisAlignment: contentMode.verticalAlighnment, difference: verticalDiff)
        )
    }

    private func adjustedCoordinate(for coordinate: CGFloat, axisAlignment: Alighnment, difference: CGFloat) -> CGFloat {
        switch axisAlignment {
        case .begining: return coordinate
        case .center: return coordinate + difference / 2
        case .end: return coordinate + difference
        }
    }
}

private enum Alighnment {
    case begining, center, end
}

fileprivate extension UIView.ContentMode {
    var verticalAlighnment: Alighnment {
        switch self {
        case .bottom, .bottomLeft, .bottomRight: return .end
        case .center, .left, .right, .scaleAspectFit, .scaleAspectFill, .scaleToFill, .redraw: return .center
        case .top, .topRight, .topLeft: return .begining
        @unknown default: return .center
        }
    }

    var horizontalAlighnment: Alighnment {
        switch self {
        case .left, .topLeft, .bottomLeft: return .begining
        case .top, .center, .bottom, .scaleAspectFit, .scaleAspectFill, .scaleToFill, .redraw: return .center
        case .right, .topRight, .bottomRight: return .end
        @unknown default: return .center
        }
    }
}
