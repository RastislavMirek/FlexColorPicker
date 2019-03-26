[![Build Status](https://travis-ci.org/RastislavMirek/FlexColorPicker.svg?branch=master)](https://travis-ci.org/RastislavMirek/FlexColorPicker.svg)
[![License Badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/RastislavMirek/FlexColorPicker/blob/master/LICENSE)
[![Pod Version Badge](https://img.shields.io/cocoapods/v/FlexColorPicker.svg)](https://cocoapods.org/pods/FlexColorPicker)
![Swift Version Badge](https://img.shields.io/badge/swift-v4.2-blue.svg)
# Flex Color Picker
Modern color picker library written in Swift 4.2 that can be easily extended and customized. It aims to provide great UX and performance with stable, quality code. Includes controls for both HSB and RGB color models.     

![Default Flex Color Picker Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview1.gif)
![Color Picker with All Controls Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview2.gif)

## Supported Use Cases
1. ready-to-use color picker that works great out-of-box 
2. agile library that supports components positioning with autolayout and customisation directly from storyboard
3. framework that allows adding your own sliders, palettes &amp; previews or modifying existing ones without changing the code of the library
4. combine 3 approaches above freely to get level of customisation that you need

![Default Color Picker with Rectangular Palette Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview3.gif)
![Custom Color Picker Controls Written in Swift Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Flex_color_picker_for_swift_preview4.gif)

## Features
- supports HSB and RGB color models, radial and rectangular hue/saturation palette
- there is _great UX_ "just set the delegate" view controller _if you need something simple_
- freely combine, leave out or add your own picker components
- _highly customisable_
- _storyboard support_ with realistic, design time preview and customisation directly from storyboard
- robust, easy to understand code
- well documented
- can be used without subclassing specific controller
- _protocols_ for adding custom picker controls and reusing existing sliders/palettes
- key classes opened &amp ready for extending

## Instalation

### Cocoapods
Add this to your podfile:

    pod FlexColorPicker

You can also try the Demo project with following command:

    pod try FlexColorPicker

### Direct Instalation
If you do not use Cocoapods clone the color picker from repository with this command:

    git clone https://github.com/RastislavMirek/FlexColorPicker

Then open the cloned project in XCode and compile target _FlexColorPicker_. File FlexColorPicker.framework will be created in _Products_ directory. Open project that you want to add the color picker to in XCode, select project file, select your application's target on the left side, select _General_ tab and add FlexColorPicker.framework under _Embedded Binaries_ section.  

![Default HSB Color Picker Preview](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Combined_Color_Picker_Preview.jpg)

## How to Use
There are several ways how to use FlexColorPicker depending on how much customization you require. The fastest and simplest option is using `DefaultColorPickerViewController`.

### Adding Default Color Picker
In storyboard, FlexColorPicker can be used by specifying _Class_ of a view controller to be `DefaultColorPickerViewController`. That is done in _Identity Inspector_ in right panel under _Custom Class_. Delegate of `DefaultColorPickerViewController` can only be set in code. Basic customisation of the controller is supported in storyboard via properties in [_Attributes Inspector_](https://www.quora.com/Where-is-an-attributes-inspector-in-Xcode).

In code,  `DefaultColorPickerViewController` can be setup like this if using a navigation controller:

    let colorPickerController = DefaultColorPickerViewController()
    colorPickerController.delegate = self
    navigationController?.pushViewController(colorPickerController, animated: true)

Or when presented modally:

    let colorPickerController = DefaultColorPickerViewController()
    colorPickerController.delegate = self
    let navigationController = UINavigationController(rootViewController: colorPickerController)
    present(navigationController, animated: true, completion: nil)

### Customisation
FlexColorPicker consists of _color controls_ and _color picker controllers_ that manage them. _Color controls_ are (usually) subclasses of [`UIControl`](https://developer.apple.com/documentation/uikit/uicontrol) that allow user to pick desired color. Predefined _color controls_ include hue/saturation palettes (circular or rectangular), sliders for saturation, brightness and for RGB components and a picked color preview control. Additional can by added by implementing [`ColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorControl.swift) protocol.

#### Available Color Controls

Each _color control_ has some properties (some of them can be set in storyboard) that can be used for customisation of that control's look and feel.
This is the list of included _color controls_:

[`ColorPreviewWithHex`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorPreviewWithHex.swift)
[`RadialPaletteControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/PaletteControls.swift)
[`RectangularPaletteControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/PaletteControls.swift)
[`SaturationSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`BrightnessSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`RedSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`GreenSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)
[`BlueSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ComponentSliderControls.swift)

If you want to customize your color picker, you can choose and lay out _color controls_ that you want, set their properties if needed and connect them add them to a _color picker controller_. 

![Working with Color Picker in XCode Storyboard](https://github.com/RastislavMirek/FlexColorPicker/blob/master/GifsAndScreenshots/Working_with_flex_color_picker_from_storyboard.png)

#### Connecting Color Controls
In storyboard, lay out _color controls_ and set their classes  in _Identity Inspector_ to classes of controls you want to use. Then set controller's class to  `CustomColorPickerViewController`, open its _Connection Inspector_ and connect corresponding outlets the controls.

The same can be done in code simply by assigning _color controls_ to appropriate properties of `CustomColorPickerViewController`. 

If you cannot subclass `CustomColorPickerViewController` e.g. because your controller is a subclass of another class use `ColorPickerController` instead. It can also be used in storyboard as interface builder custom object. It has same properties as  `CustomColorPickerViewController` (actually, `CustomColorPickerViewController` is just a convenience wrapper for `ColorPickerController`). You can also add  _color controls_ to it via `ColorPickerController.addControl(:)`  so you are not limited to properties.

Once added to a _color picker controller_ (e.g. `ColorPickerController`) a _color control_ will be synchronized with other controls managed by the same controller together selecting a single color.

### Extending & Overriding
FlexColorPicker is made to be tweaked and extended with minimum effort. You can add you own _color control_ by implementing `ColorControl` protocol or extending one of following subclass-ready classes:

- [`AbstractColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/AbstractColorControl.swift) - aways subclass if you can
- [`AdjustedHitBoxColorControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/AdjustedHitBoxColorControl.swift) - if you need extended hit box margin around the control
- [`ColorSliderControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorSliderControl.swift) - e.g. if you need sliders for another color model then HSB or RGB
- [`ColorPaletteControl`](https://github.com/RastislavMirek/FlexColorPicker/blob/master/FlexColorPicker/Classes/Controls/ColorPaletteControl.swift) - if you want to create another color palette

In many cases there will be no need to subclass `ColorSliderControl` or `ColorPaletteControl`. They both relay on their _color delegates_ in how they handle color updates, present themselves and how they interpret user interactions. Therefore, you can instead implement `ColorSliderDelegate` or `ColorPaletteDelegate` protocols respectively to change look and behavior without changing the code of the control itself. 

Demo project has good examples on both approaches (overriding and composition) and their combination, feel free to check it. 

## Tips
When setting up slider controls in storyboard it is a good practise to set its background to be transparent. [Alignment rectangle](https://developer.apple.com/documentation/uikit/uiview/1622648-alignmentrectinsets) ([rectangle that autolayout uses to lay out the control](https://useyourloaf.com/blog/auto-layout-and-alignment-rectangles/)) is smaller than the actual frame of the slider to allow for extra hit box margin as well as background framing of the slider. Therefore, if background is solid white it can overlap other views close to it. 
☛ If you do not want this behavior, set Hit Box Inset to 0 in Attributes Inspector or set `hitBoxInset` to `0` in code.

`ColorPreviewWithHex` can be tapped. When it it tapped, `ColorPickerController` calls `ColorPickerDelegate.colorPicker(_:selectedColor:usingControl:)` on its delegate. 
☛ You can communicate this feature to your users or opt out by setting `ColorPreviewWithHex.tapToConfirm` to `false`. 

If a _palette color controls_ is added as subview of  `UIScrollView` it might cause issues because  _palette color controls_ make use of pan gestures as well as `UIScrollView`. `UIScrollView` will take priority, making any palette control hard to work with. 
☛ Using `PaletteAwareScrollView` instead of `UIScrollView` solves that issue.    

## Getting in Touch
If you like it, have a question or want to hire iOS developers shoot me a message at

**[my first name, see profile] _at_ [epytysae spelled backwards] _dot_ [first 4 letters of word information]**

Emails go directly to author of FlexColorPicker, cryptic format is just spam bot protection. 

Suggestions, feedback, bug reports & pull requests are very welcomed.

## Thanks
Visual of slider control was inspired by popular Objective-C library HRColorPicker.  Thank you  for using FlexColorPicker! If you just have 3 seconds to give back, please star this repository.
