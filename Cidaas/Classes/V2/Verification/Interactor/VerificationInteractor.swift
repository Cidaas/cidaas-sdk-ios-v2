//
//  VerificationInteractor.swift
//  Cidaas
//
//  Created by ganesh on 06/05/19.
//

import Foundation

public class VerificationInteractor {
    
    public init() {}
    
    var push_selected_number: String = ""
    
    public static var shared: VerificationInteractor = VerificationInteractor()
    
    public func setup(verificationType: String, incomingData: SetupRequest, callback: @escaping (Result<SetupResponse>) -> Void) {
        // validation
        if (verificationType == "" || (incomingData.access_token == "" && incomingData.sub == "")) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or access_token or sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.setup(setupResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.setup(setupResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.setup(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.setup(setupResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func scanned(verificationType: String, incomingData: ScannedRequest, callback: @escaping (Result<ScannedResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "" || incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id or sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.scanned(scannedResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.scanned(scannedResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.scanned(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.scanned(scannedResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func enroll(verificationType: String, photo: UIImage = UIImage(), voice: Data = Data(), incomingData: EnrollRequest, callback: @escaping (Result<EnrollResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id or pass_code cannot be empty", statusCode: 417)
            VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.enroll(verificationType: verificationType, photo: photo, voice: voice, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.enroll(enrollResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func initiate(verificationType: String, incomingData: InitiateRequest, callback: @escaping (Result<InitiateResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.sub == "" || incomingData.request_id == "" || incomingData.usage_type == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or sub or request_id or usage_type cannot be empty", statusCode: 417)
            VerificationPresenter.shared.initiate(initiateResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.initiate(initiateResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.initiate(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.initiate(initiateResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func pushAcknowledge(verificationType: String, incomingData: PushAcknowledgeRequest, callback: @escaping (Result<PushAcknowledgeResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAcknowledge(pushAcknowledgeResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAcknowledge(pushAcknowledgeResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.pushAcknowledge(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.pushAcknowledge(pushAcknowledgeResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func pushAllow(verificationType: String, incomingData: PushAllowRequest, callback: @escaping (Result<PushAllowResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAllow(pushAllowResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushAllow(pushAllowResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.pushAllow(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.pushAllow(pushAllowResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func pushReject(verificationType: String, incomingData: PushRejectRequest, callback: @escaping (Result<PushRejectResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushReject(pushRejectResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.pushReject(pushRejectResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.pushReject(verificationType: verificationType, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.pushReject(pushRejectResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func authenticate(verificationType: String, photo: UIImage = UIImage(), voice: Data = Data(), incomingData: AuthenticateRequest, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        // validation
        if (verificationType == "" || incomingData.exchange_id == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "verificationType or exchange_id cannot be empty", statusCode: 417)
            VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.authenticate(verificationType: verificationType, photo: photo, voice: voice, incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.authenticate(authenticateResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func delete(incomingData: DeleteRequest, callback: @escaping (Result<DeleteResponse>) -> Void) {
        // validation
        if (incomingData.sub == "" || incomingData.verificationType == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub or exchange_id or verificationType cannot be empty", statusCode: 417)
            VerificationPresenter.shared.delete(deleteResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.deleteAll(deleteResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.delete(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.delete(deleteResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func deleteAll(incomingData: DeleteRequest, callback: @escaping (Result<DeleteResponse>) -> Void) {
        // validation
        // no validation
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.deleteAll(deleteResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.deleteAll(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.deleteAll(deleteResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getConfiguredList(incomingData: MFAListRequest, callback: @escaping (Result<MFAListResponse>) -> Void) {
        // validation
        if (incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getConfiguredList(mfaListResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getConfiguredList(mfaListResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.getConfiguredList(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.getConfiguredList(mfaListResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getPendingNotificationList(incomingData: PendingNotificationRequest, callback: @escaping (Result<PendingNotificationResponse>) -> Void) {
        // validation
        if (incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getPendingNotificationList(pendingNotificationListResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getPendingNotificationList(pendingNotificationListResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.getPendingNotificationList(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.getPendingNotificationList(pendingNotificationListResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func getAuthenticatedHistoryList(incomingData: AuthenticatedHistoryRequest, callback: @escaping (Result<AuthenticatedHistoryResponse>) -> Void) {
        // validation
        if (incomingData.sub == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getAuthenticatedHistoryList(authenticatedHistoryListResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.getAuthenticatedHistoryList(authenticatedHistoryListResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.getAuthenticatedHistoryList(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.getAuthenticatedHistoryList(authenticatedHistoryListResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    public func updateFCM(incomingData: UpdateFCMRequest) {
        // check if first time
        let old_push_id = DBHelper.shared.getFCM()
        
        if (old_push_id == "") {
            DBHelper.shared.setFCM(fcmToken: incomingData.push_id)
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 200, errorMessage: "FCMToken successfully updated", statusCode: 200)
            VerificationPresenter.shared.updateFCM(updateFCMResponse: nil, errorResponse: error)
            return
        }
        if (old_push_id == incomingData.push_id) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 200, errorMessage: "No change in FCM", statusCode: 200)
            VerificationPresenter.shared.updateFCM(updateFCMResponse: nil, errorResponse: error)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.updateFCM(updateFCMResponse: nil, errorResponse: error)
            return
        }
        
        incomingData.old_push_id = old_push_id
        
        // call worker
        VerificationServiceWorker.shared.updateFCM(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.updateFCM(updateFCMResponse: response, errorResponse: error)
        }
    }
    
    public func configure(incomingData: ConfigureRequest, photo: UIImage = UIImage(), voice: Data = Data(), callback: @escaping (Result<EnrollResponse>) -> Void) {
        
        let setupRequest = SetupRequest()
        setupRequest.access_token = incomingData.access_token
        
        self.setup(verificationType: incomingData.verificationType, incomingData: setupRequest) {
            switch $0 {
            case .success(let setupSuccessResponse):
                if (incomingData.verificationType == VerificationTypes.TOTP.rawValue) {
                    
                    // save qrcode
                    DBHelper.shared.setTOTPSecret(secret: setupSuccessResponse.data.totp_secret, name: setupSuccessResponse.data.totp_secret, issuer: setupSuccessResponse.data.totp_secret, key: setupSuccessResponse.data.sub)
                    let secret = DBHelper.shared.getTOTPSecret(key: setupSuccessResponse.data.sub)
                    let enrollRequest = EnrollRequest()
                    enrollRequest.pass_code = TOTPVerificationController.shared.gettingTOTPCode(url: URL(string: secret.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!).totp_string
                    enrollRequest.exchange_id = setupSuccessResponse.data.exchange_id.exchange_id
                    self.enroll(verificationType: incomingData.verificationType, incomingData: enrollRequest, callback: callback)
                }
                else {
                    let scannedRequest = ScannedRequest()
                    scannedRequest.sub = setupSuccessResponse.data.sub
                    scannedRequest.exchange_id = setupSuccessResponse.data.exchange_id.exchange_id
                    self.push_selected_number = setupSuccessResponse.data.push_selected_number
                    
                    self.scanned(verificationType: incomingData.verificationType, incomingData: scannedRequest) {
                        switch $0 {
                        case .success(let scannedSuccessResponse):
                            
                            let enrollRequest = EnrollRequest()
                            enrollRequest.pass_code = incomingData.pass_code
                            enrollRequest.exchange_id = scannedSuccessResponse.data.exchange_id.exchange_id
                            enrollRequest.attempt = incomingData.attempt
                            enrollRequest.localizedReason = incomingData.localizedReason
                            
                            if (incomingData.verificationType == VerificationTypes.PUSH.rawValue) {
                                enrollRequest.pass_code = self.push_selected_number
                            }
                            
                            if (incomingData.verificationType == VerificationTypes.TOUCH.rawValue) {
                                self.askForTouchorFaceIdForEnroll(incomingData: enrollRequest, callback: callback)
                            }
                            else {
                                self.enroll(verificationType: incomingData.verificationType, photo: photo, voice: voice, incomingData: enrollRequest, callback: callback)
                            }
                            
                            break
                        case .failure(let scannedErrorResponse):
                            DispatchQueue.main.async {
                                callback(Result.failure(error: scannedErrorResponse))
                            }
                            break
                        }
                    }
                }
                break
            case .failure(let setupErrorResponse):
                DispatchQueue.main.async {
                    callback(Result.failure(error: setupErrorResponse))
                }
                break
            }
        }
    }
    
    public func login(incomingData: LoginRequest, photo: UIImage, voice: Data, callback: @escaping (Result<LoginResponse>) -> Void) {
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.login(loginResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        let initiateRequest = InitiateRequest()
        initiateRequest.sub = incomingData.sub
        initiateRequest.request_id = incomingData.request_id
        initiateRequest.usage_type = incomingData.usage_type
    
        self.initiate(verificationType: incomingData.verificationType, incomingData: initiateRequest) {
            switch $0 {
            case .success(let initiateSuccessResponse):
                
                let authenticateRequest = AuthenticateRequest()
                authenticateRequest.sub = initiateSuccessResponse.data.sub
                authenticateRequest.exchange_id = initiateSuccessResponse.data.exchange_id.exchange_id
                authenticateRequest.pass_code = incomingData.pass_code
                authenticateRequest.localizedReason = incomingData.localizedReason
                
                self.push_selected_number = initiateSuccessResponse.data.push_selected_number
                
                if (incomingData.verificationType == VerificationTypes.TOUCH.rawValue) {
                    self.askForTouchorFaceIdForAuthenticate(incomingData: authenticateRequest) {
                        switch $0 {
                        case .success(let authenticateSuccessResponse):
                            if (incomingData.usage_type == UsageTypes.PASSWORDLESS.rawValue) {
                                let passwordlessRequest = PasswordlessRequest()
                                passwordlessRequest.requestId = incomingData.request_id
                                passwordlessRequest.status_id = authenticateSuccessResponse.data.status_id
                                passwordlessRequest.sub = incomingData.sub
                                passwordlessRequest.verificationType = incomingData.verificationType
                                self.continueMFA(passwordlessRequest: passwordlessRequest, properties: savedProp!, callback: callback)
                            }
                            break
                        case .failure(let authenticateErrorResponse):
                            VerificationPresenter.shared.login(loginResponse: nil, errorResponse: authenticateErrorResponse, callback: callback)
                            break
                        }
                    }
                }
                else if (incomingData.verificationType == VerificationTypes.PUSH.rawValue) {
                    authenticateRequest.pass_code = self.push_selected_number
                    self.authenticate(verificationType: incomingData.verificationType, incomingData: authenticateRequest) {
                        switch $0 {
                        case .success(let authenticateSuccessResponse):
                            if (incomingData.usage_type == UsageTypes.PASSWORDLESS.rawValue) {
                                let passwordlessRequest = PasswordlessRequest()
                                passwordlessRequest.requestId = incomingData.request_id
                                passwordlessRequest.status_id = authenticateSuccessResponse.data.status_id
                                passwordlessRequest.sub = incomingData.sub
                                passwordlessRequest.verificationType = incomingData.verificationType

                                self.continueMFA(passwordlessRequest: passwordlessRequest, properties: savedProp!, callback: callback)
                            }
                            break
                        case .failure(let authenticateErrorResponse):
                            VerificationPresenter.shared.login(loginResponse: nil, errorResponse: authenticateErrorResponse, callback: callback)
                            break
                        }
                    }
                }
                else {
                    self.authenticate(verificationType: incomingData.verificationType, photo: photo, voice: voice, incomingData: authenticateRequest) {
                        switch $0 {
                        case .success(let authenticateSuccessResponse):
                            if (incomingData.usage_type == UsageTypes.PASSWORDLESS.rawValue) {
                                let passwordlessRequest = PasswordlessRequest()
                                passwordlessRequest.requestId = incomingData.request_id
                                passwordlessRequest.status_id = authenticateSuccessResponse.data.status_id
                                passwordlessRequest.sub = incomingData.sub
                                passwordlessRequest.verificationType = incomingData.verificationType
                                self.continueMFA(passwordlessRequest: passwordlessRequest, properties: savedProp!, callback: callback)
                            }
                            break
                        case .failure(let authenticateErrorResponse):
                            VerificationPresenter.shared.login(loginResponse: nil, errorResponse: authenticateErrorResponse, callback: callback)
                            break
                        }
                    }
                }
                break
            case .failure(let initiateErrorResponse):
                VerificationPresenter.shared.login(loginResponse: nil, errorResponse: initiateErrorResponse, callback: callback)
                break
            }
        }
    }
    
    public func passwordlessContinue(incomingData: PasswordlessRequest, callback: @escaping (Result<AuthzCodeResponse>) -> Void) {
        
        // validation
        if (incomingData.sub == "" || incomingData.requestId == "" || incomingData.status_id == "" || incomingData.verificationType == "") {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            VerificationPresenter.shared.passwordlessContinue(passwordlessContinueResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // get saved properties
        let savedProp = getProperties()
        if (savedProp == nil) {
            // send response to presenter
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "properties cannot be empty", statusCode: 417)
            VerificationPresenter.shared.passwordlessContinue(passwordlessContinueResponse: nil, errorResponse: error, callback: callback)
            return
        }
        
        // call worker
        VerificationServiceWorker.shared.passwordlessContinue(incomingData: incomingData, properties: savedProp!) { response, error in
            VerificationPresenter.shared.passwordlessContinue(passwordlessContinueResponse: response, errorResponse: error, callback: callback)
        }
    }
    
    func getProperties() -> Dictionary<String, String>? {
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            return savedProp!
        }
        return nil
    }
    
    public func askForTouchorFaceIdForEnroll(incomingData: EnrollRequest, callback: @escaping (Result<EnrollResponse>) -> Void) {
        // ask for touch id or face id
        let touchId = TouchID()
        touchId.checkIfTouchIdAvailable { (success, errorMessage, errorCode) in
            if success == true {
                touchId.checkTouchIDMatching(localizedReason: incomingData.localizedReason, callback: { (res_success, res_errorMessage, res_errorCode) in
                    if res_success == true {
                        self.enroll(verificationType: VerificationTypes.TOUCH.rawValue, incomingData: incomingData, callback: callback)
                    }
                    else {
                        // send response to presenter
                        let error = WebAuthError.shared
                        error.errorMessage = res_errorMessage ?? WebAuthError.shared.errorMessage
                        error.errorCode = res_errorCode ?? WebAuthError.shared.errorCode
                        let errorResponse = error.error
                        errorResponse.error.code = res_errorCode ?? WebAuthError.shared.errorCode
                        
                        VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
                        
                        return
                    }
                })
            }
            else {
                // send response to presenter
                let error = WebAuthError.shared
                error.errorMessage = errorMessage ?? WebAuthError.shared.errorMessage
                error.errorCode = errorCode ?? WebAuthError.shared.errorCode
                let errorResponse = error.error
                errorResponse.error.code = errorCode ?? WebAuthError.shared.errorCode
                
                VerificationPresenter.shared.enroll(enrollResponse: nil, errorResponse: error, callback: callback)
                return
            }
        }
    }
    
    public func askForTouchorFaceIdForAuthenticate(incomingData: AuthenticateRequest, callback: @escaping (Result<AuthenticateResponse>) -> Void) {
        // ask for touch id or face id
        let touchId = TouchID()
        touchId.checkIfTouchIdAvailable { (success, errorMessage, errorCode) in
            if success == true {
                touchId.checkTouchIDMatching(localizedReason: incomingData.localizedReason, callback: { (res_success, res_errorMessage, res_errorCode) in
                    if res_success == true {
                        self.authenticate(verificationType: VerificationTypes.TOUCH.rawValue, incomingData: incomingData, callback: callback)
                    }
                    else {
                        // send response to presenter
                        let error = WebAuthError.shared
                        error.errorMessage = res_errorMessage ?? WebAuthError.shared.errorMessage
                        error.errorCode = res_errorCode ?? WebAuthError.shared.errorCode
                        let errorResponse = error.error
                        errorResponse.error.code = res_errorCode ?? WebAuthError.shared.errorCode
                        
                        VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
                        
                        return
                    }
                })
            }
            else {
                // send response to presenter
                let error = WebAuthError.shared
                error.errorMessage = errorMessage ?? WebAuthError.shared.errorMessage
                error.errorCode = errorCode ?? WebAuthError.shared.errorCode
                let errorResponse = error.error
                errorResponse.error.code = errorCode ?? WebAuthError.shared.errorCode
                
                VerificationPresenter.shared.authenticate(authenticateResponse: nil, errorResponse: error, callback: callback)
                return
            }
        }
    }
    
    public func continueMFA(passwordlessRequest: PasswordlessRequest, properties: Dictionary<String, String>, callback: @escaping (Result<LoginResponse>) -> Void) {
        self.passwordlessContinue(incomingData: passwordlessRequest) {
            switch $0 {
            case .success(let passwordlessContinueSuccessResponse):
                
                AccessTokenService.shared.getAccessToken(code: passwordlessContinueSuccessResponse.data.code, properties: properties) {
                    switch $0 {
                    case .success(let tokenSuccessResponse):
                        let loginResp = LoginResponse()
                        loginResp.success = true
                        loginResp.status = 200
                        loginResp.data = tokenSuccessResponse
                        let encoder = JSONEncoder()
                        do {
                            let data = try encoder.encode(loginResp)
                            let loginResponseString = String(data: data, encoding: .utf8)
                            VerificationPresenter.shared.login(loginResponse: loginResponseString, errorResponse: nil, callback: callback)
                        }
                        catch(let err) {
                            let error_resp = WebAuthError.shared
                            error_resp.errorCode = 500
                            error_resp.errorMessage = "JSON parsing error: \(err.localizedDescription)"
                            error_resp.statusCode = 500
                            
                            VerificationPresenter.shared.login(loginResponse: nil, errorResponse: error_resp, callback: callback)
                        }
                        break
                    case .failure(let tokenFailureResponse):
                        VerificationPresenter.shared.login(loginResponse: nil, errorResponse: tokenFailureResponse, callback: callback)
                        break
                    }
                }
                break
            case .failure(let passwordlessContinueFailureResponse):
                VerificationPresenter.shared.login(loginResponse: nil, errorResponse: passwordlessContinueFailureResponse, callback: callback)
                break
            }
        }
    }
}
