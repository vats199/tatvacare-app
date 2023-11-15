import {createSlice, PayloadAction} from '@reduxjs/toolkit';
import {location} from '../../types';

const locationInitialState: location.LocationState = {
  permissionGiven: false,
  userLocation: null,
};

export const locationSlice = createSlice({
  name: 'location',
  initialState: locationInitialState,
  reducers: {
    locationPermissionRequest: (
      state: location.LocationState,
      action: PayloadAction<any>,
    ) => {},
    locationPermissionSuccess: (
      state: location.LocationState,
      action: PayloadAction<any>,
    ) => {},
  },
});

export const {} = locationSlice.actions;
export default locationSlice.reducer;
