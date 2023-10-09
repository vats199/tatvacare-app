import { bindQueryParams } from '../helpers/Tools';
import Ajax from './base';

const Auth = {
    loginSendOtp: (payload: object) => {
        const route = '/patient/login_send_otp';
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true,
            payload
        });
    },
    sendSignUpOtp: (payload: object) => {
        const route = '/patient/send_otp_signup';
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true,
            payload
        });
    },
    verifyOTPSignUp: (payload: object) => {
        const route = '/patient/verify_otp_signup';
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true,
            payload
        });
    },
    verifyOTPLogin: (payload: object) => {
        const route = '/patient/login_verify_otp';
        return Ajax.request(route, {
            method: Ajax.POST,
            priv: true,
            payload
        });
    }
    // 
    //   getPatientCarePlan: (query: object) => {
    //     const route = bindQueryParams('/patient/get_patient_details', query);
    //     return Ajax.request(route, {
    //       method: Ajax.POST,
    //       priv: true,
    //     });
    //   },

    //   getHCDevicePlan: () => {
    //     const route = '/patient_plans/hc_device_plan';
    //     return Ajax.request(route, {
    //       method: Ajax.POST,
    //       priv: true,
    //     });
    //   },
    //   getGoalsAndReadings: (headers: object) => {
    //     const route = '/goal_readings/daily_summary';
    //     return Ajax.request(route, {
    //       method: Ajax.POST,
    //       priv: true,
    //       headers,
    //     });
    //   },

    //   addBookmark: (query: object, payload: object) => {
    //     const route = bindQueryParams('/content/update_bookmarks', query);
    //     return Ajax.request(route, {
    //       method: Ajax.POST,
    //       priv: true,
    //       payload,
    //     });
    //   },

};
export default Auth