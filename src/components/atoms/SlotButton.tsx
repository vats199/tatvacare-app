import {
  StyleSheet,
  Text,
  TextStyle,
  TouchableOpacity,
  TouchableOpacityProps,
  ViewStyle,
} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';

type SlotButtonProps = {
  title: string;
  onPress: () => void;
  buttonStyle?: ViewStyle;
  titleStyle?: TextStyle;
};

const SlotButton: React.FC<SlotButtonProps & TouchableOpacityProps> = props => {
  const {title, buttonStyle, titleStyle} = props;
  return (
    <TouchableOpacity
      style={[
        styles.timeContainerSlot,
        styles.timeContainerShadow,
        buttonStyle,
      ]}
      {...props}>
      <Text numberOfLines={1} style={[styles.titleTxt, titleStyle]}>
        {title}
      </Text>
    </TouchableOpacity>
  );
};

export default SlotButton;

const styles = StyleSheet.create({
  titleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    lineHeight: Matrics.vs(14),
    color: colors.titleLightGray,
  },
  timeContainerSlot: {
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: Matrics.s(12),
    borderWidth: Matrics.s(1),
    paddingHorizontal: Matrics.s(7),
    paddingVertical: Matrics.vs(8),
    marginHorizontal: 0,
    marginRight: Matrics.s(10),
    marginBottom: Matrics.vs(10),
  },
  timeContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.04,
    shadowRadius: 3,
    elevation: 1,
  },
});
