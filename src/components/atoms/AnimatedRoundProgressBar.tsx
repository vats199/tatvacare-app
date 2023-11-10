import {StyleSheet, Text, TextStyle} from 'react-native';
import React from 'react';
import {AnimatedCircularProgress} from 'react-native-circular-progress';
import {colorsOfprogressBar} from '../../helpers/ColorsOfProgressBar';
import {Fonts, Matrics} from '../../constants';

type AnimatedRoundProgressBarPorps = {
  values: number;
  txtStyle?: TextStyle;
};

const AnimatedRoundProgressBar: React.FC<
  AnimatedRoundProgressBarPorps
> = props => {
  const {values, txtStyle} = props;
  return (
    <AnimatedCircularProgress
      size={48}
      width={3}
      backgroundWidth={3}
      fill={values}
      tintColor={colorsOfprogressBar(values).tintColor}
      backgroundColor={colorsOfprogressBar(values).backgroundColor}
      tintTransparency={true}
      duration={500}
      delay={100}
      rotation={0}
      lineCap="round">
      {fill => (
        <Text
          style={[
            styles.txtStyle,
            txtStyle,
            {
              color: colorsOfprogressBar(values).tintColor,
            },
          ]}>
          {values}%
        </Text>
      )}
    </AnimatedCircularProgress>
  );
};

export default AnimatedRoundProgressBar;

const styles = StyleSheet.create({
  txtStyle: {
    fontSize: Matrics.mvs(11),
    fontFamily: Fonts.BOLD,
    lineHeight: 14,
  },
});
