import {combineReducers} from 'redux';

import authSlice from './authSlice';
import locationSlice from './locationSlice';

let appReducer = combineReducers({
  Auth: authSlice,
  Location: locationSlice,
});

// export all action
export * from './authSlice';
export * from './locationSlice';

export default appReducer;

// const rootReducer = (state, action) => {
//   // if (action.type === Logout.SUCCESS) {
//   //     state = {
//   //         Common: { ...INITIAL_COMMON, isConnected: state.Common.isConnected, },
//   //         Auth: INITIAL_AUTH,
//   //     };
//   // }
//   return appReducer(state, action);
// };
