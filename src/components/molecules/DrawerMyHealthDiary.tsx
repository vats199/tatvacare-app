import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
// import {
//   navigateTo,
//   navigateToHistory,
//   navigateToBookmark,
// } from '../../routes/Router';
import {Fonts, Matrics} from '../../constants';

type DrawerMyHealthDiaryProps = {};

const DrawerMyHealthDiary: React.FC<DrawerMyHealthDiaryProps> = ({}) => {
  const onPressGoals = () => {
    // navigateTo('SetGoalsVC');
  };

  const onPressHealthRecords = () => {
    // navigateToHistory('Records');
  };
  const onPressBookmarks = () => {
    // navigateToBookmark();
  };

  return (
    <View style={styles.container}>
      <Text style={styles.headerText}>My Health Diary</Text>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressHealthRecords}>
        <View style={styles.icon}>
          <Icons.DrawerHealthRecords />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Health Records</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressBookmarks}>
        <View style={styles.icon}>
          <Icons.DrawerBookmarks />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Bookmarks</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressGoals}>
        <View style={styles.icon}>
          <Icons.DrawerGoals />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Goals</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressGoals}>
        <View style={styles.icon}>
          <Icons.DrawerHealthTrends />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Health Trends</Text>
        </View>
      </TouchableOpacity>
    </View>
  );
};

export default DrawerMyHealthDiary;

const styles = StyleSheet.create({
  container: {
    marginHorizontal: Matrics.s(12),
    marginVertical: Matrics.vs(5),
    paddingVertical: Matrics.vs(12),
    paddingHorizontal: Matrics.vs(12),
    backgroundColor: colors.white,
    borderRadius: Matrics.mvs(12),
  },
  headerText: {
    color: colors.labelDarkGray,
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.BOLD,
  },
  itemContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: Matrics.vs(5),
  },
  icon: {
    marginVertical: Matrics.vs(5),
  },
  mhdItemTextContainer: {
    flex: 1,
    borderBottomWidth: 0.5,
    borderBottomColor: colors.lightGrey,
    padding: Matrics.mvs(10),
  },
  mhdItemText: {
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.REGULAR,
    color: colors.labelDarkGray,
  },
});
