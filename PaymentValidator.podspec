#
# Be sure to run `pod lib lint PaymentValidator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'PaymentValidator'
    s.version          = '0.0.2'
    s.summary          = 'A simple credit card validator.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = 'A simple credit card validator useful to developers who want an on device way of validating a credit cards number is potentially valid.'
    
    s.homepage         = 'https://github.com/educrate/payment-validator-ios'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'christianampe' => 'christianampe.work@gmail.com' }
    s.source           = { :git => 'https://github.com/educrate/payment-validator-ios.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.platform              = :ios
    s.ios.deployment_target = '9.3'
    s.swift_version         = '4.1'
    
    s.source_files = 'PaymentValidator/Classes/**/*'
    
    # s.resource_bundles = {
    #   'PaymentValidator' => ['PaymentValidator/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
