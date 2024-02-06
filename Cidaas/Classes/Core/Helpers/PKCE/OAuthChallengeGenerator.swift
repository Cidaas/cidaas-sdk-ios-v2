import Foundation
import CommonCrypto

let kVerifierSize: Int = 32

class OAuthChallengeGenerator {
    let verifier: String
    let method: String

    convenience init() {
        var data = Data(count: kVerifierSize)
        let _ = data.withUnsafeMutableBytes { mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, kVerifierSize, mutableBytes.baseAddress!)
        }
        self.init(verifier: data)
    }

    init(verifier: Data) {
        let base64String = verifier.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "="))

        self.verifier = base64String
        self.method = "S256"
    }

    func challenge() -> String {
        var ctx = CC_SHA256_CTX()
        var hashBytes = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        guard let valueData = self.verifier.data(using: .utf8) else {
            return ""
        }

        valueData.withUnsafeBytes { bytes in
            _ = CC_SHA256_Init(&ctx)
            _ = CC_SHA256_Update(&ctx, bytes.baseAddress, CC_LONG(valueData.count))
            _ = CC_SHA256_Final(&hashBytes, &ctx)
        }

        let hashData = Data(hashBytes)
        let hashString = hashData.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .trimmingCharacters(in: CharacterSet(charactersIn: "="))

        return hashString
    }
}
