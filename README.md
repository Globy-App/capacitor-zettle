# @globy-app/zettle

Adds capabilities to use Zettle card readers and process payments with them.

## Install

```bash
npm install @globy-app/zettle
npx cap sync
```

### Setup the SDK

#### IOS

Install the ZettleSDK pod by following the official [Zettle guide](https://developer.zettle.com/docs/ios-sdk/installation-and-configuration).

Also make sure the you follow the steps on configuring permissions and plist.

#### Android

To install the Zettle SDK for android in the project, one must provide a github token so the SDK can be downloaded. How you do that is up to you. As this is a secret token, a secret manager is recommended to prevent the need of comitting a Github token to your repository.

For this to work, you need to paste the following snippet in the `build.gradle` file (located at `android/app/build.gradle`, so in your capacitor android app source files):

```
repositories {
    ...
    maven {
        url = uri("https://maven.pkg.github.com/iZettle/sdk-android")
        credentials(HttpHeaderCredentials) {
            name "Authorization"
            value "Bearer xxx" // More about auth tokens https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
        }
        authentication {
            header(HttpHeaderAuthentication)
        }
    }
    ...
}

allprojects {
    repositories {
        ...
        maven {
            url = uri("https://maven.pkg.github.com/iZettle/sdk-android")
            credentials(HttpHeaderCredentials) {
                name "Authorization"
                value "Bearer xxx" // More about auth tokens https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
            }
            authentication {
                header(HttpHeaderAuthentication)
            }
        }
        ...
    }
}
```

You also need to add the OAuthActivity to your app's manifest. See the Zettle SDK documentation for the exact steps. Make sure the redirect url is correct and matches your configuration.

### Configuring the plugin

Zettle needs to know a few things about your application to work properly. If you have received a Zettle developer account, you can also add a client. This should provide you with all the credentials for a SDK application.

In your `capacitor` capacitor make sure to add the following configuration:

```json
{
  "plugins": {
    "Zettle": {
      "clientID": "your-client-id",
      "scheme": "your-scheme",
      "host": "your-host"
    }
  }
}
```

## API

<docgen-index>

* [`initialize(...)`](#initialize)
* [`logout()`](#logout)
* [`openSettings()`](#opensettings)
* [`chargeAmount(...)`](#chargeamount)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize(...)

```typescript
initialize({ developermode, }: { developermode: boolean | undefined; }) => Promise<void>
```

Initializes the Zettle SDK. Make sure to call this method before calling any other methods.
Calling this method a second time has no effect.

| Param     | Type                                     | Description            |
| --------- | ---------------------------------------- | ---------------------- |
| **`__0`** | <code>{ developermode: boolean; }</code> | Enables developer mode |

--------------------


### logout()

```typescript
logout() => Promise<void>
```

Logs out the current user. The next time the user tries to make a payment they will have to login again.

--------------------


### openSettings()

```typescript
openSettings() => Promise<void>
```

Opens the Zettle settings screen. Allowing the user to login and use in app pairing to connect to a card reader.

--------------------


### chargeAmount(...)

```typescript
chargeAmount({ amount, reference, }: { amount: number; reference: string; }) => Promise<ZettlePaymentInfo | { success: false; }>
```

Starts a payment. This will open the Zettle payment screen. It will start a payment for the specified amount.

| Param     | Type                                                | Description                       |
| --------- | --------------------------------------------------- | --------------------------------- |
| **`__0`** | <code>{ amount: number; reference: string; }</code> | The amount to charge the customer |

**Returns:** <code>Promise&lt;<a href="#zettlepaymentinfo">ZettlePaymentInfo</a> | { success: false; }&gt;</code>

--------------------


### Interfaces


#### ZettlePaymentInfo

| Prop                       | Type                |
| -------------------------- | ------------------- |
| **`success`**              | <code>true</code>   |
| **`amount`**               | <code>number</code> |
| **`gratuityAmount`**       | <code>number</code> |
| **`referenceNumber`**      | <code>string</code> |
| **`entryMode`**            | <code>string</code> |
| **`obfuscatedPan`**        | <code>string</code> |
| **`panHash`**              | <code>string</code> |
| **`transactionId`**        | <code>string</code> |
| **`cardBrand`**            | <code>string</code> |
| **`authorizationCode`**    | <code>string</code> |
| **`AID`**                  | <code>string</code> |
| **`TSI`**                  | <code>string</code> |
| **`TVR`**                  | <code>string</code> |
| **`applicationName`**      | <code>string</code> |
| **`numberOfInstallments`** | <code>number</code> |
| **`installmentAmount`**    | <code>number</code> |

</docgen-api>
