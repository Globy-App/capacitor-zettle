import Foundation
import Capacitor

import iZettleSDK

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ZettlePlugin)
public class ZettlePlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ZettlePlugin"
    public let jsName = "Zettle"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "initialize", returnType: CAPPluginReturnNone),
        CAPPluginMethod(name: "logout", returnType: CAPPluginReturnNone),
        CAPPluginMethod(name: "openSettings", returnType: CAPPluginReturnNone),
        CAPPluginMethod(name: "chargeAmount", returnType: CAPPluginReturnPromise)
    ]

    private let impl = Zettle()

    private var callbackId: String?

    @objc func initialize(_ call: CAPPluginCall) {
        let developerMode = call.getBool("developerMode")

        guard let clientID = getConfig().getString("clientID") else { call.reject("Must set a clientID in the configuration."); return }
        guard let host = getConfig().getString("host")
        else { call.reject("Must set a scheme in the configuration."); return }
        guard let scheme = getConfig().getString("scheme")
        else { call.reject("Must set a host in the configuration."); return}

        guard let callbackURL = URL(string: scheme + "://" + host) else { return }

        impl.initialize(clientID: clientID, callbackURL: callbackURL, enableDeveloperMode: developerMode ?? false)
    }

    @objc func logout(_ call: CAPPluginCall) {
        impl.logout()
    }

    @objc func openSettings(_ call: CAPPluginCall) {
        guard let bridge = self.bridge else { return }
        guard let viewController = bridge.viewController else { return }

        impl.presentSettings(viewController: viewController)
    }

    @objc func chargeAmount(_ call: CAPPluginCall) {
        guard let bridge = self.bridge else { return }
        guard callbackId == nil else { call.reject("A payment was already started"); return }
        bridge.saveCall(call)
        callbackId = call.callbackId

        guard let amount = call.getDouble("amount") else { call.reject("Must provide an amount"); return }

        let reference = call.getString("reference")

        guard let bridge = self.bridge else { return }
        guard let viewController = bridge.viewController else { return }

        impl.chargeAmount(
            viewController: viewController,
            amount: NSDecimalNumber(decimal: Decimal(amount)),
            reference: reference,
            callback: paymentCompletion(paymentInfo:error:)
        )

    }

    private func paymentCompletion(paymentInfo: iZettleSDKPaymentInfo?, error: (any Error)?) {
        guard let call = self.bridge?.savedCall(withID: callbackId ?? "") else { return }

        if let nsError = error as? NSError {
            // Errors are not documented well.
            // Our implementation choose to just collapse it into a { success: false } object for brevity
            // See https://github.com/iZettle/sdk-ios/issues/470
            call.resolve(["success": false])
        } else {
            // Payment was unsuccesfull
            guard let payment = paymentInfo else {
                call.resolve(["success": false])
                return }

            call.resolve([
                "success": true,
                "amount": payment.amount,
                "gratuityAmount": payment.gratuityAmount as Any,
                "referenceNumber": payment.referenceNumber,
                "entryMode": payment.entryMode,
                "obfuscatedPan": payment.obfuscatedPan,
                "panHash": payment.panHash,
                "transactionId": payment.transactionId,
                "cardBrand": payment.cardBrand,
                "authorizationCode": payment.authorizationCode,
                "AID": payment.aid as Any,
                "TSI": payment.tsi as Any,
                "TVR": payment.tvr as Any,
                "applicationName": payment.applicationName as Any,
                "numberOfInstallments": payment.numberOfInstallments as Any,
                "installmentAmount": payment.installmentAmount as Any
            ])
        }

        callbackId = nil
    }
}
