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

/// Color picker view controller with predefined layout and limited customisation options. It is designed to be easy to use. You can customize it from interface builder (e.g. you can choose radial or rectangular palette) or from code by setting its properties or directly setting properties of its `colorPalette`, `colorPreview` & `brightnessSlider`. If you need more customisation please use `CustomColorPickerViewController`.
///
/// **See also:**
/// [CustomColorPickerViewController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/CustomColorPickerViewController.swift), [ColorPickerController](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/ColorPickerController.swift)
open class DefaultColorPickerViewController: UIViewController, ColorPickerControllerProtocol {
    private var standardConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()

   /// Color picker controller that synchonizes color controls. This is controller that this controller delegates interaction logic to. It is also instance of `ColorPickerController` passed to delegate calls.
    public let colorPicker = ColorPickerController()
    public let colorPreview = ColorPreviewWithHex()
    public let brightnessSlider = BrightnessSliderControl()
    private(set) public var colorPalette: ColorPaletteControl = RadialPaletteControl()

    /// Color currently selected by color the picker.
    @IBInspectable
    open var selectedColor: UIColor {
        get {
            return colorPicker.selectedColor
        }
        set {
            colorPicker.selectedColor = newValue
        }
    }

    /// Determines if radial or rectangular color palette will be used. This property is checked only during `viewDidLoad()` and later changes have no effect. If you set this in your `viewDidLoad()` override, call `super.viewDidLoad()` only after you have set this property. Also works with interface builder.
    @IBInspectable
    open var useRadialPalette: Bool = true

    /// If `useRadialPalette` is `true` then this property specifies whether hue color component is changed with x (`true`) or y axis (`false`) of the color palette.
    ///
    /// Only applied in potrait orientation on iPhone devices and in all iPad orientations.
    @IBInspectable
    open var rectangularPaletteHueHorizontalInPortrait: Bool = false {
        didSet {
            updateLayout(for: view.bounds.size)
        }
    }

    /// If `useRadialPalette` is `true` then this property specifies whether hue color component is changed with x (`true`) or y axis (`false`) of the color palette.
    ///
    /// Only applied in landscape orientation on iPhone devices.
    @IBInspectable
    open var rectangularPaletteHueHorizontalInLandscape: Bool = true {
        didSet {
            updateLayout(for: view.bounds.size)
        }
    }

    /// If `useRadialPalette` is `true` then this specifies whether `colorPalette` has border.
    @IBInspectable
    open var rectangularPaletteBorderOn: Bool = true {
        didSet {
            (colorPalette as? RectangularPaletteControl)?.borderOn = rectangularPaletteBorderOn
        }
    }

    /// Color picker delegate that gets called when selected color is updated or confirmed. The delegate is not retained. This is just convinience property and getting or setting it is equivalent to getting or setting `colorPicker.delegate`.
    open var delegate: ColorPickerDelegate? {
        get {
            return colorPicker.delegate
        }
        set {
            colorPicker.delegate = newValue
        }
    }

    open override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        super.viewDidLoad()

        addColorControls()
        updateLayout(for: view.bounds.size)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.updateLayout(for: size)
        }, completion: nil)
    }

    /// This method sets up and lays out `colorPreview`, `brightnessSlider` and `colorPalette`. It also applies initial values of properties like `useRadialPalette` on them.
    ///
    /// You can override this method to create your own default layout.
    open func addColorControls() {
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPreview)

        colorPicker.colorPreview = colorPreview

        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(brightnessSlider)


        brightnessSlider.hitBoxInsets = UIEdgeInsets(top: defaultHitBoxInset, left: sideMargin, bottom: defaultHitBoxInset, right: sideMargin)
        colorPicker.brightnessSlider = brightnessSlider

        if !useRadialPalette {
            colorPalette = RectangularPaletteControl()
            colorPicker.rectangularHsbPalette = colorPalette as? RectangularPaletteControl
        }
        else {
            colorPicker.radialHsbPalette = colorPalette as? RadialPaletteControl
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
            colorPreview.leftAnchor.constraint(equalTo: view.safeAreaLeftAnchor, constant: sideMargin),
            colorPreview.topAnchor.constraint(equalTo: view.safeAreaTopAnchor, constant: topMargin),
            colorPreview.heightAnchor.constraint(equalToConstant: colorPreview.intrinsicContentSize.height)
        ]
        colorPreview.setContentCompressionResistancePriority(.init(900), for: .horizontal)
        standardConstraints += [
            brightnessSlider.leftAnchor.constraint(equalTo: colorPreview.rightAnchor, constant: sideMargin),
            brightnessSlider.rightAnchor.constraint(equalTo: view.safeAreaRightAnchor, constant: -sideMargin),
            brightnessSlider.bottomAnchor.constraint(equalTo: colorPreview.bottomAnchor, constant: 0)
        ]
        standardConstraints += [
            colorPalette.leftAnchor.constraint(equalTo: view.safeAreaLeftAnchor, constant: sideMargin),
            colorPalette.rightAnchor.constraint(equalTo: view.safeAreaRightAnchor, constant: -sideMargin),
            colorPalette.topAnchor.constraint(equalTo: colorPreview.bottomAnchor, constant: paletteVerticalMargin),
            colorPalette.bottomAnchor.constraint(equalTo: view.safeAreaBottomAnchor, constant: -sideMargin)
        ]
    }

    private func makeLandscapeLayout() {
        landscapeConstraints += [
            colorPreview.centerXAnchor.constraint(equalTo: brightnessSlider.centerXAnchor),
            colorPreview.bottomAnchor.constraint(equalTo: colorPalette.centerYAnchor, constant: -minSpaceAboveSlider * 0.25)
        ]
        landscapeConstraints += [
            brightnessSlider.leftAnchor.constraint(equalTo: view.safeAreaLeftAnchor, constant: sideMargin),
            brightnessSlider.topAnchor.constraint(equalTo: colorPalette.centerYAnchor, constant: minSpaceAboveSlider * 0.75),
            brightnessSlider.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -paletteHorizontalMargin / 2)
        ]
        let nonRequiredConstraint = colorPalette.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -sideMargin)
        landscapeConstraints += [
            colorPalette.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: paletteHorizontalMargin / 2),
            colorPalette.rightAnchor.constraint(equalTo: view.safeAreaRightAnchor, constant: -sideMargin),
            colorPalette.topAnchor.constraint(equalTo: view.safeAreaTopAnchor, constant: sideMargin),
            nonRequiredConstraint,
            colorPalette.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaBottomAnchor, constant: -minDistanceFromSafeArea)
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

fileprivate extension UIView {
    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }

    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }

    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return topAnchor
    }

    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
}
