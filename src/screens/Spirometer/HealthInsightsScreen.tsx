import {FlatList, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Matrics} from '../../constants';

type MineralsProps = {
  title: string;
  percentage: string;
  value: string;
};

type HealthInsightsListProps = {
  id: number;
  name: string;
  date: string;
  FVC: MineralsProps;
  FEV1: MineralsProps;
  Ratio: MineralsProps;
  PEF: MineralsProps;
};

const HealthInsightsList: HealthInsightsListProps[] = [
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
      value: '233L/M',
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
      value: '233L/M',
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
      value: '233L/M',
    },
  },
];

const HealthInsightsScreen = () => {
  const renderItem = ({
    item,
    index,
  }: {
    item: HealthInsightsListProps;
    index: number;
  }) => {
    return (
      <View
        style={{
          backgroundColor: colors.white,
          paddingHorizontal: Matrics.mvs(15),
          paddingVertical: Matrics.vs(15),
          borderRadius: Matrics.mvs(10),
          marginVertical: Matrics.vs(5),
        }}>
        <Text>{item.name}</Text>
      </View>
    );
  };

  return (
    <View
      style={{
        flex: 1,
        backgroundColor: colors.lightPurple,
        paddingTop: Matrics.vs(10),
        paddingHorizontal: Matrics.s(20),
      }}>
      <FlatList data={HealthInsightsList} renderItem={renderItem} />
    </View>
  );
};

export default HealthInsightsScreen;

const styles = StyleSheet.create({});
