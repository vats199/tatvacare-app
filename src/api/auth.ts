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

};
export default Auth