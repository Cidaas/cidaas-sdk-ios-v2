//
//  TouchID.swift
//  Cidaas
//
//  Created by ganesh on 13/02/19.
//

import Foundation
import LocalAuthentication

public class TouchID {
    
    public static let sharedInstance = TouchID()
    var authenticatedContext = LAContext()
    var error: NSError?
    
    public func checkIfTouchIdAvailable(callback: @escaping (Bool, String?, Int32?)->()) {
        if authenticatedContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            DispatchQueue.main.async {
                callback(true, nil, nil)
            }
        }
        else {
            switch error!.code {
            case LAError.touchIDNotAvailable.rawValue:
                DispatchQueue.main.async {
                    callback(false, "TouchId not available", WebAuthErrorCode.TOUCHID_NOT_AVAILABLE.rawValue)
                }
                break
            case LAError.invalidContext.rawValue:
                self.authenticatedContext = LAContext()
                self.checkIfTouchIdAvailable(callback: callback)
                DispatchQueue.main.async {
                    callback(false, "Invalid context", WebAuthErrorCode.TOUCHID_INVALID_CONTEXT.rawValue)
                }
                break
            case LAError.touchIDNotEnrolled.rawValue:
                DispatchQueue.main.async {
                    callback(false, "TouchId not enrolled", WebAuthErrorCode.TOUCHID_NOT_ENROLLED.rawValue)
                }
                break
            case LAError.passcodeNotSet.rawValue:
                DispatchQueue.main.async {
                    callback(false, "Passcode not configured", WebAuthErrorCode.TOUCH_ID_PASSCODE_NOT_CONFIGURED.rawValue)
                }
                break
            case LAError.authenticationFailed.rawValue:
                DispatchQueue.main.async {
                    callback(false, "Invalid authentication", WebAuthErrorCode.TOUCH_ID_INVALID_AUTHENTICATION.rawValue)
                }
                break
            case LAError.appCancel.rawValue:
                DispatchQueue.main.async {
                    callback(false, "App cancelled", WebAuthErrorCode.TOUCH_ID_APP_CANCELLED.rawValue)
                }
                break
            case LAError.systemCancel.rawValue:
                DispatchQueue.main.async {
                    callback(false, "System cancelled", WebAuthErrorCode.TOUCH_ID_SYSTEM_CANCELLED.rawValue)
                }
                break
            case LAError.userCancel.rawValue:
                DispatchQueue.main.async {
                    callback(false, "User cancelled", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                }
                break
            case LAError.touchIDLockout.rawValue:
                DispatchQueue.main.async {
                    callback(false, "TouchId locked", WebAuthErrorCode.TOUCHID_LOCKED.rawValue)
                }
                break
            case LAError.userFallback.rawValue:
                DispatchQueue.main.async {
                    callback(false, "User cancelled", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                }
                break
            case LAError.notInteractive.rawValue:
                DispatchQueue.main.async {
                    callback(false, "Not interactive", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                }
                break
            default:
                DispatchQueue.main.async {
                    callback(false, "Error occured", WebAuthErrorCode.TOUCHID_DEFAULT_ERROR.rawValue)
                }
                break
            }
        }
    }
    
    public func checkIfPasscodeAvailable(invalidateAuthenticationContext: Bool, callback: @escaping (Bool, String?, Int32?)->()) {
        if invalidateAuthenticationContext == true {
            self.authenticatedContext.invalidate()
        }
        
        if authenticatedContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            DispatchQueue.main.async {
                callback(true, nil, nil)
            }
        }
        else {
            switch error!.code {
            case LAError.touchIDNotAvailable.rawValue:
                DispatchQueue.main.async {
                    callback(false, "TouchId not available", WebAuthErrorCode.TOUCHID_NOT_AVAILABLE.rawValue)
                }
                break
            case LAError.invalidContext.rawValue:
                self.authenticatedContext = LAContext()
                self.checkIfPasscodeAvailable(invalidateAuthenticationContext: false, callback: callback)
                DispatchQueue.main.async {
                    callback(false, "Invalid context", WebAuthErrorCode.TOUCHID_INVALID_CONTEXT.rawValue)
                }
                break
            case LAError.touchIDNotEnrolled.rawValue:
                DispatchQueue.main.async {
                    callback(false, "TouchId not enrolled", WebAuthErrorCode.TOUCHID_NOT_ENROLLED.rawValue)
                }
                break
            case LAError.passcodeNotSet.rawValue:
                DispatchQueue.main.async {
                    callback(false, "Passcode not configured", WebAuthErrorCode.TOUCH_ID_PASSCODE_NOT_CONFIGURED.rawValue)
                }
                break
            case LAError.authenticationFailed.rawValue:
                DispatchQueue.main.async {
                    callback(false, "Invalid authentication", WebAuthErrorCode.TOUCH_ID_INVALID_AUTHENTICATION.rawValue)
                }
                break
            case LAError.appCancel.rawValue:
                DispatchQueue.main.async {
                    callback(false, "App cancelled", WebAuthErrorCode.TOUCH_ID_APP_CANCELLED.rawValue)
                }
                break
            case LAError.systemCancel.rawValue:
                DispatchQueue.main.async {
                    callback(false, "System cancelled", WebAuthErrorCode.TOUCH_ID_SYSTEM_CANCELLED.rawValue)
                }
                break
            case LAError.userCancel.rawValue:
                DispatchQueue.main.async {
                    callback(false, "User cancelled", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                }
                break
            case LAError.touchIDLockout.rawValue:
                DispatchQueue.main.async {
                    callback(false, "TouchId locked", WebAuthErrorCode.TOUCHID_LOCKED.rawValue)
                }
                break
            case LAError.userFallback.rawValue:
                DispatchQueue.main.async {
                    callback(false, "User cancelled", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                }
                break
            default:
                DispatchQueue.main.async {
                    callback(false, "Error occured", WebAuthErrorCode.TOUCHID_DEFAULT_ERROR.rawValue)
                }
                break
            }
        }
    }
    
    public func checkTouchIDMatching(localizedReason: String, callback: @escaping (Bool, String?, Int32?)->()) {
        authenticatedContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReason, reply: { (success, error) -> Void in
            if( success ) {
                DispatchQueue.main.async {
                    callback(true, nil, nil)
                }
            }else {
                switch error!._code {
                case LAError.touchIDNotAvailable.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "TouchId not available", WebAuthErrorCode.TOUCHID_NOT_AVAILABLE.rawValue)
                    }
                    break
                case LAError.invalidContext.rawValue:
                    self.authenticatedContext = LAContext()
                    self.checkIfTouchIdAvailable(callback: callback)
                    DispatchQueue.main.async {
                        callback(false, "Invalid context", WebAuthErrorCode.TOUCHID_INVALID_CONTEXT.rawValue)
                    }
                    break
                case LAError.touchIDNotEnrolled.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "TouchId not enrolled", WebAuthErrorCode.TOUCHID_NOT_ENROLLED.rawValue)
                    }
                    break
                case LAError.passcodeNotSet.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "Passcode not configured", WebAuthErrorCode.TOUCH_ID_PASSCODE_NOT_CONFIGURED.rawValue)
                    }
                    break
                case LAError.authenticationFailed.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "Invalid authentication", WebAuthErrorCode.TOUCH_ID_INVALID_AUTHENTICATION.rawValue)
                    }
                    break
                case LAError.appCancel.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "App cancelled", WebAuthErrorCode.TOUCH_ID_APP_CANCELLED.rawValue)
                    }
                    break
                case LAError.systemCancel.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "System cancelled", WebAuthErrorCode.TOUCH_ID_SYSTEM_CANCELLED.rawValue)
                    }
                    break
                case LAError.userCancel.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "User cancelled", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                    }
                    break
                case LAError.touchIDLockout.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "TouchId locked", WebAuthErrorCode.TOUCHID_LOCKED.rawValue)
                    }
                    break
                case LAError.userFallback.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "User cancelled", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                    }
                    break
                case LAError.notInteractive.rawValue:
                    DispatchQueue.main.async {
                        callback(false, "Not interactive", WebAuthErrorCode.TOUCH_ID_USER_CANCELLED.rawValue)
                    }
                    break
                default:
                    DispatchQueue.main.async {
                        callback(false, "Error occured", WebAuthErrorCode.TOUCHID_DEFAULT_ERROR.rawValue)
                    }
                    break
                }
            }
        })
    }
}
