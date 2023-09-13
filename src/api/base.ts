import AsyncStorage from '@react-native-async-storage/async-storage';
import { Alert } from 'react-native';
import config from './config';
import Config from "react-native-config"
import CRYPTO from 'crypto-js';

const POST = 'post';
const GET = 'get';
const PUT = 'put';
const PATCH = 'patch';
const DELETE = 'delete';
const DEFAULT_ERROR = 'Something went wrong, Please try again later';

export const getEncryptedText = (data: any) => {
  var truncHexKey = CRYPTO.SHA256(Config.encKey || "").toString().substr(0, 32); // hex encode and truncate

  var key = CRYPTO.enc.Utf8.parse(truncHexKey);

  var iv = CRYPTO.enc.Utf8.parse(Config.encIV || "");

  var ciphertext = CRYPTO.AES.encrypt(JSON.stringify(data), key, {
    iv: iv,
    mode: CRYPTO.mode.CBC,
  });

  return ciphertext.toString();
}

export const getDecryptedData = (cipher: string) => {
  var truncHexKey = CRYPTO.SHA256(Config.encKey || "").toString().substr(0, 32); // hex encode and truncate

  var key = CRYPTO.enc.Utf8.parse(truncHexKey);

  var iv = CRYPTO.enc.Utf8.parse(Config.encIV || "");

  var decryptedData = CRYPTO.AES.decrypt(cipher, key, {
    iv: iv,
    mode: CRYPTO.mode.CBC,
  });

  return decryptedData.toString(CRYPTO.enc.Utf8);
}

const getToken = async () => {
  try {
    const token = await AsyncStorage.getItem('accessToken');
    if (token !== null) {
      // token previously stored
      return token;
    }
  } catch (e) {
    throw new Error('Token not found or could not be retrieved');
  }
};

const handleResponse = async (response: any) => {

  const contentType = response.headers.get('Content-Type');


  if (contentType && contentType.indexOf('application/json') !== -1) {
    const jsonRes = await response.json()
    const parsedResponse = await JSON.parse(getDecryptedData(jsonRes))

    if (parsedResponse?.code == 1) {
      return { data: parsedResponse?.data }
    } else {
      return {}
    }
  } else {
    return response.text();
  }
};

const request: any = async (
  route: string,
  {
    baseURL = config.BASE_URL,
    method = GET,
    payload = null,
    formData = null,
    headers = {} as any,
    json = true,
    priv = true,
  },
) => {
  let init = {
    method: method,
    headers: {
      ...headers,
      "api-key": Config.apiKey,
      'token': 'ILtFcw+xtbuy8IgsBCSyD6nSpgZd5AOz7T+g3N8Tef/INZi+dxwPJhnBc2kfdq2e2jxXFtZ/0Bb+YCGl+UEKiPPjaRppdP/afOSYuV55doQnLmSFSdj9cFhsQuvWHe0nvhKbB90Zbm7h6B7ZNZxQLsy1ASYvN6CovZ2uOCXQO28tCnDhC+ylOiff8g18kpsGgc+y2za+gGvZvqsEEHo2AVU8LA64WQ4pxp23aWjuBzWQQk0486HSWXTf1vbjdSA2pafpaV+IavZJb/vEdkro1IN60YqcWgvKxfit3OA+bvqKIpwX/t/AOclzPhorQeVnF4mAlD2gCcVFcSWyCtrT2kdtwRFEVYeXxKa8Us8nFAYO1+7llehG32swPJ0nC0Qafm9yEN06r4VJIPr7VrUAhDsIzhVemRZfiNa/NeLtueOWLYG8nM78RrhkKKTAgfQVTG+HLCPvYA9ii8nK4wsJZQdMKqht4NKNFihMaDza6yNTSffCyWRoUiguzJyUtLgFPAok6Bu/t4dJSolABGrK0Lup5XqTNx4+s0tMrg/DW3lvgvPdXnP52pl584KfkTg6rxiR5ybqcOOkmSwKlQJFKNX+GwudU4h0FjwnntMPJHAm+T+o8YXmAU3HfktmJlMrhTu1xtOXvyqA/TWBODV8IyIktMsMDCG0qnT1IwopXO9+lvsRu6wkBy9kquzq56mZySimBhWlyTLPDrGhriic3W2mh0lkfnL9CKGK8i/ncO+KA3mw3QFLa8b7DL3W39VEwVrF5qnl5eDqrIdsyg2JKDP08J3rQKdKHHGtKCnRPYwAzXslariXPNcxex43I+qPRJo4ZLefGErJvvkgm6wnWG83sf1GRCpfee+MrLMhASdHEgz5xCCY0EvbaI/mtEEdK2X5N1MKbD5B8yhTUCqvWw=='
    },
    body: ''
  };
  if (payload) {
    init = {
      ...init,
      headers: {
        ...init.headers,
      },
      body: getEncryptedText(payload)
    };
  }
  // if (formData) {
  //   init = {
  //     ...init,
  //     headers: {
  //       ...init.headers,
  //       'Content-Type': 'multipart/form-data',
  //     },
  //     body: formData,
  //   };
  // }
  // if (priv) {
  //   let token = await getToken();
  //   init.headers = {
  //     ...init.headers,
  //     Authorization: `Bearer ${token}`,
  //   };
  // }

  return fetch(`${baseURL}${route}`, init).then(async res => {
    if (!json) {
      return res;
    }

    res = await handleResponse(res);
    // if (res?.status === 'new token') {
    //   return request(route, {
    //     method,
    //     payload,
    //     formData,
    //     headers,
    //     json,
    //     priv,
    //   });
    // }

    return res;
  });
};

const handleError = (error: any, msg = DEFAULT_ERROR) => {
  let errMsg = msg;

  // exception string error
  if (typeof msg === 'string') {
    Alert.alert('Alert', msg);
    return {
      status: error?.status || 500,
      message: errMsg,
    };
  }

  switch (error?.status) {
    default:
      errMsg = DEFAULT_ERROR;
  }

  Alert.alert('Alert', errMsg);
  return {
    status: error?.status,
    message: errMsg,
  };
};

export default {
  POST,
  PUT,
  PATCH,
  GET,
  DELETE,
  request,
  handleResponse,
  handleError,
  getToken,
};
