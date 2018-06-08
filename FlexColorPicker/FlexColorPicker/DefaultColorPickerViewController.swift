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
private let paletteVerticalMargin: CGFloat = 42
private let paletteHorizontalMargin: CGFloat = 32
private let minDistanceFromSafeArea: CGFloat = 10
private let minSpaceAboveSlider: CGFloat = 50

open class DefaultColorPickerViewController: UIViewController, ColorPickerControllerProtocol {
    private var standardConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
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

    /// Does not update after viewDidLoad
    @IBInspectable
    open var useRadialPalette: Bool = true

    @IBInspectable
    open var rectangularPaletteHueHorizontalInLandscape: Bool = true {
        didSet {
            updateLayout(for: view.bounds.size)
        }
    }

    @IBInspectable
    open var rectangularPaletteHueHorizontalInPortrait: Bool = false {
        didSet {
            updateLayout(for: view.bounds.size)
        }
    }

    @IBInspectable
    open var rectangularPaletteBorderOn: Bool = true {
        didSet {
            (colorPalette as? RectangularPaletteControl)?.borderOn = rectangularPaletteBorderOn
        }
    }

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
        addColorControls()
        updateLayout(for: view.bounds.size)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateLayout(for: size)
        }, completion: nil)
    }

    open func addColorControls() {
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPreview)

        pickerManager.colorPreview = colorPreview

        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brightnessSlider)


        brightnessSlider.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)
        brightnessSlider.expandOnTap = false
        pickerManager.brightnessSlider = brightnessSlider

        if !useRadialPalette {
            colorPalette = RectangularPaletteControl()
            pickerManager.rectangularHsbPalette = colorPalette as? RectangularPaletteControl
        }
        else {
            pickerManager.radialHsbPalette = colorPalette as? RadialPaletteControl
        }
        (colorPalette as? RectangularPaletteControl)?.borderOn = rectangularPaletteBorderOn
        colorPalette.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPalette)

        colorPalette.contentMode = .top
        colorPalette.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)

        makeStandardLayout()
        makeLandscapeLayout()
    }

    private func makeStandardLayout() {
        standardConstraints += [
            colorPreview.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            colorPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            colorPreview.heightAnchor.constraint(equalToConstant: colorPreview.intrinsicContentSize.height)
        ]
        colorPreview.setContentCompressionResistancePriority(.init(900), for: .horizontal)
        standardConstraints += [
            brightnessSlider.leftAnchor.constraint(equalTo: colorPreview.rightAnchor, constant: sideMargin),
            brightnessSlider.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            brightnessSlider.bottomAnchor.constraint(equalTo: colorPreview.bottomAnchor, constant: 0)
        ]
        standardConstraints += [
            colorPalette.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            colorPalette.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            colorPalette.topAnchor.constraint(equalTo: colorPreview.bottomAnchor, constant: paletteVerticalMargin),
            colorPalette.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -sideMargin)
        ]
    }

    private func makeLandscapeLayout() {
        landscapeConstraints += [
            colorPreview.centerXAnchor.constraint(equalTo: brightnessSlider.centerXAnchor),
            colorPreview.bottomAnchor.constraint(equalTo: colorPalette.centerYAnchor, constant: -minSpaceAboveSlider * 0.25)
        ]
        landscapeConstraints += [
            brightnessSlider.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: sideMargin),
            brightnessSlider.topAnchor.constraint(equalTo: colorPalette.centerYAnchor, constant: minSpaceAboveSlider * 0.75),
            brightnessSlider.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -paletteHorizontalMargin / 2)
        ]
        let nonRequiredConstraint = colorPalette.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -sideMargin)
        landscapeConstraints += [
            colorPalette.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: paletteHorizontalMargin / 2),
            colorPalette.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -sideMargin),
            colorPalette.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: sideMargin),
            nonRequiredConstraint,
            colorPalette.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -minDistanceFromSafeArea)
        ]
        nonRequiredConstraint.priority = .init(999)
    }

    private func updateLayout(for size: CGSize) {
        if size == .zero || standardConstraints.isEmpty || landscapeConstraints.isEmpty {
            return
        }
        let rectangularPalette = (colorPalette as? RectangularPaletteControl)
        if size.height < size.width && traitCollection.verticalSizeClass != .regular {
            rectangularPalette?.setHue(horizontalAxis: rectangularPaletteHueHorizontalInLandscape, updateImage: false) //image gets updated on bounds change
            NSLayoutConstraint.deactivate(standardConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
            return
        }

        rectangularPalette?.setHue(horizontalAxis: rectangularPaletteHueHorizontalInPortrait, updateImage: false) //image gets updated on bounds change
        NSLayoutConstraint.deactivate(landscapeConstraints)
        NSLayoutConstraint.activate(standardConstraints)
    }
}
