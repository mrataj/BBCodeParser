#
# Be sure to run `pod lib lint BBCodeParser.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BBCodeParser"
  s.version          = "0.1.0"
  s.summary          = "BBCodeParser is open source objective C library for parsing BBCode (Bulletin Board Code)."
  s.description      = <<-DESC
                       To use this library in your project, copy files in BBCodeParser folder into your project. Then, include "BBCodeParser.h" file wherever you want to parse your code.
                       DESC
  s.homepage         = "https://github.com/mrataj/BBCodeParser"
  s.license          = 'MIT'
  s.author           = { "Miha Rataj" => "rataj.miha@gmail.com" }
  s.source           = { :git => "https://github.com/mrataj/BBCodeParser.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/miharataj'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BBCodeParser' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
