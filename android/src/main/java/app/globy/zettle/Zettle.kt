package app.globy.zettle

import android.app.Activity
import android.content.Intent
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ProcessLifecycleOwner
import com.zettle.sdk.ZettleSDK
import com.zettle.sdk.ZettleSDKLifecycle
import com.zettle.sdk.config
import com.zettle.sdk.feature.cardreader.payment.TippingStyle
import com.zettle.sdk.feature.cardreader.payment.TransactionReference
import com.zettle.sdk.feature.cardreader.ui.CardReaderAction
import com.zettle.sdk.feature.cardreader.ui.CardReaderFeature
import com.zettle.sdk.features.charge
import com.zettle.sdk.features.show
import java.util.UUID

class Zettle(private val activity: AppCompatActivity) {
    fun initialize(clientId: String, scheme: String, host: String, devMode: Boolean) {
        val redirectUrl = "$scheme://$host"

        val config = config(activity.applicationContext) {
            isDevMode = devMode
            auth {
                this.clientId = clientId
                this.redirectUrl = redirectUrl // For Managed Authentication
            }
            addFeature(CardReaderFeature.Configuration)
        }
        ZettleSDK.configure(config)

        // Attach the SDKs lifecycle observer to your lifecycle. It allows the SDK to
        // manage bluetooth connection in a more graceful way
        Handler(Looper.getMainLooper()).post {
            ProcessLifecycleOwner.get().lifecycle.addObserver(ZettleSDKLifecycle())
        }
    }

    fun showCardReaderSettings(activity: Activity) {
        val intent = CardReaderAction.Settings.show(activity)
        activity.startActivity(intent)
    }

    fun logout() {
        ZettleSDK.instance?.logout()
    }

    fun getPaymentIntent(amount: Long, reference: String?): Intent {
        val transactionRef = TransactionReference.Builder(reference ?: UUID.randomUUID().toString())
            .build()

        val intent: Intent = CardReaderAction.Payment(
            amount = amount,
            reference = transactionRef,
            tippingStyle = TippingStyle.None,
            enableInstallments = false
        ).charge(activity)

        return intent
    }
}