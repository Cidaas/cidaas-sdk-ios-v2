import UIKit

@available(iOS 13.0, *)
extension UIApplication {
    public static var orientationLock = UIInterfaceOrientationMask.portrait

    public var topMostViewController: UIViewController? {
        let keyWindow = (connectedScenes.first as? UIWindowScene)?.windows.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    var keyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}
