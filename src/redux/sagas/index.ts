import {all} from 'redux-saga/effects';

import AuthSaga from './AuthSaga';
import LocationSaga from './LocationSaga';

//Main Root Saga
const rootSaga = function* rootSaga() {
  yield all([AuthSaga()]);
  yield all([LocationSaga()]);
};
export default rootSaga;
