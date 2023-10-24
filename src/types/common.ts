export type ResponseGenerator = {
  config?: any;
  data?: any;
  headers?: any;
  request?: any;
  status: number;
  statusText?: string;
  code: 0 | 1 | 2 | 3 | -1;
};
