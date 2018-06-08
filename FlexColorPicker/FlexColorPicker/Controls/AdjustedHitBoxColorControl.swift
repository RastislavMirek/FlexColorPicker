//
//  AdjustedHitBoxColorControl.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 6/6/18.
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

let defaultHitBoxInset: CGFloat = 16
public let colorControlWithThumbViewDefaulthitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: defaultHitBoxInset, bottom: defaultHitBoxInset, right: defaultHitBoxInset)

open class AdjustedHitBoxColorControl: AbstractColorControl {
    open let contentView = UIView()

    public var contentBounds: CGRect {
        layoutIfNeeded()
        return contentView.frame
    }

    @IBInspectable
    public var hitBoxInset: CGFloat {
        get {
            return (hitBoxInsets.bottom + hitBoxInsets.left + hitBoxInsets.top + hitBoxInsets.right) / 4
        }
        set {
            hitBoxInsets = UIEdgeInsets(top: newValue, left: newValue, bottom: newValue, right: newValue)
        }
    }

    public var hitBoxInsets = colorControlWithThumbViewDefaulthitBoxInsets {
        didSet {
            setNeedsLayout()
        }
    }

    open override func commonInit() {
        super.commonInit()
        addAutolayoutFillingSubview(contentView)
    }

    open override var alignmentRectInsets: UIEdgeInsets {
        return hitBoxInsets
    }

    override func locationForTouches(_ touches: Set<UITouch>) -> CGPoint? {
        guard let location = super.locationForTouches(touches) else {
            return nil
        }
        return convert(location, to: contentView)
    }
}
