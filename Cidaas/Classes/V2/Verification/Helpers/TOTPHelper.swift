//
//  TOTPVerificationController.swift
//  sdkiOS
//
//  Created by ganesh on 26/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import OneTimePassword

public class TOTPHelper {
    
    public func gettingTOTPCode(url: URL) -> TOTP {
        let totp = TOTP()
        if let token = Token(url: url) {
            totp.totp_string = token.currentPassword ?? ""
            totp.name = token.name
            totp.issuer = token.issuer
            
            // time based actions
            var currentTime = NSDate().timeIntervalSince1970
            currentTime = currentTime.truncatingRemainder(dividingBy: 30)
            let finalCurrentTime = 30 - Int(currentTime)
            totp.timer_count = String(format:"%02d", finalCurrentTime)
            
            return totp
        }
        return TOTP()
    }
}
