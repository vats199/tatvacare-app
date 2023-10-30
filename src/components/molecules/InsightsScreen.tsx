import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';

type MineralsProps = {
  title: string;
  percentage: string;
  value: string;
};

export type HealthInsightsListProps = {
  id: number;
  name: string;
  date: string;
  FVC: MineralsProps;
  FEV1: MineralsProps;
  Ratio: MineralsProps;
  PEF: MineralsProps;
};

type InsightsScreenProps = {
  data: HealthInsightsListProps[];
};
const InsightsScreen: React.FC<InsightsScreenProps> = ({data}) => {
  const renderStastics = (item: MineralsProps, index: number) => {
    return (
      <View>
        <Text style={styles.valueTxt}>{item.value}</Text>
        <Text style={styles.perTxt}>{item.percentage + ' (P)'}</Text>
        <Text style={styles.stasticsTxt}>{item.title}</Text>
      </View>
    );
  };

  const renderItem = ({
    item,
    index,
  }: {
    item: HealthInsightsListProps;
    index: number;
  }) => {
    const stastics = [item.FVC, item.FEV1, item.Ratio, item.PEF];
    return (
      <View style={styles.itemContainer}>
        <View style={styles.titleContainer}>
          <View>
            <Text style={styles.titleTxt}>{item.name}</Text>
            <Text style={styles.dateTxt}>Date & Time</Text>
          </View>
          <TouchableOpacity hitSlop={5}>
            <Icons.Download height={Matrics.s(20)} width={Matrics.s(20)} />
          </TouchableOpacity>
        </View>
        <View style={styles.seprator} />
        <View style={styles.stasticsContainer}>
          {stastics?.map(renderStastics)}
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <FlatList
        showsVerticalScrollIndicator={false}
        data={data}
        renderItem={renderItem}
      />
    </View>
  );
};

export default InsightsScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
    paddingTop: Matrics.vs(10),
    paddingHorizontal: Matrics.s(20),
  },
  itemContainer: {
    backgroundColor: colors.white,
    paddingHorizontal: Matrics.mvs(15),
    paddingVertical: Matrics.vs(10),
    borderRadius: Matrics.mvs(10),
    marginVertical: Matrics.vs(5),
  },
  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  titleTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    color: colors.labelDarkGray,
    lineHeight: Matrics.vs(20),
  },
  dateTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(12),
    color: colors.subTitleLightGray,
  },
  seprator: {
    height: Matrics.vs(1),
    backgroundColor: '#E9E9E9',
    marginVertical: Matrics.vs(10),
  },
  stasticsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  valueTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    color: colors.labelDarkGray,
  },
  perTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(12),
    color: colors.darkLightGray,
    lineHeight: Matrics.vs(15),
  },
  stasticsTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    color: colors.subTitleLightGray,
    marginTop: Matrics.vs(5),
  },
});
