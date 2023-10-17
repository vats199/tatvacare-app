import {
  StyleSheet,
  Text,
  TextProps,
  TouchableOpacity,
  View,
  ViewStyle,
} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';

type IconButtonProps = {
  title: string;
  leftIcon?: React.ReactNode;
  containetStyle?: ViewStyle;
  rightIcon?: React.ReactNode;
  disable?: boolean;
  onPressBtn?: () => void;
};

const IconButton: React.FC<IconButtonProps & TextProps> = props => {
  const {
    title,
    leftIcon,
    rightIcon,
    containetStyle,
    disable = false,
    onPressBtn,
  } = props;
  return (
    <TouchableOpacity
      activeOpacity={0.5}
      disabled={disable}
      style={[styles.containerStyle, containetStyle]}
      onPress={onPressBtn}>
      {leftIcon}
      <Text {...props} style={[styles.titleTxtStyle, props.style]}>
        {title}
      </Text>
      {rightIcon}
    </TouchableOpacity>
  );
};

export default IconButton;

const styles = StyleSheet.create({
  titleTxtStyle: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(12),
    color: colors.inputValueDarkGray,
    marginHorizontal: Matrics.s(10),
  },
  containerStyle: {
    flexDirection: 'row',
    marginHorizontal: Matrics.s(15),
    marginTop: Matrics.vs(10),
    alignItems: 'center',
  },
});
