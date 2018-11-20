//
//  DeviceHelper.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

open class DeviceHelper {
    
    /// Stores the list of the devices from the DeviceList.plist
    private let deviceListDict: [String: AnyObject]
    
    /// Initialises the DeviceGuru using DeviceList.plist if the plist is not found then it asserts
    public init() {
        // get the bundle of the DeviceUtil if it's main bundle then it returns main bundle
        // if it's DeviceUtil.framework then it returns the DeviceUtil.framework bundle
        let deviceUtilTopBundle = Bundle(for:DeviceHelper.self)
        if let url = deviceUtilTopBundle.url(forResource: "DeviceGuru", withExtension: "bundle") {
            let deviceUtilBundle = Bundle(url: url)
            if let path = deviceUtilBundle?.path(forResource: "DeviceList", ofType: "plist") {
                self.deviceListDict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
            }
            else {
                // Assert if the plist is not found
                assertionFailure("DevicePlist.plist not found in the bundle.")
                self.deviceListDict = [String: AnyObject]()
            }
        }
        else if let path = deviceUtilTopBundle.path(forResource: "DeviceList", ofType: "plist") {
            // falling back to main bundle
            self.deviceListDict = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        }
        else {
            // Assert if the plist is not found
            //            assertionFailure("DevicePlist.plist not found in the bundle.")
            self.deviceListDict = [String: AnyObject]()
        }
    }
    
    /// This method returns the hardware type
    ///
    ///
    /// - returns: raw `String` of device type
    ///
    public func hardwareString() -> String {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, nil, 0)
        var hw_machine = [CChar](repeating: 0, count: Int(size))
        sysctl(&name, 2, &hw_machine, &size, nil, 0)
        
