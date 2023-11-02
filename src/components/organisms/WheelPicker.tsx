import { lazy } from 'react';
import { Platform } from 'react-native';

export const WheelPicker = lazy(() => Platform.OS === 'ios'
  ? import('./WheelPicker.Ios')
  : import('./WheelPicker.android'))
