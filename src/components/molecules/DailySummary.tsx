import {
  StyleSheet,
  Text,
  TextProps,
  TextStyle,
  View,
  ViewStyle,
} from 'react-native';
import React from 'react';
import ProgressBar from '../atoms/ProgressBar';
import DailySummaryTitle, {
  DailySummaryTitleProps,
} from '../atoms/DailySummaryTitle';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';

type DailySummaryProps = {
  containerStyle?: ViewStyle;
  subTitle: string;
  progressValue: number;
  subTitleTxtStyle?: TextStyle;
  progressBarContainerStyle?: ViewStyle;
  progressBarStyle?: ViewStyle;
};

const DailySummary: React.FC<
  DailySummaryProps & DailySummaryTitleProps & TextProps
> = props => {
  return (
    <View style={[styles.container, props.containerStyle]}>
      <DailySummaryTitle numberOfLines={props.numberOfLines ?? 1} {...props} />
      <View style={styles.textContainer}>
        <Text
          style={[styles.subTxtStyle, props.subTitleTxtStyle]}
          numberOfLines={1}>
          {props.subTitle}
        </Text>
        <ProgressBar
          progress={props.progressValue}
          containerStyle={{
            marginVertical: 0,
            backgroundColor: colors.progressBarGray,
            ...props.progressBarContainerStyle,
          }}
          progressBarStyle={props.progressBarStyle}
        />
      </View>
    </View>
  );
};

export default DailySummary;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: Matrics.s(5),
  },
  textContainer: {
    justifyContent: 'space-around',
    flex: 1,
    alignItems: 'flex-end',
    marginLeft: Matrics.s(20),
  },
  subTxtStyle: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '500',
    color: colors.inputValueDarkGray,
    marginBottom: Matrics.s(-5),
  },
});
