import {
  ImageStyle,
  StyleSheet,
  Text,
  TextProps,
  View,
  ViewStyle,
} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import ProgressBar from './ProgressBar';

export interface DailySummaryTitleProps {
  title: string;
  mainContainerStyle?: ViewStyle;
  imageStyle?: ImageStyle;
  imageContainerStyle?: ViewStyle;
  icon: React.ReactNode;
}

const DailySummaryTitle: React.FC<
  DailySummaryTitleProps & TextProps
> = props => {
  return (
    <View style={[styles.container, props.mainContainerStyle]}>
      {props.icon}
      <Text style={[styles.titleTxt, props.style]} {...props}>
        {props.title}
      </Text>
    </View>
  );
};

export default DailySummaryTitle;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    width: Matrics.s(121),
    borderRadius: Matrics.s(5),
  },
  titleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '700',
    lineHeight: Matrics.vs(17),
    color: colors.inputValueDarkGray,
    marginHorizontal: Matrics.s(10),
    flex: 1,
  },
});
