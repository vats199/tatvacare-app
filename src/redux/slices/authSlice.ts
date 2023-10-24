import {createSlice, PayloadAction} from '@reduxjs/toolkit';
import {auth, common} from '../../types';

const usersInitialState: auth.UsersStateType = {
  user: {
    data: null,
    isLoading: false,
    errors: '',
  },
};

export const authSlice = createSlice({
  name: 'auth',
  initialState: usersInitialState,
  reducers: {
    /* This action will trigger our saga middleware
       and set the loader to true and reset error message.
    */
    loginRequestAction: (
      state: auth.UsersStateType,
      action: PayloadAction<any>,
    ) => {
      state.user.isLoading = true;
      state.user.errors = '';
    },
    loginSuccessAction: (
      state: auth.UsersStateType,
      action: PayloadAction<common.ResponseGenerator>,
    ) => {
      state.user.isLoading = false;
      state.user.data = action.payload.data;
    },
    loginErrorAction: (
      state: auth.UsersStateType,
      {payload: error}: PayloadAction<string>,
    ) => {
      state.user.isLoading = false;
      state.user.errors = error;
    },

    verifyLoginOtpRequest: (
      state: auth.UsersStateType,
      action: PayloadAction<any>,
    ) => {
      state.user.isLoading = true;
      state.user.errors = '';
    },
    verifyLoginOtpSuccess: (
      state: auth.UsersStateType,
      action: PayloadAction<any>,
    ) => {
      state.user.isLoading = false;
      state.user.data = action.payload.data;
    },
    verifyLoginOtpError: (
      state: auth.UsersStateType,
      {payload: error}: PayloadAction<string>,
    ) => {
      state.user.isLoading = false;
      state.user.errors = error;
    },
  },
});

/* loginSuccessAction and loginErrorAction will be used inside the saga
  middleware. Only loginAction will be used in a React component.
*/

export const {
  loginRequestAction,
  loginSuccessAction,
  loginErrorAction,
  verifyLoginOtpRequest,
  verifyLoginOtpSuccess,
  verifyLoginOtpError,
} = authSlice.actions;
export default authSlice.reducer;
