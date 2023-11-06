import WebEngage from 'react-native-webengage';
var webengage = new WebEngage();
/**
 * Bind query parameters to the endpoint
 * @param {String} event_name
 * @param {Object} params
 * @returns
 */
export const trackEvent = (
  event_name: string,
  params: Array<any> | Object | String,
) => {
  let payload = {...global.trackEventDefaultParams, ...params};
  try {
    webengage.track(event_name, payload);
    console.log('success');
  } catch (error) {
    console.log(error, 'event error');
  }
};
