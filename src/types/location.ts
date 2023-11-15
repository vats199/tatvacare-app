import {PermissionStatus} from 'react-native-permissions';

export type Location = {
  city?: string;
  state?: string;
  pincode?: number;
  latitude: number;
  longitude: number;
};

export type LocationState = {
  userLocation: Location | null;
  permissionGiven: boolean;
};
