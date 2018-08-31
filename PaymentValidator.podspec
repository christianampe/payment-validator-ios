Pod::Spec.new do |s|
    s.name             = 'PaymentValidator'
    s.version          = '0.0.7'
    s.summary          = 'A simple credit card validator.'
    s.description      = 'A simple credit card validator useful to developers who want an on device way of validating a credit cards number is potentially valid.'
    s.homepage         = 'https://github.com/educrate/payment-validator-ios'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'christianampe' => 'christianampe.work@gmail.com' }
    s.source           = { :git => 'https://github.com/educrate/payment-validator-ios.git', :tag => s.version.to_s }
    s.platform              = :ios
    s.ios.deployment_target = '9.3'
    s.swift_version         = '4.1'
    s.source_files = 'PaymentValidator/Classes/**/*'
    s.resources = 'PaymentValidator/Assets/*{.png,.xcassets}'
end
