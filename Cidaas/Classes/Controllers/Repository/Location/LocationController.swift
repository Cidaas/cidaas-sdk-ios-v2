//
//  LocationController.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation

public class LocationController {
    
    // shared instance
    public static var shared : LocationController = LocationController()
    
    // constructor
    public init() {
        
    }
    
    // get location list
    public func getLocationList(sub: String, properties: Dictionary<String, String>, callback: @escaping(Result<LocationListResponse>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // get access token from sub
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Access token failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tokenResponse):
                // log success
                let loggerMessage = "Access Token success : " + "Access Token  - " + String(describing: tokenResponse.data.access_token)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // call link account service
                LocationService.shared.getLocationList(accessToken: tokenResponse.data.access_token, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Location list service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tenantInfoResponse):
                        // log success
                        let loggerMessage = "Location List service success : " + "Count  - " + String(describing: tenantInfoResponse.data.count)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: tenantInfoResponse))
                        }
                    }
                }
                
            }
        }
    }
    
    // get beacon list
    public func getBeaconList(properties: Dictionary<String, String>, callback: @escaping(Result<BeaconListResponse>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // call get beacon list service
        LocationService.shared.getBeaconList(properties: properties) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Beacon list service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tenantInfoResponse):
                // log success
                let loggerMessage = "Beacon List service success : " + "Total count  - " + String(describing: tenantInfoResponse.data.count)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // return callback
                DispatchQueue.main.async {
                    callback(Result.success(result: tenantInfoResponse))
                }
            }
        }
    }
    
    // emit location
    public func emitLocation(locationEmission: LocationEmission, properties: Dictionary<String, String>, callback: @escaping(Result<EmissionResponse>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (locationEmission.deviceId == "" || locationEmission.locationIds.count == 0 || locationEmission.sessionId == "" || locationEmission.status == "" || locationEmission.sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "deviceId or locationIds or sessionId or status or sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // get access token from sub
        AccessTokenController.shared.getAccessToken(sub: locationEmission.sub) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Access token failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tokenResponse):
                // log success
                let loggerMessage = "Access Token success : " + "Access Token  - " + String(describing: tokenResponse.data.access_token)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // call link account service
                LocationService.shared.emitLocation(accessToken: tokenResponse.data.access_token, locationEmission: locationEmission, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Location Emission service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tenantInfoResponse):
                        // log success
                        let loggerMessage = "Location Emission service success : " + "Result  - " + String(describing: tenantInfoResponse.data.result)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: tenantInfoResponse))
                        }
                    }
                }
                
            }
        }
    }
    
    // emit beacon
    public func emitBeacon(beaconEmission: BeaconEmission, properties: Dictionary<String, String>, callback: @escaping(Result<EmissionResponse>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // validating fields
        if (beaconEmission.deviceId == "" || beaconEmission.beacon.uniqueId == "" || beaconEmission.beacon.major == "" || beaconEmission.beacon.minor == "" || beaconEmission.distance == 0.0 || beaconEmission.geo.coordinates.count == 0 || beaconEmission.sub == "") {
            let error = WebAuthError.shared.propertyMissingException()
            error.error = "deviceId or uniqueId or major or minor or distance or coordinates or sub must not be empty"
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // get access token from sub
        AccessTokenController.shared.getAccessToken(sub: beaconEmission.sub) {
            switch $0 {
            case .failure(let error):
                // log error
                let loggerMessage = "Access token failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                logw(loggerMessage, cname: "cidaas-sdk-error-log")
                
                // return failure callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            case .success(let tokenResponse):
                // log success
                let loggerMessage = "Access Token success : " + "Access Token  - " + String(describing: tokenResponse.data.access_token)
                logw(loggerMessage, cname: "cidaas-sdk-success-log")
                
                // call link account service
                LocationService.shared.emitBeacon(accessToken: tokenResponse.data.access_token, beaconEmission: beaconEmission, properties: properties) {
                    switch $0 {
                    case .failure(let error):
                        // log error
                        let loggerMessage = "Beacon Emission service failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
                        logw(loggerMessage, cname: "cidaas-sdk-error-log")
                        
                        // return failure callback
                        DispatchQueue.main.async {
                            callback(Result.failure(error: error))
                        }
                        return
                    case .success(let tenantInfoResponse):
                        // log success
                        let loggerMessage = "Beacon Emission service success : " + "Result  - " + String(describing: tenantInfoResponse.data.result)
                        logw(loggerMessage, cname: "cidaas-sdk-success-log")
                        
                        // return callback
                        DispatchQueue.main.async {
                            callback(Result.success(result: tenantInfoResponse))
                        }
                    }
                }
                
            }
        }
    }
}

