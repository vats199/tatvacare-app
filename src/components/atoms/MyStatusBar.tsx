import React from 'react';
import {StatusBar, StatusBarStyle} from 'react-native';
import {useIsFocused} from '@react-navigation/native';
import {colors} from '../../constants/colors';

// --------------- ASSETS ---------------

// --------------- COMPONENT DECLARATION ---------------
type MyStatusBarProps = {
  barStyle?: StatusBarStyle;
  backgroundColor?: string;
  translucent?: boolean;
  hidden?: boolean;
};

const MyStatusbar: React.FC<MyStatusBarProps> = ({
  barStyle = 'dark-content',
  backgroundColor = colors.white,
  translucent = false,
  hidden = false,
}) => {
  // --------------- COMPONENT ---------------
  return useIsFocused() ? (
    <StatusBar
      barStyle={barStyle}
      translucent={translucent}
      backgroundColor={backgroundColor}
      hidden={hidden}
    />
  ) : null;
};

export default MyStatusbar;
