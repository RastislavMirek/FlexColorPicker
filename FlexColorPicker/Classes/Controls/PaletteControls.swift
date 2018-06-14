//
//  PaletteControls.swift
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

/// Circular palette color control that allows to change both hue and saturation of current color by selecting a point on the palette.
public class RadialPaletteControl: ColorPaletteControl {
    public override func commonInit() {
        paletteDelegate = RadialHSBPaletteDelegate()
        super.commonInit()
    }
}

/// Rectangle shaped palette color control that allows to change both hue and saturation of current color by selecting a point on the palette.
public class RectangularPaletteControl: ColorPaletteControl {
    public override func commonInit() {
        paletteDelegate = RectangularHSBPaletteDelegate()
        setDefaultBorder(on: borderOn, forView: contentView)
        setHue(horizontalAxis: hueHorizontal, updateImage: false)
        super.commonInit()
    }

    /// When `true`, different values of color hue will correspond to different coordinates along x axis (that means that vertical lines will have same hue but different saturation). When `false`, different values of color hue will correspond to different coordinates along y axis.
    /// - Important: Do not set this property from code. It is only intended to be set from interface builder. Call `setHue(horizontalAxis: updateImage:)` instead.
    @IBInspectable
    public var hueHorizontal: Bool = true {
        didSet {
            if oldValue != hueHorizontal {
                setHue(horizontalAxis: hueHorizontal, updateImage: true)
            }
        }
    }

    /// Whether to display thin border around the palette.
    @IBInspectable
    open var borderOn: Bool = true {
        didSet {
            setDefaultBorder(on: borderOn, forView: contentView)
        }
    }

    /// Sets the value of `hueHorizontal` property.
    /// - Note: This operation can be computationally expensive if `updateImage` parameter is `true`.
    /// - Parameters:
    ///   - horizontalAxis: New value for `hueHorizontal` property.
    ///   - updateImage: When `true`, new palete preview images will be created by palette delegate. This can be computationally expensive. Pass `false` if further updates are expecetd e.g. change of bounds of the color control.
    open func setHue(horizontalAxis: Bool, updateImage: Bool) {
        hueHorizontal = horizontalAxis
        (paletteDelegate as? RectangularHSBPaletteDelegate)?.hueHorizontal = horizontalAxis
        if updateImage {
            updatePaletteImagesAndThumb(isInteractive: false)
        }
    }
}
