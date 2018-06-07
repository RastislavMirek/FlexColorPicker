//
//  DefaultColorPickerViewController.swift
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

private let sideMargin: CGFloat = 20
private let topMargin: CGFloat = 24
private let paletteTopMargin: CGFloat = 32

open class DefaultColorPickerViewController: UIViewController, ColorPickerControllerProtocol {
    public let pickerManager = ColorPickerController()
    public let colorPreview = ColorPreviewWithHex()
    public let brightnessSlider = BrightnessSliderControl()
    private(set) public var colorPalette: ColorPaletteControl = RadialPaletteControl()

    @IBInspectable
    open var selectedColor: UIColor {
        get {
            return pickerManager.selectedColor
        }
        set {
            pickerManager.selectedColor = newValue
        }
    }

    @IBInspectable
    open var useRadialPalette = true

    open var delegate: ColorPickerDelegate? {
        get {
            return pickerManager.delegate
        }
        set {
            pickerManager.delegate = newValue
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        addStandardColorControls()
    }

    open func addStandardColorControls() {
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPreview)
        colorPreview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin).isActive = true
        colorPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin).isActive = true
        pickerManager.colorPreview = colorPreview

        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brightnessSlider)
        brightnessSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: colorPreviewWithHexIntristicContentSize.width + sideMargin * 2).isActive = true
        brightnessSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideMargin).isActive = true
        brightnessSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: colorPreviewWithHexIntristicContentSize.height + topMargin).isActive = true
        brightnessSlider.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)
        pickerManager.brightnessSlider = brightnessSlider

        if !useRadialPalette {
            colorPalette = RectangularPaletteControl()
            pickerManager.rectangularHsbPalette = colorPalette as? RectangularPaletteControl
        }
        else {
            pickerManager.radialHsbPalette = colorPalette as? RadialPaletteControl
        }
        colorPalette.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPalette)
        colorPalette.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideMargin).isActive = true
        colorPalette.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideMargin).isActive = true
        colorPalette.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: colorPreviewWithHexIntristicContentSize.height + topMargin + paletteTopMargin).isActive = true
        colorPalette.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -sideMargin).isActive = true
        colorPalette.contentMode = .top
        colorPalette.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)
    }
}
