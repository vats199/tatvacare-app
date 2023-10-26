import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import InsightsScreen from '../../components/molecules/InsightsScreen';
import {HealthInsightsList} from './HealthInsightsScreen';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import Button from '../../components/atoms/Button';
import {useSafeAreaInsets} from 'react-native-safe-area-context';

const ExerciseInsights = () => {
  const insets = useSafeAreaInsets();
  return (
    <>
      <InsightsScreen data={HealthInsightsList} />
      <View
        style={[
          styles.bottomBtnContainerShadow,
          styles.bottonBtnContainer,
          {
            paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(16),
          },
        ]}>
        <Button
          title="Connect"
          titleStyle={styles.saveBtnTxt}
          buttonStyle={{
            borderRadius: Matrics.s(19),
          }}
          onPress={() => {}}
        />
      </View>
    </>
  );
};

export default ExerciseInsights;

const styles = StyleSheet.create({
  bottomBtnContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
  bottonBtnContainer: {
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(8),
  },
  saveBtnTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
  },
});
