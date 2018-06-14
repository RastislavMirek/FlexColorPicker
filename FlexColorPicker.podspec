#
# Be sure to run `pod lib lint FlexColorPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexColorPicker'
  s.module_name      = 'FlexColorPicker'
  s.version          = '1.0.7'
  s.summary          = 'Modern & flexible full spectrum color picker written in Swift 4.'

  s.description      = <<-DESC
Modern color picker library written in Swift 4 that can be easily extended and customized. It aims to provide great UX and performance with stable, quality code. Supports HSB and RGB color models.
                       DESC

  s.homepage         = 'https://github.com/RastislavMirek/FlexColorPicker'
  s.swift_version    = '4.1'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rastislav Mirek' => 'rmirek@easytype.info' }
  s.source           = { :git => 'https://github.com/RastislavMirek/FlexColorPicker.git', :tag => s.version.to_s }

  s.source_files = 'FlexColorPicker/Classes/**/*'
  s.platform = :ios, '9.0'
  s.requires_arc = true # FlexColor picker requires automatic reference counting
  
  #  s.ios.deployment_target = '10.2'
  #  s.frameworks = 'UIKit'
  #  s.resource_bundles = {
  #    'FlexColorPicker' => ['FlexColorPicker/Assets/**/*']
  #  }
  # s.dependency 'AFNetworking', '~> 2.3'
end
