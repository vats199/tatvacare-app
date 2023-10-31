import AsyncStorage from '@react-native-async-storage/async-storage';
import {Alert, NativeModules} from 'react-native';
import config from './config';
import Config from 'react-native-config';
import CRYPTO from 'crypto-js';

const POST = 'post';
const GET = 'get';
const PUT = 'put';
const PATCH = 'patch';
const DELETE = 'delete';
const DEFAULT_ERROR = 'Something went wrong, Please try again later';
console.log(NativeModules.RNShare.token, 'RNShareRNShareRNShareRNShare==>');

// BASE_URL=https://api-uat.mytatva.in/api/v6
// encKey=9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6
// encIV=9Ddyaf6rfywpiTvT
// apiKey=

export const getEncryptedText = (data: any) => {
  var truncHexKey = CRYPTO.SHA256(
    Config.encKey || '9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6',
  )
    .toString()
    .substr(0, 32); // hex encode and truncate

  var key = CRYPTO.enc.Utf8.parse(truncHexKey);

  var iv = CRYPTO.enc.Utf8.parse(Config.encIV || '9Ddyaf6rfywpiTvT');

  var ciphertext = CRYPTO.AES.encrypt(JSON.stringify(data), key, {
    iv: iv,
    mode: CRYPTO.mode.CBC,
  });

  return ciphertext.toString();
};

export const getDecryptedData = (cipher: string) => {
  var truncHexKey = CRYPTO.SHA256(
    Config.encKey || '9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6',
  )
    .toString()
    .substr(0, 32); // hex encode and truncate

  var key = CRYPTO.enc.Utf8.parse(truncHexKey);

  var iv = CRYPTO.enc.Utf8.parse(Config.encIV || '9Ddyaf6rfywpiTvT');

  var decryptedData = CRYPTO.AES.decrypt(cipher, key, {
    iv: iv,
    mode: CRYPTO.mode.CBC,
  });

  return decryptedData.toString(CRYPTO.enc.Utf8);
};

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
    const jsonRes = await response.json();
    const parsedResponse = await JSON.parse(getDecryptedData(jsonRes));

    if (parsedResponse?.code == 1) {
      return {data: parsedResponse?.data};
    } else {
      return {};
    }
  } else {
    return response.text();
  }
};

const request: any = async (
  route: string,
  {
    // baseURL = config.BASE_URL,
    baseURL = 'https://api-uat.mytatva.in/api/v7',
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
      'api-key': 'lChjFRJce3bxmoS3TSQk5w==',
      token: NativeModules.RNShare.token,
    },
    body: '',
  };
  if (payload) {
    init = {
      ...init,
      headers: {
        ...init.headers,
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

  console.log(`${baseURL}${route}`);

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
