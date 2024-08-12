package app.globy.zettle

import android.app.Activity
import androidx.activity.result.ActivityResult
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.ActivityCallback
import com.getcapacitor.annotation.CapacitorPlugin
import com.zettle.sdk.ZettleSDK
import com.zettle.sdk.feature.cardreader.ui.CardReaderAction
import com.zettle.sdk.feature.cardreader.ui.payment.CardPaymentResult
import com.zettle.sdk.ui.ZettleResult
import com.zettle.sdk.ui.zettleResult
import kotlin.math.roundToLong


@CapacitorPlugin(name = "Zettle")
class ZettlePlugin : Plugin() {

    private var zettle: Zettle? = null;

    override fun load() {
        super.load()

        activity?.let { zettle = Zettle(it) }
    }

    @PluginMethod
    fun initialize(call: PluginCall?) {
        val devmode = call?.getBoolean("developermode", false) == true
        val clientId = config.getString("clientID")
        if (clientId == null) {
            call?.reject("Must set a clientID in the configuration.")
            return
        }
        val scheme = config.getString("scheme")
        if (scheme == null) {
            call?.reject("Must set a scheme in the configuration.")
            return
        }
        val host = config.getString("host")
        if (host == null) {
            call?.reject("Must set a host in the configuration.")
            return
        }

        zettle?.initialize(clientId, scheme, host, devmode)
    }

    @PluginMethod
    fun chargeAmount(call: PluginCall?) {
        val amount = call?.getDouble("amount")
        if (amount == null) {
            call?.reject("Must provide amount")
            return
        }

        val reference = call.getString("reference")

        val intent = zettle?.getPaymentIntent((amount * 100).roundToLong(), reference)
        startActivityForResult(call, intent, "finishPayment")
    }

    @ActivityCallback
    private fun finishPayment(call: PluginCall?, activityResult: ActivityResult) {
        if (call == null) {
            return
        }

        if (activityResult.resultCode != Activity.RESULT_OK) {
            return
        }

        when (val result = activityResult.data?.zettleResult()) {
            is ZettleResult.Completed<*> -> {
                val payment: CardPaymentResult.Completed = CardReaderAction.fromPaymentResult(result)
                val ret = JSObject()
                ret.put("success", true)
                ret.put("amount", payment.payload.amount)
                ret.put("gratuityAmount", payment.payload.gratuityAmount)
                ret.put("referenceNumber", payment.payload.referenceNumber)
                ret.put("entryMode", payment.payload.cardPaymentEntryMode)
                ret.put("obfuscatedPan", payment.payload.maskedPan)
                ret.put("transactionId", payment.payload.transactionId)
                ret.put("cardBrand", payment.payload.cardType)
                ret.put("authorizationCode", payment.payload.authorizationCode)
                ret.put("AID", payment.payload.applicationIdentifier)
                ret.put("TSI", payment.payload.tsi)
                ret.put("TVR", payment.payload.tvr)
                ret.put("applicationName", payment.payload.applicationName)
                ret.put("numberOfInstallments", payment.payload.nrOfInstallments)
                ret.put("installmentAmount", payment.payload.installmentAmount)
                call.resolve(ret)
            }
            else -> {
                // Errors are not documented well.
                // Our implementation choose to just collapse it into a { success: false } object for brevity
                // See https://github.com/iZettle/sdk-ios/issues/470
                val response = JSObject();
                response.put("success", false)
                call.resolve(response)
            }
        }
    }

    @PluginMethod
    fun logout(call: PluginCall?) {
        zettle?.logout()
    }

    @PluginMethod
    fun openSettings(call: PluginCall?) {
        zettle?.showCardReaderSettings(this.bridge.activity)
    }
}
