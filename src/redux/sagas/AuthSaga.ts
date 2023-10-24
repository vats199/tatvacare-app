// --------------- LIBRARIES ---------------
import {put, call, takeEvery, all} from 'redux-saga/effects';
import {sagaActions} from './SagaAction';
import {auth, common} from '../../types';
import * as actions from '../slices';
import api from '../../api';
import constants from '../../constants/constants';
// --------------- ASSETS ---------------

// const loginSendOTPSaga = function* loginSaga({ params }) {
//   try {
//     // const response = yield call(API.Register, params);
//     // if (response?.status != 1) {
//     //   throw new Error(response?.msg ?? '');
//     // }
//     // yield put(getUserSuccessAction());
//     // let result <> = yield call(() =>
//     //   callAPI({url: 'https://5ce2c23be3ced20014d35e3d.mockapi.io/api/todos'}),
//     // );
//     // yield put(getUserSuccessAction([]));
//     // const response = yield call(API.Register, params);
//     //     if (response?.status != 1) {
//     //         throw new Error(response?.msg ?? '');
//     //     }
//   } catch (e) {
//     yield put(getUserErrorAction('something went wrong'));
//   }
// };

const loginSendOTPSaga = function* loginSendOTPSaga({
  payload: {resolve, reject, ...payload},
}: {
  payload: any;
}) {
  try {
    const response: common.ResponseGenerator = yield call(
      api.auth.loginSendOtp,
      payload,
    );
    if (response.code === -1) {
      // throw new Error();
      // TODO: seesion expire
    } else if (response.code === 0) {
      throw new Error(constants.ERROR_MSG.INVALID_REQUEST);
    }
    resolve(response);
    yield put(actions.getUserSuccessAction(response));
  } catch (error) {
    reject(error);
    yield put(
      actions.getUserErrorAction(
        error instanceof Error
          ? error?.message
          : constants.ERROR_MSG.SOMETHING_WENT_WRONG,
      ),
    );
  }
};

function* authSaga() {
  yield all([takeEvery(actions.getUserRequestAction, loginSendOTPSaga)]);
}

export default authSaga;
