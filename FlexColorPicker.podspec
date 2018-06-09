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
  s.summary          = 'Flexible color picker written in Swift 4.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RastislavMirek/FlexColorPicker'
#  s.screenshots     = 'https://github.com/RastislavMirek/FlexColorPicker/blob/master/SampleGifs/Flex_color_picker_for_swift_preview1.gif', 'https://github.com/RastislavMirek/FlexColorPicker/blob/master/SampleGifs/Flex_color_picker_for_swift_preview2.gif'
  s.swift_version    = '4.1'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rastislav Mirek' => 'RastislavMirek@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/RastislavMirek/FlexColorPicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'FlexColorPicker/Classes/**/*'
  
  s.resource_bundles = {
    'FlexColorPicker' => ['FlexColorPicker/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
