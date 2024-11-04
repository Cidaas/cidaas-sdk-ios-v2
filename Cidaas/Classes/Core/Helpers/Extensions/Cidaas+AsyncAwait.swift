import UIKit

@available(iOS 13.0, *)
public extension Cidaas {

    enum CidaasError: Error {
        case unknownLogoutError
    }

    func getUserInfo(with accessToken: String) async throws -> UserInfoEntity {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<UserInfoEntity, Error>) in
            Cidaas.shared.getUserInfo(accessToken: accessToken) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    func getClientInfo(requestId: String) async throws -> ClientInfoResponseDataEntity {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<ClientInfoResponseDataEntity, Error>) in
            CidaasNative.shared.getClientInfo(requestId: requestId) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result.data)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    func getRequestID() async throws -> String {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<String, Error>) in
            CidaasNative.shared.getRequestId() {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result.data.requestId)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    func getAccessToken(with refreshToken: String) async throws -> AccessTokenEntity {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<AccessTokenEntity, Error>) in
            Cidaas.shared.getAccessToken(refreshToken: refreshToken) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result.data)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    func getSocialLoginProviders() async throws -> [String] {
        let requestID = try await getRequestID()
        let clientInfo = try await getClientInfo(requestId: requestID)
        return clientInfo.login_providers
    }

    func logout(accessToken: String) async throws -> Void {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            CidaasNative.shared.logout(access_token: accessToken) {
                switch $0 {
                    // Note: The result is oddly defined as Boolean.
                    // So there still might be an error although the SDK returned success.
                case .success(let result):
                    if result {
                        continuation.resume()
                    } else {
                        continuation.resume(throwing: CidaasError.unknownLogoutError)
                    }
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    @discardableResult
    func loginWithBrowser(using parentViewController: UIViewController) async throws -> AccessTokenEntity {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<AccessTokenEntity, Error>) in
            Cidaas.shared.loginWithBrowser(delegate: parentViewController) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result.data)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    /// Provider is one of the entries defined in the provider list in `ClientInfoResponseDataEntity`. E.g. facebook or google.
    @discardableResult
    func loginWithSocial(using parentViewController: UIViewController,
                         provider: String,
                         requestID: String) async throws -> AccessTokenEntity {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<AccessTokenEntity, Error>) in
            Cidaas.shared.loginWithSocial(provider: provider,
                                          requestId: requestID,
                                          delegate: parentViewController) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result.data)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }

    @discardableResult
    func registerWithBrowser(using parentViewController: UIViewController) async throws -> AccessTokenEntity {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<AccessTokenEntity, Error>) in
            Cidaas.shared.registerWithBrowser(delegate: parentViewController) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result.data)
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                    break
                }
            }
        }
    }
}
