import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';

type HealthTipProps = {
  tip: any;
};

const HealthTip: React.FC<HealthTipProps> = ({ tip }) => {
  return (
    <View style={styles.container}>
      <Icons.LightBulb />
      <Text style={styles.text}>{tip?.description || '-'}</Text>
    </View>
  );
};

export default HealthTip;

const styles = StyleSheet.create({
  container: {
    marginTop: 10,
    backgroundColor: colors.purple,
    borderRadius: 12,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
  },
  text: {
    color: colors.white,
    flex: 1,
    fontSize: 12,
    fontFamily: 'SFProDisplay-Semibold',
    marginLeft: 10,
  },
});
