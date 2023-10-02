/**
 * Bind query parameters to the endpoint
 * @param {String} url
 * @param {Object} queryParams
 * @returns
 */
export const bindQueryParams = (url: string, queryParams: object) => {
  const queryString = Object.entries(queryParams)
    .map(([key, val]) => `${key}=${val}`)
    .join('&');
  return `${url}?${queryString}`;
};