//
//  File.swift
//  
//
//  Created by Widas Ganesh on 05/02/24.
//

import Foundation
import CommonCrypto

func HMAC(algorithm: Generator.Algorithm, key: Data, data: Data) -> Data {
    let (hashFunction, hashLength) = algorithm.hashInfo

    let macOut = UnsafeMutablePointer<UInt8>.allocate(capacity: hashLength)
    defer {
        macOut.deallocate()
    }

    #if swift(>=5.0)
    key.withUnsafeBytes { keyBytes in
        data.withUnsafeBytes { dataBytes in
            CCHmac(hashFunction, keyBytes.baseAddress, key.count, dataBytes.baseAddress, data.count, macOut)
        }
    }
    #else
    key.withUnsafeBytes { keyBytes in
        data.withUnsafeBytes { dataBytes in
            CCHmac(hashFunction, keyBytes, key.count, dataBytes, data.count, macOut)
        }
    }
    #endif

    return Data(bytes: macOut, count: hashLength)
}

private extension Generator.Algorithm {
    /// The corresponding CommonCrypto hash function and hash length.
    var hashInfo: (hashFunction: CCHmacAlgorithm, hashLength: Int) {
        switch self {
        case .sha1:
            return (CCHmacAlgorithm(kCCHmacAlgSHA1), Int(CC_SHA1_DIGEST_LENGTH))
        case .sha256:
            return (CCHmacAlgorithm(kCCHmacAlgSHA256), Int(CC_SHA256_DIGEST_LENGTH))
        case .sha512:
            return (CCHmacAlgorithm(kCCHmacAlgSHA512), Int(CC_SHA512_DIGEST_LENGTH))
        }
    }
}
