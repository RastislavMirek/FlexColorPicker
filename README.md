# Flex Color Picker
Modern &amp; flexible color picker for iOS written in Swift 4. Great UX, high performance and open, protocol oriented design: You can set, override or replace almost anything.

![Demo CountPages alpha](https://github.com/RastislavMirek/FlexColorPicker/blob/master/SampleGifs/Flex_color_picker_for_swift_preview1.gif)
![Demo CountPages alpha](https://github.com/RastislavMirek/FlexColorPicker/blob/master/SampleGifs/Flex_color_picker_for_swift_preview2.gif)
![Demo CountPages alpha](https://github.com/RastislavMirek/FlexColorPicker/blob/master/SampleGifs/Flex_color_picker_for_swift_preview3.gif)

## Use cases supported
1. ready-to-use color picker that works great out-of-box
2. agile library that supports components positioning with autolayout and customisation directly from storyboard (or from code)     
3. framework that allows adding your own sliders, palettes &amp; previews or modifying existing ones without changing the code of the library
4. combine 3 approaches above freely to get level of customisation that you need

## Features
- life synchronization of all color picker components 
- storyboards support with realistic design time preview and customisation directly from storyboard
- freely combine, leave out or add your own picker components
- controls works in UIScrollView with little effort
- great UX and simplistic, customisable design
- works with any controller, no need to subclass some specific controller
- /* fully documented - not yet  */, clean and easy to understand code
- to add your own slider/palete just by implementing a protocol
- or reuse existing slider/palete for different color model by implementing another protocol
- all key classes are opened &amp ready for extending with many override points 

![Demo CountPages alpha](https://github.com/RastislavMirek/FlexColorPicker/blob/master/SampleGifs/Flex_color_picker_for_swift_preview4.gif)

## Instalation

### Via Cocoapods
Add this to your podfile:

    pod FlexColorPicker

You can also try the Demo project with following comand:

    pod try FlexColorPicker

### Direct Instalation
You can also clone this repository and add FlexColorPicker framework to your project. Clone the repository using Git and open it in XCode. Compile target FlexColorPicker. That will create file FlexColorPicker.framework in Products directory of the cloned project. Open project that you want to add color picker to in XCode, select project file, select your application's target on the left side, select General tab and add FlexColorPicker.framework under Embedded Binaries section using little plus button.  

## How to use

### Adding Standard Color Picker

### Customization

### Extending & Overriding

### Working with UIScrollView

## Tips
When setting up slider controls in storyboard it is a good practise to set its backgound to transparent. Alignment rectangle (rectangle that autolayout uses to lay out the control) is smaller than the actual frame of the slider to allow for extra hit box margin as well as background framing of the slider. Therefore, if backgound is left solid white it can overlap other views close to it. If you do not want this behavior, set Hit Box Inset to 0 in Attributes Inspector or set `hitBoxInset` to `0` in code.

Color preview component (the one that shows hex of color by default) can be tapped. When it it tapped color picker controller sends selected confirmed call to its delegate. You can comunicate this feature to your users or opt out by disabling it setting `ColorPreviewWithHex.tapToConfirm` to `false`.   

## Getting in Touch
If you like it, have a question or want to hire iOS developers shoot me a message at [my first name, see profile] at [epytysae spelled backwards] dot [first 4 letters of word information]. Email will goes directly to author FlexColorPicker, cryptic email format is just spam bot protection. 

Suggestions, feedback, bug reorts & pull requests are very wellcomed.

### Thanks
Visual of slider control inspired by popular Objective-C library HRColorPicker.  Thank you  for using FlexColorPicker! If you just have 5 seconds to give back, please star this repository.
