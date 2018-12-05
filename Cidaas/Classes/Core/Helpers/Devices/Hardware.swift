//
//  Hardware.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

/// Enum for different iPhone/iPad devices
public enum Hardware {
    case notAvailable
    
    case iPhone2g
    case iPhone3g
    case iPhone3gs
    
    case iPhone4
    case iPhone4_cdma
    case iPhone4s
    
    case iPhone5
    case iPhone5_cdma_gsm
    case iPhone5c
    case iPhone5c_cdma_gsm
    case iPhone5s
    case iPhone5s_cdma_gsm
    
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhoneSE
    
    case iPhone7
    case iPhone7Plus
    
    case iPhone8
    case iPhone8_cn
    case iPhone8Plus
    case iPhone8Plus_cn
    case iPhoneX
    case iPhoneX_cn
    
    case iPodTouch1g
    case iPodTouch2g
    case iPodTouch3g
    case iPodTouch4g
    case iPodTouch5g
    case iPodTouch6g
    
    case iPad
    case iPad2
    case iPad2_wifi
    case iPad2_cdma
    case iPad3
    case iPad3g
    case iPad3_wifi
    case iPad3_wifi_cdma
    case iPad4
    case iPad4_wifi
    case iPad4_gsm_cdma
    
    case iPadMini
    case iPadMini_wifi
    case iPadMini_wifi_cdma
    case iPadMiniRetina_wifi
    case iPadMiniRetina_wifi_cdma
    case iPadMini3_wifi
    case iPadMini3_wifi_cellular
    case iPadMini3_wifi_cellular_cn
    case iPadMini4_wifi
    case iPadMini4_wifi_cellular
    case iPadMiniRetina_wifi_cellular_cn
    
    case iPadAir_wifi
    case iPadAir_wifi_gsm
    case iPadAir_wifi_cdma
    case iPadAir2_wifi
    case iPadAir2_wifi_cellular
    
    case iPadPro_97_wifi
    case iPadPro_97_wifi_cellular
    case iPadPro_wifi
    case iPadPro_wifi_cellular
    
    case iPad5_wifi
    case iPad5_wifi_cellular
    
    case iPadPro2g_wifi
    case iPadPro2g_wifi_cellular
    case iPadPro_105_wifi
    case iPadPro_105_wifi_cellular
    
    case appleTv1g
    case appleTv2g
    case appleTv3g_2012
    case appleTv3g_2013
    case appleTv4g
    
    case appleWatch_38
    case appleWatch_42
    case appleWatch_series_2_38
    case appleWatch_series_2_42
    case appleWatch_series_1_38
    case appleWatch_series_1_42
    
    case simulator
}

/// Enum of the different Apple's device platforms
public enum Platform: String {
    case iPhone = "iPhone"
    case iPodTouch = "iPod"
    case iPad = "iPad"
    case appleTV = "appletv"
    case appleWatch = "watch"
    case unknown = "unknown"
}
