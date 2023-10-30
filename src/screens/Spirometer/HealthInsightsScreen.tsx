import React from 'react';
import InsightsScreen, {
  HealthInsightsListProps,
} from '../../components/molecules/InsightsScreen';
import {StyleSheet, View} from 'react-native';
import Button from '../../components/atoms/Button';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {useSafeAreaInsets} from 'react-native-safe-area-context';

export const HealthInsightsList: HealthInsightsListProps[] = [
  {
    id: 1,
    name: 'Lung Health',
    date: 'Date & Time',
    FVC: {
      percentage: '70.00',
      title: 'FVC',
      value: '3.07L',
    },
    FEV1: {
      percentage: '70.00',
      title: 'FVC1',
      value: '2.20L',
    },
    Ratio: {
      percentage: '70.00%',
      title: 'Ratio',
      value: '72.0%',
    },
    PEF: {
      percentage: '70.00',
      title: 'PEF',
      value: '233 L/M',
    },
  },
  {
    id: 2,
    name: 'Lung Health',
    date: 'Date & Time',
    FVC: {
      percentage: '70.00',
      title: 'FVC',
      value: '3.07L',
    },
    FEV1: {
      percentage: '70.00',
      title: 'FVC1',
      value: '2.20L',
    },
    Ratio: {
      percentage: '70.00%',
      title: 'Ratio',
      value: '72.0%',
    },
    PEF: {
      percentage: '70.00',
      title: 'PEF',
      value: '233 L/M',
    },
  },
  {
    id: 3,
    name: 'Lung Health',
    date: 'Date & Time',
    FVC: {
      percentage: '70.00',
      title: 'FVC',
      value: '3.07L',
    },
    FEV1: {
      percentage: '70.00',
      title: 'FVC1',
      value: '2.20L',
    },
    Ratio: {
      percentage: '70.00%',
      title: 'Ratio',
      value: '72.0%',
    },
    PEF: {
      percentage: '70.00',
      title: 'PEF',
      value: '233 L/M',
    },
  },
];

const HealthInsightsScreen = () => {
  const insets = useSafeAreaInsets();
  return <InsightsScreen data={HealthInsightsList} />;
};

export default HealthInsightsScreen;

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
