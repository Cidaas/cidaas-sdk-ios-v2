//
//  URLExtensions.swift
//  Cidaas
//
//  Created by ganesh on 04/12/18.
//

import Foundation

public extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
