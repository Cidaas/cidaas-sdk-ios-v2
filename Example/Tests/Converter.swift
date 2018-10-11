//
//  Converter.swift
//  Cidaas_Tests
//
//  Created by ganesh on 11/09/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class Converter {
    
    public static var shared = Converter()
    
    public func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
