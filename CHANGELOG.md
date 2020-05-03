# CHANGELOG - Flex Color Picker

All notable changes to this project will be documented in this file.

## 1.4 - 2019-5-03

### Added
- complete support for iOS dark mode

### Changed
- **Breaking change:** removed method `setDefaultBorder(on:)` from classes `ColorSliderControl` and `ColorPreviewWithHex`. Instead of overriding that method, property `borderOn` should be set to `false` and custom border should be installed directly to appropriate views .
- **Breaking change:** visibility of property `borderOn` from in class `RadialPaletteControl` was changed from `open` to `public`. Instead of overriding this property, clients should set it to `false` and install custom border directly on appropriate views.

### Fixed
- issue #25: iOS 13 dark mode support

## 1.3.2 - 2020-4-20

### Changed
- `ColorPickerDelegate` functions were made optional to allow for more flexibility (now only one of them can be used)
- updated README

### Fixed
- issue #26: Swift  5.2 complaint 

## 1.3.1 - 2019-10-08

### Added
- `Package.swift` to fix SPM support 

### Changed
- renamed `autoDaken` property of `ColorPickerThumbView` to `autoDarken` (typo fix)
- improved documentation
- hidden `RestrictedPanCircleView` from clients (and renamed it to `LimitedGestureCircleView`) as it is implementation detail. 
- added minimum platform to `Package.swift` and explicit imports of `UIKit` where missing trying to fix SPM issues   

### Deprecated
- deprecated `PaletteAwareScrollView` as it is not needed any more. Supplied color controls and custom color controls subclassing `AbstractColorControl` will now work inside `UIScrollView` and iOS 13 modally presented controllers out of box.

### Fixed
- memory leak introduced in 1.3 where color controls would not be released

## 1.3 - 2019-09-25

### Added
- support for Swift Package Manager

### Changed
- updated to Swift 5

### Fixed
- modal presentation dismiss gesture conflict for iOS 13
- issue #10: Warning under Xcode 11.0 - Setter argument 'newValue' was never used, but the property was accessed

## 1.2.1 - 2019-03-26

### Changed
- README updated 

### Fixed
- Code warnings in XCode 10.1


## 1.2 - 2019-03-26

### Added
- some missing documentation

### Changed
- project updated Swift version 4.2

### Fixed
- Bug #3: Error when run it in xcode 10.1 caused by duplicated .plist
