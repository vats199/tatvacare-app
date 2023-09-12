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

const getEncryptedText = (data: any) => {
  var truncHexKey = CRYPTO.SHA256(Config.encKey || "").toString().substr(0, 32); // hex encode and truncate

  var key = CRYPTO.enc.Utf8.parse(truncHexKey);

  var iv = CRYPTO.enc.Utf8.parse(Config.encIV || "");

  var ciphertext = CRYPTO.AES.encrypt(JSON.stringify(data), key, {
    iv: iv,
    mode: CRYPTO.mode.CBC,
  });

  return ciphertext.toString();
}

const getDecryptedData = (cipher: string) => {
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

const handleResponse = (response: any) => {
  // const contentType = response.headers.get('Content-Type');
  // if (contentType && contentType.indexOf('text/plain') !== -1) {
  //   return handleResponseSuccess({ data: JSON.parse(getDecryptedData(response)), status: response?.status })
  // } else {
  //   return response.text();
  // }
  const contentType = response.headers.get('Content-Type');
  if (contentType && contentType.indexOf('application/json') !== -1) {
    return response.json()
      .then((data: any) => { console.log(data); }

        // handleResponseSuccess({ ...data, status: response?.status }),
      );
  } else {
    return response.text();
  }
};

const handleResponseSuccess = async (response: any) => {
  // if (response?.status === 200 && (response.msg === 'Token Expired' || response.msg === 'Invalid Token')) {

  //   const refreshToken = await AsyncStorage.getItem('refreshToken')
  //   const refreshData = {
  //     refreshToken
  //   }

  //   const res = await fetch(`${config.BASE_URL}/user/seller/refresh_token`, {
  //     method: POST,
  //     headers: {
  //       "Content-Type": "text/plain"
  //     },
  //     body: JSON.stringify(refreshData)
  //   })

  //   const response = await res.json()
  //   if (response && response?.status === 'success') {
  //     await AsyncStorage.setItem('accessToken', response.accessToken)
  //   } else {
  //     await AsyncStorage.clear()
  //     await AsyncStorage.setItem('isLogin', 'false')
  //     return;
  //   }

  //   return {
  //     status: 'new token',
  //     msg: 'New token generated',
  //   };
  // }

  // if (response?.status === 'error') {
  //   throw new Error(DEFAULT_ERROR);
  // }

  return response;
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
      Accept: 'text/plain',
      ...headers,
    },
    body: ''
  };
  if (payload) {
    init = {
      ...init,
      headers: {
        ...init.headers,
        'Content-Type': 'text/plain',
      },
      body: getEncryptedText(payload),
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
    if (res?.status === 'new token') {
      return request(route, {
        method,
        payload,
        formData,
        headers,
        json,
        priv,
      });
    }

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
