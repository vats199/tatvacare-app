import React from 'react';
import InsightsScreen, {
  HealthInsightsListProps,
} from '../../components/molecules/InsightsScreen';
import {StyleSheet, View} from 'react-native';

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
  return <InsightsScreen data={HealthInsightsList} />;
};

export default HealthInsightsScreen;

const styles = StyleSheet.create({});
