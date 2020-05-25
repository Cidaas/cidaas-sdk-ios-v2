//
//  ClientURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 14/05/20.
//

import Foundation

public class ClientURLHelper {
    
    public static var shared : ClientURLHelper = ClientURLHelper()
    
    public var clientInfoURL = "/public-srv/public"
    
    public func getClientInfoURL(requestId: String) -> String {
        return clientInfoURL + "/" + requestId
    }
}
