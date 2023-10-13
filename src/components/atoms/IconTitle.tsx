import {StyleSheet, Text, TextProps, View, ViewStyle} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';

type IconTitleProps = {
  title: string;
  icon: React.ReactNode;
  containetStyle?: ViewStyle;
};

const IconTitle: React.FC<IconTitleProps & TextProps> = props => {
  const {title, icon, containetStyle} = props;
  return (
    <View style={[styles.containerStyle, containetStyle]}>
      {icon}
      <Text {...props} style={[styles.titleTxtStyle, props.style]}>
        {title}
      </Text>
    </View>
  );
};

export default IconTitle;

const styles = StyleSheet.create({
  titleTxtStyle: {
    marginLeft: Matrics.s(7),
    flex: 1,
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(12),
    color: colors.inputValueDarkGray,
  },
  containerStyle: {
    flexDirection: 'row',
    marginHorizontal: Matrics.s(15),
    marginTop: Matrics.vs(10),
    alignItems: 'center',
  },
});
