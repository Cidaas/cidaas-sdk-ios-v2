//
//  LocationService.swift
//  Cidaas
//
//  Created by ganesh on 07/10/18.
//

import Foundation
import Alamofire

public class LocationService {
    
    // shared instance
    public static var shared : LocationService = LocationService()
    let location = DBHelper.shared.getLocation()
    
    // constructor
    public init() {
        
    }
    
    // get location details list
    public func getLocationList(accessToken: String, properties : Dictionary<String, String>, callback: @escaping (Result<LocationListResponse>) -> Void) {
        
//        // local variables
//        var headers : HTTPHeaders
//        var urlString : String
//        var baseURL : String
//
//        // get device information
//        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
//
//        // construct headers
//        headers = [
//            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
//            "lat": location.0,
//            "lon": location.1,
//            "deviceId" : deviceInfoEntity.deviceId,
//            "deviceMake" : deviceInfoEntity.deviceMake,
//            "deviceModel" : deviceInfoEntity.deviceModel,
//            "deviceVersion" : deviceInfoEntity.deviceVersion,
//            "access_token": accessToken
//        ]
//
//        // assign base url
//        baseURL = (properties["DomainURL"]) ?? ""
//
//        if (baseURL == "") {
//            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
//            return
//        }
//
//        // construct url
//        urlString = baseURL + URLHelper.shared.getLocationListURL()
//
//        Alamofire.request(urlString, method: .post, parameters: nil, headers: headers).validate().responseString { response in
//            switch response.result {
//            case .failure(let error):
//                if error._domain == NSURLErrorDomain {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
//                    return
//                }
//                if (response.data != nil) {
//                    let jsonString = String(decoding: response.data!, as: UTF8.self)
//                    let decoder = JSONDecoder()
//                    do {
//                        let data = jsonString.data(using: .utf8)!
//                        // decode the json data to object
//                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
//
//                        // return failure
//                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_LIST_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
//                    }
//                    catch(let error) {
//                        // return failure
//                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_LIST_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                    }
//                }
//                else {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                }
//                return
//            case .success:
//                if response.response?.statusCode == 200 {
//                    if let jsonString = response.result.value {
//                        let decoder = JSONDecoder()
//                        do {
//                            let data = jsonString.data(using: .utf8)!
//                            let locationSearch = try decoder.decode(LocationListResponse.self, from: data)
//                            // return success
//                            callback(Result.success(result: locationSearch))
//                        }
//                        catch {
//                            // return failure
//                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
//                            return
//                        }
//                    }
//                    else {
//                        // return failure
//                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                    }
//                }
//                else {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                    break
//                }
//            }
//        }
    }
    
