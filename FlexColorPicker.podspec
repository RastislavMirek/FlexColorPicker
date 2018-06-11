#
# Be sure to run `pod lib lint FlexColorPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexColorPicker'
  s.version          = '1.0'
  s.summary          = 'Flexible color picker written in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Modern color picker library written in Swift 4 that can be easily extended and customized. It aims to provide great UX and performance with stable, quality code. Supports HSB and RGB color models.
                       DESC

  s.homepage         = 'https://github.com/RastislavMirek/FlexColorPicker'
  s.screenshots      = 'https://github.com/RastislavMirek/FlexColorPicker/blob/master/Screenshots/Default_Flex_Color_Picker.jpg', 'https://github.com/RastislavMirek/FlexColorPicker/blob/master/Screenshots/Custom_Color_Picker_Components.png', 'https://github.com/RastislavMirek/FlexColorPicker/blob/master/Screenshots/Default_Flex_Color_Picker.png', 'https://github.com/RastislavMirek/FlexColorPicker/blob/master/Screenshots/Rectangular_Color_Picker_Palette.png'
  s.swift_version    = '4.1'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rastislav Mirek' => 'RastislavMirek@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/RastislavMirek/FlexColorPicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.summary          = 'Modern color picker library written in Swift 4 that can be easily extended and customized.'

  s.ios.deployment_target = '11.0'

  s.source_files = 'FlexColorPicker/Classes/**/*'
  s.frameworks = 'UIKit'
  
  s.resource_bundles = {
    'FlexColorPicker' => ['FlexColorPicker/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
