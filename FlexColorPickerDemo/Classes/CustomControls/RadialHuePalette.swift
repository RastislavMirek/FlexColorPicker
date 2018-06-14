//
//  RadialHuePalette.swift
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

import UIKit
import FlexColorPicker

let radialHuePaletteStripWidth: CGFloat = 28

@IBDesignable
class RadialHueControl: ColorPaletteControl {
    public override func commonInit() {
        paletteDelegate = RadialHueColorPaletteDelegate()
        thumbView.autoDarken = false
        super.commonInit()
    }

    override func updatePaletteImagesAndThumb(isInteractive interactive: Bool) {
        super.updatePaletteImagesAndThumb(isInteractive: interactive)
        thumbView.setColor(selectedHSBColor.withSaturation(1, andBrightness: 1).toUIColor(), animateBorderColor: false)
    }

    override func setSelectedHSBColor(_ hsbColor: HSBColor, isInteractive interactive: Bool) {
        super.setSelectedHSBColor(hsbColor, isInteractive: interactive)
        thumbView.setColor(selectedHSBColor.withSaturation(1, andBrightness: 1).toUIColor(), animateBorderColor: false)
    }
}
