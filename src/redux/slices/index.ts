import {combineReducers} from 'redux';

// import { Logout } from '../Types';
// import AuthReducer, { INITIAL_STATE as INITIAL_AUTH } from './AuthReducer';
// import HomeReducer from './HomeReducer';
// import CommonReducer, { INITIAL_STATE as INITIAL_COMMON } from './CommonReducer';
// import DetailsReducer from './DetailsReducer';
// import ScanQRReducer from './ScanQRReducer';
// import PaymentReducer from './PaymentReducer';
import authSlice from './authSlice';

let appReducer = combineReducers({
  Auth: authSlice,
  // Home: HomeReducer,
});

// const rootReducer = (state, action) => {
//   // if (action.type === Logout.SUCCESS) {
//   //     state = {
//   //         Common: { ...INITIAL_COMMON, isConnected: state.Common.isConnected, },
//   //         Auth: INITIAL_AUTH,
//   //     };
//   // }
//   return appReducer(state, action);
// };

export default appReducer;

// export all action
export * from './authSlice';
