import WebEngage from 'react-native-webengage';
var webengage = new WebEngage();
/**
 * Bind query parameters to the endpoint
 * @param {String} event_name
 * @param {Object} params
 * @returns
 */
export const trackEvent = (event_name: string, params: Array<any> | Object | String) => {
    try {
        webengage.track(event_name, params)
        console.log("success")
    } catch (error) {
        console.log(error, "event error")
    }
};