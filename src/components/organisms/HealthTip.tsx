import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { trackEvent } from '../../helpers/TrackEvent';

type HealthTipProps = {
  tip: any;
};

const HealthTip: React.FC<HealthTipProps> = ({ tip }) => {
  return (
    <TouchableOpacity
      style={styles.container}
      activeOpacity={1}
      onPress={() => {
        trackEvent('CLICKED_DOCTOR_SAYS', {});
      }}>
      <Icons.LightBulb />
      <Text style={styles.text}>{tip?.description || '-'}</Text>
    </TouchableOpacity>
  );
};

export default HealthTip;

const styles = StyleSheet.create({
  container: {
    marginTop: 24,
    marginBottom: 24,
    marginHorizontal: 16,
    backgroundColor: colors.purple,
    borderRadius: 12,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
  },
  text: {
    color: colors.white,
    flex: 1,
    fontSize: 14,
    fontFamily: 'SFProDisplay-Regular',
    marginLeft: 10,
  },
});
