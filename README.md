# cidaas-sdk-ios-v2
[![Build Status](https://travis-ci.org/Cidaas/cidaas-sdk-ios-v2.svg?branch=master)](https://travis-ci.org/Cidaas/cidaas-sdk-ios-v2) 
[![codecov.io](https://codecov.io/gh/Cidaas/cidaas-sdk-ios-v2/branch/master/graphs/badge.svg)](https://codecov.io/gh/Cidaas/cidaas-sdk-ios-v2/branch/master)
[![Swift support](https://img.shields.io/badge/Swift-3.3%20%7C%204.0%20%7C%204.1-lightgrey.svg?colorA=28a745&colorB=4E4E4E)](#swift-versions-support)
[![XCode support](https://img.shields.io/badge/Xcode-9.4-lightgrey.svg?colorA=28a745&colorB=4E4E4E)](#swift-versions-support)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Cidaas.svg?style=flat&label=CocoaPods&colorA=28a745&&colorB=4E4E4E)](https://cocoapods.org/pods/Cidaas)
[![Platform](https://img.shields.io/badge/Platforms-iOS-4E4E4E.svg?colorA=28a745)](#installation)

The steps here will guide you through setting up and managing authentication and authorization in your apps using cidaas SDK.

## Table of Contents

<!--ts-->
* [Requirements](#requirements)
* [Installation](#installation)
* [Getting started](#getting-started)
* [Getting Client Id and urls](#getting-client-id-and-urls)
* [Initialisation](#initialisation)
* [Usage](#usage)
    <!--ts-->
    * [Native Browser Login](#native-browser-login)
        <!--ts-->
        * [Classic Login](#classic-login)
        * [Social Login](#social-login)
        <!--te-->
    * [Native UI Integration](/Example/Readme/PureNativeLogin.md)
    <!--te-->


#### Requirements

Operating System | Xcode | Swift
--- | --- | ---
iOS 10.0 or above | 9.0 or above | 3.3 or above 

#### Installation

Cidaas is available through [CocoaPods](https://cocoapods.org/pods/Cidaas). To install it, simply add the following line to your Podfile:

```
pod 'Cidaas'
```
#### Getting started

The following steps are to be followed to use this cidaas SDK.

Create a plist file named as <b>cidaas.plist</b> and fill all the inputs in key value pair. The inputs are below mentioned.

A sample plist file would look like this :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>DomainURL</key>
        <string>Your Domain URL</string>
        <key>RedirectURL</key>
        <string>Your redirect url</string>
        <key>ClientID</key>
        <string>Your client id</string>
    </dict>
</plist>
```

Following sections will help you to generate some of the information that is needed for plist.

#### Getting Client Id and urls
You can get this by creating your App in App settings section of cidaas Admin portal. Once you select the right scope and application type, and fill in all mandatory fields, you can use the generated Client ID and re-direct URLs.


#### Initialisation

The first step of integrating cidaas sdk is the initialisation process.

```swift
var cidaas = Cidaas();
```
or use the shared instance

```swift
var cidaas = Cidaas.shared
```

#### Usage

#### Native Browser Login 
#### Classic Login
You can login using your native browser and redirects to the App once successfully logged in. To login with your native browser call ****loginWithBrowser()****.

```swift
cidaas.loginWithBrowser(delegate: self) {
    switch $0 {
        case .success(let successResponse):
            // your success code here
            break
        case .failure(let error):
            // your failure code here
            break
    }
}
```

#### Social Login
You can also perform social login using your native browser and redirects to the App once successfully logged in. To perform social login call ****loginWithSocial()****.

```swift
cidaas.loginWithSocial(provider: "your_social_provider", delegate: self) { 
    switch $0 {
        case .success(let successResponse):
            // your success code here
            break
        case .failure(let error):
            // your failure code here
            break
    }
}
```
where social provider may be either facebook, google, linkedin or any other providers

Use [customScheme](https://developer.apple.com/documentation/uikit/core_app/communicating_with_other_apps_using_custom_urls#2928963) or [universalLinks](https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html) to return back the control from browser to App.

    Note : Don't forget to add the custom scheme url in your App's redirect url section


If you use custom scheme, configure your URL types and resume the SDK from AppDelegate's **open url** method

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    Cidaas.shared.handleToken(url: url)
    return true
}
```

If you use universal links, configure your Domain setup and resume the SDK from AppDelegate's **userActivity** method

```swift
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    let url = userActivity.webpageURL!
    Cidaas.shared.handleToken(url: url)
    return true
}
```

## Screenshots
<p align="center">

<img src = "https://user-images.githubusercontent.com/26590601/35260372-3b424b8a-0031-11e8-93be-598f473ac753.png" alt="Screen 1" style="width:40%" height="600">

<img src = "https://user-images.githubusercontent.com/26590601/35260352-18800f2e-0031-11e8-908e-85b98c306e99.png" alt="Screen 2" style="width:40%" height="600">

</p>
