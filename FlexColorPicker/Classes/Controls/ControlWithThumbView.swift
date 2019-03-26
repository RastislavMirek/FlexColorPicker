//
//  ColorControlWithThumbView.swift
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

/// Common ancestor of color controls that use `ColorPickerThumbView`.
/// - Important: It is **not** recomended to subclass this class directly. Subclass `ColorPaletteControl` or `ColorSliderControl` instead.
open class ColorControlWithThumbView: AdjustedHitBoxColorControl {
    public let thumbView = ColorPickerThumbView()

    /// Override point. It is called every time the touch is detected in new location. The `thumbView` should be moved and changed accordingly.
    ///
    /// - Parameter point: New location for the thumb view in coordinate space of the content (adjusted for hitBoxInsets) - that is in coordinate space of `contentView`.
    /// - Parameter isInteractive: Whether the change originated from user interaction or is programatic. This can be used to determine if certain animations should be played.
    open func updateSelectedColor(at point: CGPoint, isInteractive: Bool = true) {
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        thumbView.setExpanded(true, animated: true)
        updateSelectedColor(at: location)
        super.touchesBegan(touches, with: event)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        updateSelectedColor(at: location)
        super.touchesMoved(touches, with: event)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        updateSelectedColor(at: location)
        thumbView.setExpanded(false, animated: true)
        super.touchesEnded(touches, with: event)
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = locationForTouches(touches) else {
            return
        }
        updateSelectedColor(at: location)
        thumbView.setExpanded(false, animated: true)
        super.touchesCancelled(touches, with: event)
    }
}
