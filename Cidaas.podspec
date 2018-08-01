Pod::Spec.new do |s|
s.name         = "Cidaas"
s.version      = "0.0.1.1"
s.summary      = "Native SDK for iOS providing login, registration and verification functionalities"
s.homepage     = "https://github.com/Cidaas/cidaas-sdk-ios-v2"
s.license      = "MIT"
s.author       = { "Cidaas" => "ganesh.kumar@widas.in" }

s.ios.deployment_target = "10.0"

s.source       = { :git => "https://github.com/Cidaas/cidaas-sdk-ios-v2.git", :tag => s.version }
s.source_files = "Sources/**/*"
s.dependency 'Alamofire', '~> 4.7'
s.dependency 'OneTimePassword', '~> 3.1'
s.dependency 'CryptoSwift', '~> 0.10'
end
