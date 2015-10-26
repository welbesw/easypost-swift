#
# Be sure to run `pod lib lint EasypostApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "EasyPostApi"
  s.version          = "0.3.1"
  s.summary          = "A simple Swift library to access the Easypost API."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                        A simple Swift library for the EasyPost API.
                        An implementation of the address, parcel, and ship methods as a starting point.
                        More information about the EasyPost API can be found at: https://www.easypost.com/docs
                       DESC

  s.homepage         = "https://github.com/welbesw/easypost-swift"
  s.license          = 'MIT'
  s.author           = "William Welbes"
  s.source           = { :git => "https://github.com/welbesw/easypost-swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/welbes'

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  # s.resource_bundles = {
  #  'EasypostApi' => ['Pod/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation'
  s.dependency 'Alamofire', '~> 2.0'
end
