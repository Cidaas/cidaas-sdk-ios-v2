#
# Be sure to run `pod lib lint Cidaas.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Cidaas'
  s.version          = '1.3.0'
  s.summary          = 'Native SDK for iOS providing login, registration and verification functionalities'
  s.homepage         = 'https://github.com/Cidaas/cidaas-sdk-ios-v2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cidaas' => 'developer@cidaas.de' }
  s.source       = { :git => 'https://github.com/Cidaas/cidaas-sdk-ios-v2.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'Cidaas/Classes/**/*'
  s.dependency 'Alamofire', '~> 5.1'
  s.dependency 'OneTimePassword', '~> 3.2'
  s.dependency 'CryptoSwift', '~> 1.3'
  s.dependency 'SwiftKeychainWrapper', '~> 3.4'
  s.dependency 'AnyCodable-FlightSchool', '~> 0.4.0'
  s.swift_version = '5.0'
  
  s.subspec 'Core' do |core|
      core.source_files = 'Cidaas/Classes/Core/**/*'
      core.resources    = 'Cidaas/Resources/**/*.*'
  end
  
  s.subspec 'Facebook' do |fb|
      fb.source_files = 'Cidaas/Classes/Facebook/**/*'
      fb.dependency 'FBSDKCoreKit', '5.5.0'
      fb.dependency 'FBSDKLoginKit', '5.5.0'
      fb.dependency 'FacebookCore', '0.8'
      fb.dependency 'FacebookLogin', '0.8'
      fb.dependency 'Cidaas/Core'
  end
  
  s.subspec 'Verification' do |verification|
      verification.source_files = 'Cidaas/Classes/V2/Verification/**/*'
      verification.dependency 'Cidaas/Core'
  end
  
  s.subspec 'Native' do |native|
      native.source_files = 'Cidaas/Classes/V2/Native/**/*'
      native.dependency 'Cidaas/Core'
  end
  
  s.subspec 'Consent' do |consent|
      consent.source_files = 'Cidaas/Classes/V2/Consent/**/*'
      consent.dependency 'Cidaas/Core'
  end
end