    // location emission
    public func emitLocation(accessToken: String, locationEmission: LocationEmission, properties : Dictionary<String, String>, callback: @escaping (Result<EmissionResponse>) -> Void) {
        
//        // local variables
//        var headers : HTTPHeaders
//        var urlString : String
//        var baseURL : String
//
//        // get device information
//        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
//
//        // construct headers
//        headers = [
//            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
//            "lat": location.0,
//            "lon": location.1,
//            "deviceId" : deviceInfoEntity.deviceId,
//            "deviceMake" : deviceInfoEntity.deviceMake,
//            "deviceModel" : deviceInfoEntity.deviceModel,
//            "deviceVersion" : deviceInfoEntity.deviceVersion,
//            "access_token": accessToken
//        ]
//
//        // assign base url
//        baseURL = (properties["DomainURL"]) ?? ""
//
//        if (baseURL == "") {
//            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
//            return
//        }
//
//        // construct body params
//        var bodyParams = Dictionary<String, Any>()
//
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(locationEmission)
//            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
//        }
//        catch(_) {
//            callback(Result.failure(error: WebAuthError.shared.conversionException()))
//            return
//        }
//
//        // construct url
//        urlString = baseURL + URLHelper.shared.getLocationEmissionURL()
//
//        Alamofire.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default,
//                          headers: headers).validate().responseString { response in
//                            switch response.result {
//                            case .failure(let error):
//                                if error._domain == NSURLErrorDomain {
//                                    // return failure
//                                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
//                                    return
//                                }
//                                if (response.data != nil) {
//                                    let jsonString = String(decoding: response.data!, as: UTF8.self)
//                                    let decoder = JSONDecoder()
//                                    do {
//                                        let data = jsonString.data(using: .utf8)!
//                                        // decode the json data to object
//                                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
//
//                                        // return failure
//                                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
//                                    }
//                                    catch(let error) {
//                                        // return failure
//                                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                                    }
//                                }
//                                else {
//                                    // return failure
//                                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_EMISSION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                                }
//                                return
//                            case .success:
//                                if response.response?.statusCode == 200 {
//                                    if let jsonString = response.result.value {
//                                        let decoder = JSONDecoder()
//                                        do {
//                                            let data = jsonString.data(using: .utf8)!
//                                            let locationSearch = try decoder.decode(EmissionResponse.self, from: data)
//                                            // return success
//                                            callback(Result.success(result: locationSearch))
//                                        }
//                                        catch {
//                                            // return failure
//                                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
//                                            return
//                                        }
//                                    }
//                                    else {
//                                        // return failure
//                                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_EMISSION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                                    }
//                                }
//                                else {
//                                    // return failure
//                                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_EMISSION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                                    break
//                                }
//                            }
//        }
    }
    
    // get beacon details list
    public func getBeaconList(properties : Dictionary<String, String>, callback: @escaping (Result<BeaconListResponse>) -> Void) {
        
//        // local variables
//        var headers : HTTPHeaders
//        var urlString : String
//        var baseURL : String
//
//        // get device information
//        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
//
//        // construct headers
//        headers = [
//            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
//            "lat": location.0,
//            "lon": location.1,
//            "deviceId" : deviceInfoEntity.deviceId,
//            "deviceMake" : deviceInfoEntity.deviceMake,
//            "deviceModel" : deviceInfoEntity.deviceModel,
//            "deviceVersion" : deviceInfoEntity.deviceVersion
//        ]
//
//        // assign base url
//        baseURL = (properties["DomainURL"]) ?? ""
//
//        if (baseURL == "") {
//            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
//            return
//        }
//
//        // construct url
//        urlString = baseURL + URLHelper.shared.getBeaconListURL()
//
//        Alamofire.request(urlString, method: .get, parameters: nil, headers: headers).validate().responseString { response in
//            switch response.result {
//            case .failure(let error):
//                if error._domain == NSURLErrorDomain {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
//                    return
//                }
//                if (response.data != nil) {
//                    let jsonString = String(decoding: response.data!, as: UTF8.self)
//                    let decoder = JSONDecoder()
//                    do {
//                        let data = jsonString.data(using: .utf8)!
//                        // decode the json data to object
//                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
//
//                        // return failure
//                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.BEACON_LIST_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
//                    }
//                    catch(let error) {
//                        // return failure
//                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.BEACON_LIST_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                    }
//                }
//                else {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.BEACON_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.BEACON_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                }
//                return
//            case .success:
//                if response.response?.statusCode == 200 {
//                    if let jsonString = response.result.value {
//                        let decoder = JSONDecoder()
//                        do {
//                            let data = jsonString.data(using: .utf8)!
//                            let locationSearch = try decoder.decode(BeaconListResponse.self, from: data)
//                            // return success
//                            callback(Result.success(result: locationSearch))
//                        }
//                        catch {
//                            // return failure
//                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
//                            return
//                        }
//                    }
//                    else {
//                        // return failure
//                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.BEACON_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.BEACON_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                    }
//                }
//                else {
//                    // return failure
//                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.BEACON_LIST_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.BEACON_LIST_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                    break
//                }
//            }
//        }
    }
    
