//
//  SessionManager.swift
//  Cidaas
//
//  Created by Ganesh on 11/05/20.
//

import Foundation
import Alamofire

public class CidaasSessionManager {
    
    public static var shared : CidaasSessionManager = CidaasSessionManager()
    public var headers: HTTPHeaders
    public var sessionManager: Session
    
    public init() {
        // custom headers
        headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["User-Agent"] = CidaasUserAgentBuilder.shared.UAString()
        headers["lat"] = location.0
        headers["lon"] = location.1
        
        // configuration
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers

        // session manager
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func startSession(url: String, method: HTTPMethod, parameters: [String: Any],callback: @escaping (ApiResult<[String: Any]>) -> Void) {
        
        AF.request(url, method: method,  parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    callback(ApiResult.success(result: json))
                    return
                }
                callback(ApiResult.failure(status: HttpStatusCode.BAD_REQUEST.rawValue))
            case .failure(let error):
                if error._domain == NSURLErrorDomain {
                    // return failure
                    callback(ApiResult.failure(status: HttpStatusCode.GATEWAY_TIMEOUT.rawValue))
                    return
                }
                // return failure
                callback(ApiResult.failure(status: response.response?.statusCode ?? HttpStatusCode.BAD_REQUEST.rawValue))
            }
        }
    }
}
