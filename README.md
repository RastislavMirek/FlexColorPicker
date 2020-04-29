[![Build Status](https://travis-ci.org/RastislavMirek/FlexColorPicker.svg?branch=master)](https://travis-ci.org/RastislavMirek/FlexColorPicker.svg)
[![License Badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/RastislavMirek/FlexColorPicker/blob/master/LICENSE)
[![Pod Version Badge](https://img.shields.io/cocoapods/v/FlexColorPicker.svg)](https://cocoapods.org/pods/FlexColorPicker)
![Swift Version Badge](https://img.shields.io/badge/swift-v5-blue.svg)
# Flex Color Picker
Modern color picker library written in Swift 5 that can be easily extended and customized. It aims to provide great UX and performance with stable, quality code. Includes controls for both HSB and RGB color models.

![Default Flex Color Picker Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview1.gif)
![Color Picker with All Controls Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview2.gif)

## Features
- supports [HSB and RGB](#storyboardscreenshot) color models, both [radial and rectangular](#rectangular) hue/saturation palette
- there is [_ready-to-use view controller_](#basic-usage) if you need quick, simple solution
- freely combine, leave out or [add your own](#extending--overriding) picker components when you need flexibility
- well [documented](#documentation)
- _highly [customisable](#customisation)_
- _storyboard support_ with realistic [design time preview](#storyboardscreenshot) and customisation directly from storyboard
- library consists of small classes and robust, easy to understand [code](https://github.com/RastislavMirek/FlexColorPicker/tree/master/FlexColorPicker/Classes)
- can be used [without subclassing specific controller](#nosubclassing)
- hackable: [_protocols_](#protocols) for adding custom picker controls, [open classes](#controlslist) ready for subclassing

![Default Color Picker with Rectangular Palette Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview3.gif)
![Custom Color Picker Controls Written in Swift Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview4.gif)

## Use Cases
1. [plug & play](#basic-usage) color picker that works great out-of-box 
2. [agile library](#available-color-controls) that supports components positioning with autolayout and customisation [directly from storyboard](#connecting-color-controls)
3. framework that allows [adding your own](#extending--overriding) sliders, palettes &amp; previews or modifying [existing ones](#available-color-controls) without changing the code of the library
4. combine 3 approaches above freely to get the level of customisation that you need

## Instalation

### Swift Package Manager

In XCode 11 and above click _File_ → _Swift Packages_ → _Add Package Dependency..._ → choose target to add FlexColorPicker to → enter `https://github.com/RastislavMirek/FlexColorPicker`, press next → set version prefference and confirm.

Alternativelly, if you are using Package.swift just add this dependency:

    dependencies: [
        .package(url: "https://github.com/RastislavMirek/FlexColorPicker.git", from: "1.3.1")
    ]

### Cocoapods
Add this to your podfile:

    pod FlexColorPicker

You can also try the Demo project with following command:

    pod try FlexColorPicker

### Direct Instalation
If you are not Cocoapods or SPM user you can clone the color picker from repository with this command:

    git clone https://github.com/RastislavMirek/FlexColorPicker
    
Alternativelly, you can download latest release as ZIP from [releases](https://github.com/RastislavMirek/FlexColorPicker/releases).

Then open the cloned/downloaded project in XCode and compile target _FlexColorPicker_. File FlexColorPicker.framework will be created in _Products_ directory. Open project that you want to add the color picker to in XCode, select project file, select your application's target on the left side, select _General_ tab and add FlexColorPicker.framework under _Embedded Binaries_ section.  

<a name="rectangular">![Default HSB Color Picker Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Combined_Color_Picker_Preview.jpg)</a>

## How to Use
There are several ways how to use FlexColorPicker depending on how much customization you require. 

### Basic Usage
The fastest and simplest way to add color picker to your project is using `DefaultColorPickerViewController`. You can add it either [via storyboard](#adding-via-storyboard) or [via code](adding-via-code). In both cases you will need to implement [`ColorPickerDelegate` protocol](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/ColorPickerDelegate.swift) to receive update when a user selects color using the `DefaultColorPickerViewController`:

    // MyController is the controller that presents DefaultColorPickerViewController
    extension MyController: ColorPickerDelegate {

        func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
            // code to handle that user selected a color without confirmed it yet (may change selected color)  
        }
        
        func colorPicker(_ colorPicker: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) { 
            // code to handle that user has confirmed selected color
        }
    }
    
Both functions in `ColorPickerDelegate` are optional. You can only use one of them or both in conjuncion.
 
 #### Adding via Storyboard
 
 In storyboard, FlexColorPicker can be used by specifying _Class_ of a view controller to be `DefaultColorPickerViewController`. That is done in [_Identity Inspector_](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Identity_Inspector.jpg) in right panel under _Custom Class_. Basic customisation of the controller is supported in storyboard via properties in [_Attributes Inspector_](https://www.quora.com/Where-is-an-attributes-inspector-in-Xcode). Delegate of `DefaultColorPickerViewController` can only be set in code:
 
    class MyController {
        @IBOutlet var pickerController: ColorPickerController!
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationColorPicker = segue.destination as? ColorPickerControllerProtocol {
                destinationColorPicker.delegate = self
            }
        }
    }

#### Adding via Code

`DefaultColorPickerViewController` can be displayed like this if using a navigation controller:

    let colorPickerController = DefaultColorPickerViewController()
    colorPickerController.delegate = self
    navigationController?.pushViewController(colorPickerController, animated: true)

Replace the 3rd line of the above snippet with following code to display color picker modally:

    let navigationController = UINavigationController(rootViewController: colorPickerController)
    present(navigationController, animated: true, completion: nil)
    
All the above code should go to handler that triggers color picker display (e.g. handler of "Pick Color" button press). 

If preffered, you can use following code to set `DefaultColorPickerViewController` to use rectangular, rather than radial hue-saturation pallete. See third animated image on this page for example. 

    colorPickerController.useRadialPalette = false
    
You can also set 3 additional properties that influence how color picker looks when rectangular palette is used (`rectangularPaletteBorderOn`, `rectangularPaletteHueHorizontalInPortrait` and `rectangularPaletteHueHorizontalInLandscape`). See [in-code
documentation](#documentation) for details. For more customisation please refer to section [Customisation](#customisation) below.

### Customisation
FlexColorPicker consists of _color controls_ and _color picker controllers_ that manage them. _Color controls_ are `UIView`s that (usually) subclass [`UIControl`](https://developer.apple.com/documentation/uikit/uicontrol) and allow user to pick desired color. Predefined _color controls_ include hue/saturation palettes (circular or rectangular), sliders for saturation, brightness and for RGB components and a picked color preview control. Additional can by added by implementing [`ColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorControl.swift) protocol.

#### Available Color Controls

Each _color control_ has some properties (some of them can be set in storyboard) that can be used for customisation of that control's look and feel.
This<a name="controlslist"></a> is the list of included _color controls_:

[`ColorPreviewWithHex`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorPreviewWithHex.swift)
[`RadialPaletteControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/PaletteControls.swift)
[`RectangularPaletteControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/PaletteControls.swift)
[`SaturationSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`BrightnessSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`RedSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`GreenSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`BlueSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)

If you want to customize your color picker, you can choose and lay out _color controls_ that you want, set their properties if needed and [connect them by adding them to the same _color picker controller_](#connecting-color-controls).

<a name="storyboardscreenshot">![Working with Color Picker in XCode Storyboard](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Working_with_flex_color_picker_from_storyboard.png)</a>

#### Connecting Color Controls
In storyboard, lay out _color controls_ and set their classes  in [_Identity Inspector_](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Identity_Inspector.jpg) to classes of controls you want to use. For example, set _class_ field in in [_Identity Inspector_](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Identity_Inspector.jpg) to text "RadialPaletteControl". Then set controller's class to  `CustomColorPickerViewController`, open its _Connection Inspector_ (right side of [this image](#storyboardscreenshot)) and connect corresponding outlets the controls. The same can be done in code simply by assigning _color controls_ to appropriate properties of `CustomColorPickerViewController`. 

If<a name="nosubclassing"></a> you cannot subclass `CustomColorPickerViewController` e.g. because your controller is a subclass of another class use `ColorPickerController` instead. It can also be used in storyboard as interface builder custom object. It has same properties as  `CustomColorPickerViewController` (actually, `CustomColorPickerViewController` is just a convenience wrapper for `ColorPickerController`). You can also add  _color controls_ to it via `ColorPickerController.addControl(:)`  so you are not limited to properties.

Once added to a _color picker controller_ (e.g. `ColorPickerController`) a _color control_ will be synchronized with other controls managed by the same controller together selecting a single color.

### Extending & Overriding
FlexColorPicker is made to be tweaked and extended with minimum effort. <a name="protocols"></a>You can add you own _color control_ by implementing `ColorControl` protocol or extending one of following subclass-ready classes:

- [`AbstractColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/AbstractColorControl.swift) - aways subclass if possible
- [`AdjustedHitBoxColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/AdjustedHitBoxColorControl.swift) - provides extended hit box margin around the control
- [`ColorSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorSliderControl.swift) - e.g. if you need sliders for another color model then HSB or RGB
- [`ColorPaletteControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorPaletteControl.swift) - if you want to create another color palette

In many cases there will be no need to subclass `ColorSliderControl` or `ColorPaletteControl`. They both relay on their _color delegates_ in how they handle color updates, present themselves and how they interpret user interactions. Therefore, you can instead implement `ColorSliderDelegate` or `ColorPaletteDelegate` protocols respectively to change look and behavior without changing the code of the control itself. 

Demo project has good examples on both approaches (overriding and composition) and their combination, feel free to check it.

When subclassing `AbstractColorControl` or `AdjustedHitBoxColorControl` directly ( not via `ColorSliderControl` or `ColorPaletteControl`) you might want to override `gestureRecognizerShouldBegin(:)`. By default, no `UIPanGestureRecognizer` is allowed to recognize any gesture on instances of  `AbstractColorControl`. Depending on type of your _custom color control_ you might want to allow `UIPanGestureRecognizer` to recognize the gesture in some (or all) cases. For example, horizontal slider will want to prevent `UIPanGestureRecognizer` from recognizing horizontal pan gesture because that means changing slider's value. In the same time, it may allow `UIPanGestureRecognizer` to recognize any vertical pan gesture as by those user probably ment to scoll the superview of the slider (it might be `UIScrollView`), not changing slider's value. 

## Tips & Troubleshooting
All<a name="documentation"></a> classes and functions of FlexColorPicker have great in-code documentation. It is there to help you when you are unsure about that class or function's purposer or usage.  
☛ Just option-click name of any FlexColorPicker class or function in XCode to display detailed documentation.  

When setting up slider controls in storyboard it is a good practise to set its background to be transparent. [Alignment rectangle](https://developer.apple.com/documentation/uikit/uiview/1622648-alignmentrectinsets) ([rectangle that autolayout uses to lay out the control](https://useyourloaf.com/blog/auto-layout-and-alignment-rectangles/)) is smaller than the actual frame of the slider to allow for extra hit box margin as well as background framing of the slider. Therefore, if background is solid white it can overlap other views close to it.  
☛ If you do not want this behavior, set Hit Box Inset to 0 in Attributes Inspector or set `hitBoxInset` to `0` in code.

`ColorPreviewWithHex` can be tapped. When it it tapped, `ColorPickerController` calls `ColorPickerDelegate.colorPicker(_:selectedColor:usingControl:)` on its delegate.  
☛ You can communicate this feature to your users or opt out by setting `ColorPreviewWithHex.tapToConfirm` to `false`.
  
  #### Scrolling & Modal Presentation Concerns
When you create your own [_color controls_](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorControl.swift) that do not inherit from [`AbstractColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/AbstractColorControl.swift) and add use them with a modally presented `UIViewController`, their pan gestures may conflict with dismiss modal gesture on iOS 13. The pan gesture may also conflict with scrolling when they are subclass of `UIScrollView`.  
☛ Solve this by adding following code to the view that receives touches (bottom most one in view hierarchy) of your custom _color control_:
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(gestureRecognizer is UIPanGestureRecognizer)
    }


Implementation of all provided _color controls_ (including `AbstractColorControl` and `AdjustedHitBoxColorControl`) overrides `gestureRecognizerShouldBegin(:)` in order to  ensure that the _color controls_ work correctly when embeded inside `UIScrollView`s and iOS 13 modal view conctollers presented modally. The implametation prevents instaces of `UIPanGestureRecognizer` from recognizing any gesture if some condition is met.  In some rare cases this may interfere with custom `UIPanGestureRecognizer`s that you add to view hierarchy.  
☛ Solve this by subclassing the _color control_ that you want to use with your `UIPanGestureRecognizer` and overriding `gestureRecognizerShouldBegin(:)` so that the gesture is recognized.
  

When you add a subview to a _color control_ (either your _custom color control_ or any of the provided ones), that subview has user interaction enabled and the _color control_ is embedded inside a `UIScrollView` or iOS 13 modally presented view controller you may experience following issue when panning/swiping that subview: Panning/swiping meant to interact with your _control control_ might be interpreted as scrolling/dismissing the controller or vice-versa.  
☛ Solve this by adding following code to the subview that you added to the _color control_ and setting the delegate to the color control itself:

    weak var delegate: LimitedGestureViewDelegate?

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let delegate = delegate else {
            return !(gestureRecognizer is UIPanGestureRecognizer)
        }
        return delegate.gestureRecognizerShouldBegin(gestureRecognizer)
    }


## Getting in Touch
If you like it, have a question or want to hire iOS developers shoot me a message at

**[my first name, see profile] _at_ [epytysae spelled backwards] _dot_ [first 4 letters of word information]**

Emails go directly to author of FlexColorPicker, cryptic format is just spam bot protection. 

Suggestions, feedback, bug reports & pull requests are very welcomed.

## Thanks
Visual of slider control was inspired by popular Objective-C library HRColorPicker.  Thank you  for using FlexColorPicker! If you just have 3 seconds to give back, please star this repository.
