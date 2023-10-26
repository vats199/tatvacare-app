import {Platform} from 'react-native';
import WheelPickerIos from './WheelPicker.Ios';
import WheelPickerAndroid from './WheelPicker.android';

export const WheelPicker = Platform.select({
  ios: WheelPickerIos,
  android: WheelPickerAndroid,
});
