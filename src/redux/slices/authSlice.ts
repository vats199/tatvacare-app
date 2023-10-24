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
    getUserRequestAction: (
      state: auth.UsersStateType,
      action: PayloadAction<any>,
    ) => {
      state.user.isLoading = true;
      state.user.errors = '';
    },
    getUserSuccessAction: (
      state: auth.UsersStateType,
      action: PayloadAction<common.ResponseGenerator>,
    ) => {
      state.user.isLoading = false;
      state.user.data = action.payload.data;
    },
    getUserErrorAction: (
      state: auth.UsersStateType,
      {payload: error}: PayloadAction<string>,
    ) => {
      state.user.isLoading = false;
      state.user.errors = error;
    },
  },
});

/* getUserSuccessAction and getUserErrorAction will be used inside the saga
  middleware. Only getUserAction will be used in a React component.
*/

export const {getUserRequestAction, getUserSuccessAction, getUserErrorAction} =
  authSlice.actions;
export default authSlice.reducer;
