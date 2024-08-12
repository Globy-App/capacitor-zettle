import { WebPlugin } from '@capacitor/core';

import type { ZettlePaymentInfo, ZettlePlugin } from './definitions';

export class ZettleWeb extends WebPlugin implements ZettlePlugin {
  chargeAmount(): Promise<ZettlePaymentInfo> {
    throw this.unimplemented('Not implemented on web.');
  }
  async openSettings(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
  async initialize(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
  async logout(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
