import Foundation

import iZettleSDK

@objc public class Zettle: NSObject {

    public var initialized = false

    public func initialize(clientID: String, callbackURL: URL, enableDeveloperMode: Bool) {
        DispatchQueue.main.async {
            do {
                guard self.initialized == false else {
                    return
                }

                self.initialized = true

                let authenticationProvider = try iZettleSDKAuthorization(
                    clientID: clientID,
                    callbackURL: callbackURL
                )
                iZettleSDK.shared().start(with: authenticationProvider, enableDeveloperMode: enableDeveloperMode)
            } catch {
                let nsError = error as NSError
                print("Recieved a Zettle error during initialization!")
                print(nsError.localizedDescription)
                print(nsError.code)
            }
        }
    }

    public func logout() {
        DispatchQueue.main.async {
            iZettleSDK.shared().logout()
        }
    }

    public func presentSettings(viewController: UIViewController) {
        DispatchQueue.main.async {
            iZettleSDK.shared().presentSettings(from: viewController)
        }
    }

    public func chargeAmount(
        viewController: UIViewController,
        amount: NSDecimalNumber,
        reference: String?,
        callback: @escaping iZettleSDKOperationCompletion
    ) {
        DispatchQueue.main.async {
            iZettleSDK.shared().charge(
                amount: amount,
                tippingStyle: IZSDKTippingStyle.none,
                reference: reference,
                presentFrom: viewController,
                completion: callback
            )
        }
    }
}
