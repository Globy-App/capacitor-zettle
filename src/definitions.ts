/// <reference types="@capacitor/cli" />

export interface ZettlePlugin {
  /**
   * Initializes the Zettle SDK. Make sure to call this method before calling any other methods.
   * Calling this method a second time has no effect.
   * @param developermode Enables developer mode
   */
  initialize({
    developermode,
  }: {
    developermode: boolean | undefined;
  }): Promise<void>;
  /**
   * Logs out the current user. The next time the user tries to make a payment they will have to login again.
   */
  logout(): Promise<void>;
  /**
   * Opens the Zettle settings screen. Allowing the user to login and use in app pairing to connect to a card reader.
   */
  openSettings(): Promise<void>;
  /**
   * Starts a payment. This will open the Zettle payment screen. It will start a payment for the specified amount.
   *
   * @param amount The amount to charge the customer
   * @param reference A reference for the payment. This can be used to identify the payment later. It will not be possible to retrieve the payment without this reference.
   * @returns A promise that resolves when the payment is completed. If the payment is cancelled or rejected it will resolve with a {success: false} object.
   */
  chargeAmount({
    amount,
    reference,
  }: {
    amount: number;
    reference: string;
  }): Promise<ZettlePaymentInfo | { success: false }>;
}

declare module '@capacitor/cli' {
  export interface PluginsConfig {
    Zettle?: {
      /**
       * The client ID for the Zettle SDK. This can be found in the Zettle developer portal.
       */
      clientID: string;
      /**
       * The scheme used by your application.
       * Must also be configured in the Zettle developer portal.
       * Will be used to redirect the user back to your app after logging in.
       */
      scheme: string;
      /**
       * The host that will be used to login to your app.
       * Must also be configured in the Zettle developer portal.
       * Will be used to redirect the user back to your app after logging in.
       */
      host: string;
    };
  }
}

export interface ZettlePaymentInfo {
  success: true;
  amount: number;
  gratuityAmount: number | undefined;
  referenceNumber: string;
  entryMode: string;
  obfuscatedPan: string;
  panHash: string;
  transactionId: string;
  cardBrand: string;
  authorizationCode: string;
  AID: string | undefined;
  TSI: string | undefined;
  TVR: string | undefined;
  applicationName: string | undefined;
  numberOfInstallments: number | undefined;
  installmentAmount: number | undefined;
}
