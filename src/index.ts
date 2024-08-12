import { registerPlugin } from '@capacitor/core';

import type { ZettlePlugin } from './definitions';

const Zettle = registerPlugin<ZettlePlugin>('Zettle', {
  web: () => import('./web').then(m => new m.ZettleWeb()),
});

export * from './definitions';
export { Zettle };
