import {StyleSheet, Text, View, ViewStyle} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

type ProgressBarProps = {
  progress: number;
  containerStyle?: ViewStyle;
  progressBarStyle?: ViewStyle;
};

const ProgressBar: React.FC<ProgressBarProps> = ({
  progress,
  containerStyle,
  progressBarStyle,
}) => {
  return (
    <View style={[styles.container, containerStyle]}>
      <View
        style={[styles.progress, {width: `${progress}%`}, progressBarStyle]}
      />
    </View>
  );
};

export default ProgressBar;

const styles = StyleSheet.create({
  container: {
    marginVertical: 10,
    width: '100%',
    height: 4,
    borderRadius: 2,
    backgroundColor: colors.lightGrey,
  },
  progress: {
    height: 4,
    borderRadius: 2,
    backgroundColor: colors.green,
  },
});
