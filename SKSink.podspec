#
# Be sure to run `pod lib lint SKSink.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SKSink"
  s.version          = "0.1.0"
  s.summary          = "A kitchen sink of classes that I find useful"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
  A kitchen sink of classes that I find useful. Not recommended for use by others
                       DESC

  s.homepage         = "https://github.com/skorulis/SKSink"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Alexander Skorulis" => "skorulis@gmail.com" }
  s.source           = { :git => "https://github.com/skorulis/SKSink.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/skorulis'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'SKSink/**/*'
  s.resource_bundles = {
    'SKSink' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'SKSink/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
	s.dependency 'TwistedOakCollapsingFutures', '~> 1.0'
	s.dependency 'FMDB'
end
