import { WebPlugin } from '@capacitor/core';

import type { ZettlePlugin } from './definitions';

export class ZettleWeb extends WebPlugin implements ZettlePlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
