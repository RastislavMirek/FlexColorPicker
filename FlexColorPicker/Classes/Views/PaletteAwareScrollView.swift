//
//  PaletteAwareScrollView.swift
//  FlexColorPicker
//
//  Created by Rastislav Mirek on 7/6/18.
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

/// A scroll view that supports adding instances of `ColorPaletteControl` in its content without compromising their panning (color selction by dragging a finger) functionality.
///
/// This scroll view interprets panning over palettes inside its content as a gesture intended for that palette but as scroll gesture.
open class PaletteAwareScrollView: UIScrollView {

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer !== panGestureRecognizer {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

        let touchLocation = gestureRecognizer.location(in: self)
        let hitView = hitTest(touchLocation, with: nil)
        if isCondition({ $0 is ColorPaletteControl}, satisfiedByParentOf: hitView) {
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    private func isCondition(_ condition: (UIView) -> Bool, satisfiedByParentOf view: UIView?) -> Bool {
        guard let view = view, view !== self else {
            return false
        }
        if condition(view) {
            return true
        }
        return isCondition(condition, satisfiedByParentOf: view.superview)
    }
}
