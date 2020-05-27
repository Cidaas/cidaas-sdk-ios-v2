//
//  Result.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(result: T)
    case failure(error: WebAuthError)
}
