import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

type ProgressBarProps = {
  progress: number;
  expired: boolean;
  color: string;
};

const ProgressBar: React.FC<ProgressBarProps> = ({
  progress,
  expired,
  color,
}) => {
  return (
    <View style={styles.container}>
      <View
        style={[
          styles.progress,
          {
            width: `${progress}%`,
            backgroundColor: expired
              ? colors.red
              : color
              ? color
              : colors.green,
          },
        ]}
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
  },
});
