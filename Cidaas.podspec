#
# Be sure to run `pod lib lint Cidaas.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Cidaas'
  s.version          = '0.0.1.4'
  s.summary          = 'Native SDK for iOS providing login, registration and verification functionalities'
  s.homepage         = 'https://github.com/Cidaas/cidaas-sdk-ios-v2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cidaas' => 'ganesh.kumar@widas.in' }
  s.source       = { :git => 'https://github.com/Cidaas/cidaas-sdk-ios-v2.git', :tag => s.version }
  s.ios.deployment_target = '10.0'
  s.source_files = 'Cidaas/Classes/**/*'
  s.dependency 'Alamofire', '~> 4.7.3'
  s.dependency 'OneTimePassword', '~> 3.1.4'
  s.dependency 'CryptoSwift', '~> 0.12'
end
