import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import IconButton from '../atoms/IconButton';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';

type MyCareDataType = {
  id: number;
  title: string;
  time: string;
  calories: string;
};

const MyCare = () => {
  const myCareData: MyCareDataType[] = [
    {
      id: 1,
      title: 'Breakfast',
      time: 'Ideal Time',
      calories: 'Calories',
    },
  ];

  const renderItem = ({item, index}: {item: MyCareDataType; index: number}) => {
    return (
      <TouchableOpacity
        activeOpacity={0.8}
        style={[styles.itemContainer, styles.itemShadowContainer]}>
        <View style={styles.itemSubContainer}>
          <View style={styles.emptyBox} />
          <View style={styles.txtContainer}>
            <Text numberOfLines={1} style={styles.itemTitleTxt}>
              {item.title}
            </Text>
            <Text numberOfLines={1} style={styles.itemDesTxt}>
              {item.time} | {item.calories}
            </Text>
          </View>
        </View>
        <Icons.Dropdown height={Matrics.s(15)} width={Matrics.s(15)} />
      </TouchableOpacity>
    );
  };

  return (
    <>
      <View style={styles.myCareHeaderCotnainer}>
        <Text style={styles.myCareTxt}>My Care</Text>
        <IconButton
          containetStyle={styles.todaysPlanTxtContainer}
          title="Today’s Plan"
          style={styles.todaysPlanTxt}
          rightIcon={
            <Icons.DownArrow
              height={Matrics.s(19)}
              width={Matrics.s(19)}
              style={{
                transform: [{rotate: '270deg'}],
              }}
            />
          }
        />
      </View>
      <FlatList
        scrollEnabled={false}
        showsVerticalScrollIndicator={false}
        data={myCareData}
        renderItem={renderItem}
      />
    </>
  );
};

export default MyCare;

const styles = StyleSheet.create({
  myCareHeaderCotnainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: Matrics.vs(15),
    paddingHorizontal: Matrics.s(15),
  },
  myCareTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    lineHeight: Matrics.vs(20),
    color: colors.labelDarkGray,
  },
  todaysPlanTxtContainer: {
    alignSelf: 'flex-end',
    marginHorizontal: 0,
    marginTop: 0,
  },
  todaysPlanTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '600',
    lineHeight: Matrics.vs(18),
    color: colors.themePurple,
    marginHorizontal: 0,
  },
  itemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: colors.white,
    paddingHorizontal: Matrics.s(11),
    paddingVertical: Matrics.s(10),
    borderRadius: Matrics.s(12),
    marginHorizontal: Matrics.s(15),
  },
  itemShadowContainer: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.04,
    shadowRadius: 3,
    elevation: 1,
  },
  itemSubContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    flex: 1,
  },
  emptyBox: {
    width: Matrics.s(32),
    height: Matrics.s(32),
    backgroundColor: colors.darkGray,
  },
  txtContainer: {
    marginHorizontal: Matrics.s(10),
    flex: 1,
  },
  itemTitleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    fontWeight: '500',
    lineHeight: Matrics.vs(20),
    color: colors.inputValueDarkGray,
  },
  itemDesTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '400',
    lineHeight: Matrics.vs(17),
    color: colors.subTitleLightGray,
  },
});
