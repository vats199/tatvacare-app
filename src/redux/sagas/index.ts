import {all} from 'redux-saga/effects';

import AuthSaga from './AuthSaga';

//Main Root Saga
const rootSaga = function* rootSaga() {
  yield all([AuthSaga()]);
};
export default rootSaga;
