// --------------- LIBRARIES ---------------
import {put, call, takeEvery, all} from 'redux-saga/effects';
import {auth, common} from '../../types';
import * as actions from '../slices';
import api from '../../api';
import constants from '../../constants/constants';
// --------------- ASSETS ---------------

const loginSendOTPSaga = function* loginSendOTPSaga({
  payload: {resolve, reject, payload},
}: {
  payload: any;
}) {
  try {
    const response: common.ResponseGenerator = yield call(
      api.auth.loginSendOtp,
      payload,
    );
    if (response.code === '-1') {
      // throw new Error();
      // TODO: seesion expire
      throw new Error('Session Expire');
    } else if (response.code === '0') {
      throw new Error(response.message);
    }
    resolve(response);
    yield put(actions.loginSuccessAction(response));
  } catch (error) {
    reject(error);
    yield put(
      actions.loginErrorAction(
        error instanceof Error
          ? error?.message
          : constants.ERROR_MSG.SOMETHING_WENT_WRONG,
      ),
    );
  }
};

const loginVerifyOTPSaga = function* loginVerifyOTPSaga({
  payload: {resolve, reject, payload},
}: {
  payload: any;
}) {
  try {
    const response: common.ResponseGenerator = yield call(
      api.auth.verifyOTPLogin,
      payload,
    );
    if (response.code === '-1') {
      // throw new Error();
      // TODO: seesion expire
      throw new Error('Session Expire');
    } else if (response.code === '0') {
      throw new Error(response.message);
    }
    resolve(response);
    yield put(actions.verifyLoginOtpSuccess(response));
  } catch (error) {
    reject(error);
    yield put(
      actions.verifyLoginOtpError(
        error instanceof Error
          ? error?.message
          : constants.ERROR_MSG.SOMETHING_WENT_WRONG,
      ),
    );
  }
};

function* authSaga() {
  yield all([takeEvery(actions.loginRequestAction, loginSendOTPSaga)]);
  yield all([takeEvery(actions.verifyLoginOtpRequest, loginVerifyOTPSaga)]);
}

export default authSaga;