    // beacon emission
    public func emitBeacon(accessToken: String, beaconEmission: BeaconEmission, properties : Dictionary<String, String>, callback: @escaping (Result<EmissionResponse>) -> Void) {
        
//        // local variables
//        var headers : HTTPHeaders
//        var urlString : String
//        var baseURL : String
//
//        // get device information
//        let deviceInfoEntity = DBHelper.shared.getDeviceInfo()
//
//        // construct headers
//        headers = [
//            "User-Agent": CidaasUserAgentBuilder.shared.UAString(),
//            "lat": location.0,
//            "lon": location.1,
//            "deviceId" : deviceInfoEntity.deviceId,
//            "deviceMake" : deviceInfoEntity.deviceMake,
//            "deviceModel" : deviceInfoEntity.deviceModel,
//            "deviceVersion" : deviceInfoEntity.deviceVersion,
//            "access_token": accessToken
//        ]
//
//        // assign base url
//        baseURL = (properties["DomainURL"]) ?? ""
//
//        if (baseURL == "") {
//            callback(Result.failure(error: WebAuthError.shared.propertyMissingException()))
//            return
//        }
//
//        // construct body params
//        var bodyParams = Dictionary<String, Any>()
//
//        do {
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(beaconEmission)
//            bodyParams = try! JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> ?? Dictionary<String, Any>()
//        }
//        catch(_) {
//            callback(Result.failure(error: WebAuthError.shared.conversionException()))
//            return
//        }
//
//        // construct url
//        urlString = baseURL + URLHelper.shared.getBeaconEmissionURL()
//
//        Alamofire.request(urlString, method: .post, parameters: bodyParams, encoding: JSONEncoding.default,
//                          headers: headers).validate().responseString { response in
//                            switch response.result {
//                            case .failure(let error):
//                                if error._domain == NSURLErrorDomain {
//                                    // return failure
//                                    callback(Result.failure(error: WebAuthError.shared.netWorkTimeoutException()))
//                                    return
//                                }
//                                if (response.data != nil) {
//                                    let jsonString = String(decoding: response.data!, as: UTF8.self)
//                                    let decoder = JSONDecoder()
//                                    do {
//                                        let data = jsonString.data(using: .utf8)!
//                                        // decode the json data to object
//                                        let errorResponseEntity = try decoder.decode(ErrorResponseEntity.self, from: data)
//
//                                        // return failure
//                                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: errorResponseEntity.error.error, statusCode: Int(errorResponseEntity.status), error: errorResponseEntity)))
//                                    }
//                                    catch(let error) {
//                                        // return failure
//                                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: error.localizedDescription, statusCode: 400)))
//                                    }
//                                }
//                                else {
//                                    // return failure
//                                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_EMISSION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                                }
//                                return
//                            case .success:
//                                if response.response?.statusCode == 200 {
//                                    if let jsonString = response.result.value {
//                                        let decoder = JSONDecoder()
//                                        do {
//                                            let data = jsonString.data(using: .utf8)!
//                                            let locationSearch = try decoder.decode(EmissionResponse.self, from: data)
//                                            // return success
//                                            callback(Result.success(result: locationSearch))
//                                        }
//                                        catch {
//                                            // return failure
//                                            callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.ERROR_JSON_PARSING.rawValue, errorMessage: StringsHelper.shared.ERROR_JSON_PARSING, statusCode: HttpStatusCode.DEFAULT.rawValue)))
//                                            return
//                                        }
//                                    }
//                                    else {
//                                        // return failure
//                                        callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_EMISSION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                                    }
//                                }
//                                else {
//                                    // return failure
//                                    callback(Result.failure(error: WebAuthError.shared.serviceFailureException(errorCode: WebAuthErrorCode.LOCATION_EMISSION_SERVICE_FAILURE.rawValue, errorMessage: StringsHelper.shared.LOCATION_EMISSION_SERVICE_FAILURE, statusCode: response.response?.statusCode ?? 400)))
//                                    break
//                                }
//                            }
//        }
    }
}
