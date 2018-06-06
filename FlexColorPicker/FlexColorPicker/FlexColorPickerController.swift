//
//  FlexColorPickerController.swift
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

private let sideMargin: CGFloat = 20
private let topMargin: CGFloat = 24
private let paleteTopMargin: CGFloat = 32
let flexColorPickerBundle = Bundle(for: FlexColorPickerController.self)

open class FlexColorPickerController: UIViewController {
    
    open let colorPicker = FlexColorPicker()

    @IBOutlet public var colorPreview: ColorPreviewWithHex? {
        get {
            return colorPicker.colorPreview
        }
        set {
            colorPicker.colorPreview = newValue
        }
    }

    @IBOutlet open var radialHsbPalette: ColorPaletteControl? {
        get {
            return colorPicker.radialHsbPalette
        }
        set {
            colorPicker.radialHsbPalette = newValue
        }
    }

    @IBOutlet open var saturationSlider: SaturationSliderControl? {
        get {
            return colorPicker.saturationSlider
        }
        set {
            colorPicker.saturationSlider = newValue
        }
    }

    @IBOutlet open var brightnessSlider: BrightnessSliderControl? {
        get {
            return colorPicker.brightnessSlider
        }
        set {
            colorPicker.brightnessSlider = newValue
        }
    }

    @IBOutlet open var redSlider: RedSliderControl? {
        get {
            return colorPicker.redSlider
        }
        set {
            colorPicker.redSlider = newValue
        }
    }

    @IBOutlet open var greenSlider: GreenSliderControl? {
        get {
            return colorPicker.greenSlider
        }
        set {
            colorPicker.greenSlider = newValue
        }
    }

    @IBOutlet open var blueSlider: BlueSliderControl? {
        get {
            return colorPicker.blueSlider
        }
        set {
            colorPicker.blueSlider = newValue
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        addStandardColorControls()
    }

    open func addStandardColorControls() {
        if colorPreview == nil {
            let colorPreview = ColorPreviewWithHex()
            colorPreview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(colorPreview)
            colorPreview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin).isActive = true
            colorPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin).isActive = true
            self.colorPreview = colorPreview
        }
        if brightnessSlider == nil {
            let brightnessSlider = BrightnessSliderControl()
            brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(brightnessSlider)
            brightnessSlider.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: colorPreviewWithHexIntristicContentSize.width + sideMargin * 2).isActive = true
            brightnessSlider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideMargin).isActive = true
            brightnessSlider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: colorPreviewWithHexIntristicContentSize.height + topMargin).isActive = true
            brightnessSlider.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)
            self.brightnessSlider = brightnessSlider
        }
        if radialHsbPalette == nil {
            let radialPalette = ColorPaletteControl()
            radialPalette.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(radialPalette)
            radialPalette.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: sideMargin).isActive = true
            radialPalette.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -sideMargin).isActive = true
            radialPalette.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: colorPreviewWithHexIntristicContentSize.height + topMargin + paleteTopMargin).isActive = true
            radialPalette.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            radialPalette.contentMode = .top
            radialPalette.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)
            self.radialHsbPalette = radialPalette
        }
    }
}
