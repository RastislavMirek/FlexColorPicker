//
//  GradientView.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 28/5/18.
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

/// View with linear gradient background instead of solid color.
public class GradientView: UIView {
    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    /// Background gradient first color (first stop of the gradient).
    public var startColor: UIColor = .clear {
        didSet {
            updateColors()
        }
    }

    /// Background gradient last color (last stop of the gradient).
    public var endColor: UIColor = .clear {
        didSet {
            updateColors()
        }
    }

    /// How far to right the begining of background gradient shoulds be from the view's left edge. In points.
    public var startOffset: CGFloat = 0 {
        didSet {
            updatePoints()
        }
    }

    /// How far to the left the end of background gradient shoulds be from the view's right edge. In points.
    public var endOffset: CGFloat = 0 {
        didSet {
            updatePoints()
        }
    }

    public override var bounds: CGRect {
        didSet {
            updatePoints()
        }
    }

    open func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }

    open func updatePoints() {
        gradientLayer.startPoint = CGPoint(x: startOffset / bounds.width, y: 0.5)
        gradientLayer.endPoint.x = 1 - endOffset / bounds.width //some strange bug causes it to asign NaN for x when directly assigning CGPoint
        gradientLayer.endPoint.y = 0.5
    }
}
