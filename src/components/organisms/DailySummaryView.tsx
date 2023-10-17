import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import DailySummary from '../molecules/DailySummary';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import IconButton from '../atoms/IconButton';

type DailySummaryDataType = {
  id: number;
  title: string;
  subTitle: string;
  value: number;
  color: string;
  icon: React.ReactNode;
};

const DailySummaryView = () => {
  const dailySummaryData: DailySummaryDataType[] = [
    {
      id: 1,
      title: 'Diet',
      subTitle: '0 of 1500 cal',
      value: 30,
      color: colors.lightGreen,
      icon: <Icons.Diet height={Matrics.s(29)} width={Matrics.s(29)} />,
    },
    {
      id: 1,
      title: 'Medication',
      subTitle: '0 of 3 doses',
      value: 60,
      color: colors.lightOrange,
      icon: <Icons.Medication height={Matrics.s(29)} width={Matrics.s(29)} />,
    },
    {
      id: 1,
      title: 'Breathing',
      subTitle: '0 of 22 minutes',
      value: 98,
      color: colors.lightPink,
      icon: <Icons.Breathing height={Matrics.s(29)} width={Matrics.s(29)} />,
    },
    {
      id: 1,
      title: 'Exercise',
      subTitle: '0 of 22 minutes',
      value: 30,
      color: colors.veryLightPurple,
      icon: <Icons.Exercise height={Matrics.s(29)} width={Matrics.s(29)} />,
    },
  ];

  const renderItem = (item: DailySummaryDataType, index: number) => {
    return (
      <DailySummary
        title={item.title}
        subTitle={item.subTitle}
        progressValue={item.value}
        mainContainerStyle={{
          backgroundColor: item.color,
        }}
        icon={item.icon}
        progressBarStyle={{
          backgroundColor: item.color,
        }}
      />
    );
  };

  return (
    <View
      style={{
        paddingHorizontal: Matrics.s(15),
      }}>
      {dailySummaryData.map(renderItem)}
      <IconButton
        title="View All"
        containetStyle={styles.viewAllContainer}
        style={styles.viewAllTxt}
        rightIcon={
          <Icons.DownArrow height={Matrics.s(20)} width={Matrics.s(20)} />
        }
      />
    </View>
  );
};

export default DailySummaryView;

const styles = StyleSheet.create({
  viewAllContainer: {
    alignSelf: 'flex-end',
    marginHorizontal: 0,
    marginVertical: Matrics.vs(3),
  },
  viewAllTxt: {
    marginHorizontal: 0,
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '500',
    lineHeight: Matrics.vs(17),
    color: colors.themePurple,
  },
});
