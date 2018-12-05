//
//  CidaasUserAgentBuilder.swift
//  Cidaas
//
//  Created by ganesh on 05/10/18.
//

import Foundation
import UIKit

public class CidaasUserAgentBuilder {
    
    public static var shared = CidaasUserAgentBuilder()
    
    //eg. Darwin/16.3.0
    func DarwinVersion() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return "Darwin/\(dv)"
    }
    //eg. CFNetwork/808.3
    func CFNetworkVersion() -> String {
        let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
        let version = dictionary?["CFBundleShortVersionString"] as! String
        return "CFNetwork/\(version)"
    }
    
    //eg. iphone6Plus
    func deviceName() -> String {
        let deviceHelper = DeviceHelper()
        return String(describing: deviceHelper.hardware())
    }
    
    
    //eg. iOS/10_1
    func deviceVersion() -> String {
        let currentDevice = UIDevice.current
        return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
    }
    
    //eg. MyApp/1
    func appNameAndVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        var name = dictionary["CFBundleDisplayName"] as! String
        name = name.replacingOccurrences(of: " ", with: "_")
        return "\(name)/\(version)"
    }
    
    public func UAString() -> String {
        
        return "\(appNameAndVersion())\(getFrameworkVersion(framework: Cidaas.self)) \(deviceName()) \(deviceVersion()) \(CFNetworkVersion()) \(DarwinVersion())"
    }
    
    func getFrameworkVersion(framework:AnyClass) -> String {
        if let sdkVersion = Bundle(for: framework.self).infoDictionary?["CFBundleShortVersionString"] {
            return "(\(sdkVersion))"
        }else{
            return ""
        }
    }
    
}
