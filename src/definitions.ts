export interface ZettlePlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