        let hardware: String = String(cString: hw_machine)
        return hardware
    }
    
    /// This method returns the Hardware enum depending upon harware string
    ///
    ///
    /// - returns: `Hardware` type of the device
    ///
    public func hardware() -> Hardware {
        let hardware = hardwareString()
        
        if (hardware == "iPhone1,1")         { return Hardware.iPhone2g }
        if (hardware == "iPhone1,2")         { return Hardware.iPhone3g }
        if (hardware == "iPhone2,1")         { return Hardware.iPhone3gs }
        
        if (hardware == "iPhone3,1")         { return Hardware.iPhone4 }
        if (hardware == "iPhone3,2")         { return Hardware.iPhone4 }
        if (hardware == "iPhone3,3")         { return Hardware.iPhone4_cdma }
        if (hardware == "iPhone4,1")         { return Hardware.iPhone4s }
        
        if (hardware == "iPhone5,1")         { return Hardware.iPhone5 }
        if (hardware == "iPhone5,2")         { return Hardware.iPhone5_cdma_gsm }
        if (hardware == "iPhone5,3")         { return Hardware.iPhone5c }
        if (hardware == "iPhone5,4")         { return Hardware.iPhone5c_cdma_gsm }
        if (hardware == "iPhone6,1")         { return Hardware.iPhone5s }
        if (hardware == "iPhone6,2")         { return Hardware.iPhone5s_cdma_gsm }
        
        if (hardware == "iPhone7,1")         { return Hardware.iPhone6Plus }
        if (hardware == "iPhone7,2")         { return Hardware.iPhone6 }
        if (hardware == "iPhone8,1")         { return Hardware.iPhone6s }
        if (hardware == "iPhone8,2")         { return Hardware.iPhone6sPlus }
        if (hardware == "iPhone8,4")         { return Hardware.iPhoneSE }
        
        if (hardware == "iPhone9,1")         { return Hardware.iPhone7 }
        if (hardware == "iPhone9,2")         { return Hardware.iPhone7Plus }
        if (hardware == "iPhone9,3")         { return Hardware.iPhone7 }
        if (hardware == "iPhone9,4")         { return Hardware.iPhone7Plus }
        
        if (hardware == "iPhone10,1")         { return Hardware.iPhone8_cn }
        if (hardware == "iPhone10,2")         { return Hardware.iPhone8Plus_cn }
        if (hardware == "iPhone10,3")         { return Hardware.iPhoneX_cn }
        if (hardware == "iPhone10,4")         { return Hardware.iPhone8 }
        if (hardware == "iPhone10,5")         { return Hardware.iPhone8Plus }
        if (hardware == "iPhone10,6")         { return Hardware.iPhoneX }
        
        
        
        if (hardware == "iPod1,1")           { return Hardware.iPodTouch1g }
        if (hardware == "iPod2,1")           { return Hardware.iPodTouch2g }
        if (hardware == "iPod3,1")           { return Hardware.iPodTouch3g }
        if (hardware == "iPod4,1")           { return Hardware.iPodTouch4g }
        if (hardware == "iPod5,1")           { return Hardware.iPodTouch5g }
        if (hardware == "iPod7,1")           { return Hardware.iPodTouch6g }
        
        if (hardware == "iPad1,1")           { return Hardware.iPad }
        if (hardware == "iPad1,2")           { return Hardware.iPad3g }
        
        if (hardware == "iPad2,1")           { return Hardware.iPad2_wifi }
        if (hardware == "iPad2,2")           { return Hardware.iPad2 }
        if (hardware == "iPad2,3")           { return Hardware.iPad2_cdma }
        if (hardware == "iPad2,4")           { return Hardware.iPad2 }
        if (hardware == "iPad2,5")           { return Hardware.iPadMini_wifi }
        if (hardware == "iPad2,6")           { return Hardware.iPadMini }
        if (hardware == "iPad2,7")           { return Hardware.iPadMini_wifi_cdma }
        
        if (hardware == "iPad3,1")           { return Hardware.iPad3_wifi }
        if (hardware == "iPad3,2")           { return Hardware.iPad3_wifi_cdma }
        if (hardware == "iPad3,3")           { return Hardware.iPad3 }
        if (hardware == "iPad3,4")           { return Hardware.iPad4_wifi }
        if (hardware == "iPad3,5")           { return Hardware.iPad4 }
        if (hardware == "iPad3,6")           { return Hardware.iPad4_gsm_cdma }
        
        if (hardware == "iPad4,1")           { return Hardware.iPadAir_wifi }
        if (hardware == "iPad4,2")           { return Hardware.iPadAir_wifi_gsm }
        if (hardware == "iPad4,3")           { return Hardware.iPadAir_wifi_cdma }
        if (hardware == "iPad4,4")           { return Hardware.iPadMiniRetina_wifi }
        if (hardware == "iPad4,5")           { return Hardware.iPadMiniRetina_wifi_cdma }
        if (hardware == "iPad4,6")           { return Hardware.iPadMiniRetina_wifi_cellular_cn }
        if (hardware == "iPad4,7")           { return Hardware.iPadMini3_wifi }
        if (hardware == "iPad4,8")           { return Hardware.iPadMini3_wifi_cellular }
        if (hardware == "iPad4,9")           { return Hardware.iPadMini3_wifi_cellular_cn }
        
        if (hardware == "iPad5,1")           { return Hardware.iPadMini4_wifi }
        if (hardware == "iPad5,2")           { return Hardware.iPadMini4_wifi_cellular }
        if (hardware == "iPad5,3")           { return Hardware.iPadAir2_wifi }
        if (hardware == "iPad5,4")           { return Hardware.iPadAir2_wifi_cellular }
        
        if (hardware == "iPad6,3")           { return Hardware.iPadPro_97_wifi }
        if (hardware == "iPad6,4")           { return Hardware.iPadPro_97_wifi_cellular }
        if (hardware == "iPad6,7")           { return Hardware.iPadPro_wifi }
        if (hardware == "iPad6,8")           { return Hardware.iPadPro_wifi_cellular }
        if (hardware == "iPad6,11")          { return Hardware.iPad5_wifi }
        if (hardware == "iPad6,12")          { return Hardware.iPad5_wifi_cellular }
        
        if (hardware == "iPad7,1")           { return Hardware.iPadPro2g_wifi }
        if (hardware == "iPad7,2")           { return Hardware.iPadPro2g_wifi_cellular }
        if (hardware == "iPad7,3")           { return Hardware.iPadPro_105_wifi }
        if (hardware == "iPad7,4")           { return Hardware.iPadPro_105_wifi_cellular }
        
        if (hardware == "AppleTV1,1")        { return Hardware.appleTv1g }
        if (hardware == "AppleTV2,1")        { return Hardware.appleTv2g }
        if (hardware == "AppleTV3,1")        { return Hardware.appleTv3g_2012 }
        if (hardware == "AppleTV3,2")        { return Hardware.appleTv3g_2013 }
        if (hardware == "AppleTV5,3")        { return Hardware.appleTv4g }
        
        if (hardware == "Watch1,1")          { return Hardware.appleWatch_38 }
        if (hardware == "Watch1,2")          { return Hardware.appleWatch_42 }
        if (hardware == "Watch2,3")          { return Hardware.appleWatch_series_2_38 }
        if (hardware == "Watch2,4")          { return Hardware.appleWatch_series_2_42 }
        if (hardware == "Watch2,6")          { return Hardware.appleWatch_series_1_38 }
        if (hardware == "Watch2,7")          { return Hardware.appleWatch_series_1_42 }
        
        if (hardware == "i386")              { return Hardware.simulator }
        if (hardware == "x86_64")            { return Hardware.simulator }
        if (hardware.hasPrefix("iPhone"))    { return Hardware.simulator }
        if (hardware.hasPrefix("iPod"))      { return Hardware.simulator }
        if (hardware.hasPrefix("iPad"))      { return Hardware.simulator }
        
        //log message that your device is not present in the list
        logMessage(hardware)
        
        return Hardware.notAvailable
    }
    
    /// This method returns the Platform enum depending upon harware string
    ///
    ///
    /// - returns: `Platform` type of the device
    ///
    public func platform() -> Platform {
        
        let hardware = hardwareString().lowercased()
        
        if hardware.hasPrefix(Platform.iPhone.rawValue) { return Platform.iPhone }
        if hardware.hasPrefix(Platform.iPodTouch.rawValue) { return Platform.iPodTouch }
        if hardware.hasPrefix(Platform.iPad.rawValue) { return Platform.iPad }
        if hardware.hasPrefix(Platform.appleTV.rawValue) { return Platform.appleTV }
        if hardware.hasPrefix(Platform.appleWatch.rawValue) { return Platform.appleWatch }
        
        return Platform.unknown
    }
    
    
    /// This method returns the readable description of hardware string
    ///
    /// - returns: readable description `String` of the device
    ///
    public func hardwareDescription() -> String? {
        let hardware = hardwareString()
        
        let hardwareDetail = self.deviceListDict[hardware] as? [String: AnyObject]
        if let hardwareDescription = hardwareDetail?["name"] {
            return hardwareDescription as? String
        }
        
        //log message that your device is not present in the list
        logMessage(hardware)
        return nil
    }
    
    /// This method returns the hardware number not actual but logically.
    /// e.g. if the hardware string is 5,1 then hardware number would be 5.1
    ///
    public func hardwareNumber() -> Float {
        let hardware = hardwareString()
        
        let hardwareDetail = self.deviceListDict[hardware] as? [String: AnyObject]
        if let hardwareNumber = hardwareDetail?["version"] as? Float {
            return hardwareNumber
        }
        
        //log message that your device is not present in the list
        logMessage(hardware)
        
        return 200.0 //device might be new one of missing one so returning 200.0f
    }
    
    
    /// This method returns the resolution for still image that can be received
    /// from back camera of the current device. Resolution returned for image oriented landscape right.
    ///
    /// - parameters:
    ///     - hardware: `Hardware` type of the device
    ///
    /// - returns: `CGSize` of the image captured by the device
    ///
    public func backCameraStillImageResolutionInPixels(_ hardware: Hardware) -> CGSize {
        switch (hardware) {
        case .iPhone2g, .iPhone3g:
            return CGSize(width: 1600, height: 1200)
            
        case .iPhone3gs:
            return CGSize(width: 2048, height: 1536)
            
        case .iPhone4, .iPhone4_cdma, .iPad3_wifi, .iPad3_wifi_cdma, .iPad3, .iPad4_wifi, .iPad4, .iPad4_gsm_cdma:
            return CGSize(width: 2592, height: 1936)
            
        case .iPhone4s, .iPhone5, .iPhone5_cdma_gsm, .iPhone5c, .iPhone5c_cdma_gsm, .iPhone6, .iPhone6Plus:
            return CGSize(width: 3264, height: 2448)
            
        case .iPodTouch4g:
            return CGSize(width: 960, height: 720)
            
        case .iPodTouch5g:
            return CGSize(width: 2440, height: 1605)
            
        case .iPad2_wifi, .iPad2, .iPad2_cdma:
            return CGSize(width: 872, height: 720)
            
        case .iPadMini_wifi, .iPadMini, .iPadMini_wifi_cdma:
            return CGSize(width: 1820, height: 1304)
            
        case .iPadMini4_wifi, .iPadMini4_wifi_cellular:
            return CGSize(width: 3264, height: 2448)
            
        case .iPadAir2_wifi, .iPadAir2_wifi_cellular:
            return CGSize(width: 2048, height: 1536)
            
        case .iPhone6s, .iPhone6sPlus, .iPhoneSE, .iPhone7, .iPhone7Plus:
            return CGSize(width: 4032, height: 3024)
            
        case .iPadPro_97_wifi, .iPadPro_97_wifi_cellular:
            return CGSize(width: 4032, height: 3024)
            
        case .iPadPro_wifi, .iPadPro_wifi_cellular:
            return CGSize(width: 3264, height: 2448)
            
        case .iPadPro2g_wifi, .iPadPro2g_wifi_cellular, .iPadPro_105_wifi, .iPadPro_105_wifi_cellular:
            return CGSize(width: 4032, height: 3024)
            
        default:
            print("We have no resolution for your device's camera listed in this category. Please, take photo with back camera of your device, get its resolution in pixels (via Preview Cmd+I for example) and add a comment to this repository (https://github.com/InderKumarRathore/DeviceGuru) on GitHub.com in format Device = Wpx x Hpx.")
        }
        print("Your device is: \(hardwareDescription() ?? "unknown")")
        
        return CGSize.zero
    }
    
    /// Internal method for loggin, you don't need this method
    ///
    /// - parameters:
    ///     - hardware: `String` hardware type of the device
    ///
    private func logMessage(_ hardware: String) {
        print("This is a device which is not listed in this category. Please visit https://github.com/InderKumarRathore/DeviceGuru and add a comment there.")
        print("Your device hardware string is: %@", hardware)
    }
}
