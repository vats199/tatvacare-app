import { NativeModules, Platform, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { trackEvent } from '../../helpers/TrackEvent';
// import {
//   navigateTo,
//   navigateToHistory,
//   navigateToBookmark,
//   openAddWeightHeight,
// } from '../../routes/Router';

type DrawerMyHealthDiaryProps = {};

const DrawerMyHealthDiary: React.FC<DrawerMyHealthDiaryProps> = ({ }) => {

  const trackCommonEvent = (name: string) => {
    trackEvent("MENU_NAVIGATION", {
      menu: name
    })
  }
  const onPressGoals = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("Goals")
      //navigateTo('SetGoalsVC');
    } else {
      NativeModules.AndroidBridge.openHealthGoalScreen();
    }
  };
  const onPressBMI = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("BMI")
      //openAddWeightHeight();
    } else {
      NativeModules.AndroidBridge.openBMIScreen();
    }
  };



  const onPressHealthRecords = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("Health Records")
      //navigateToHistory('Records');
    } else {
      NativeModules.AndroidBridge.openHealthRecordScreen();
    }
  };
  const onPressBookmarks = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("Bookmarks")
      //navigateToBookmark();
    } else {
      NativeModules.AndroidBridge.openBookmarkScreen();
    }
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
        onPress={onPressBMI}>
        <View style={styles.icon}>
          <Icons.DrawerBMI />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>BMI</Text>
        </View>
      </TouchableOpacity>
    </View>
  );
};

export default DrawerMyHealthDiary;

const styles = StyleSheet.create({
  container: {
    marginHorizontal: 10,
    marginVertical: 5,
    paddingVertical: 10,
    backgroundColor: colors.white,
    borderRadius: 12,
  },
  headerText: {
    color: colors.black,
    fontSize: 14,
    fontFamily: 'SFProDisplay-Bold',
    marginHorizontal: 10,

  },
  itemContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 5,
  },
  icon: {
    marginVertical: 5,
    marginHorizontal: 10,
  },
  mhdItemTextContainer: {
    flex: 1,
    borderBottomWidth: 0.5,
    borderBottomColor: colors.lightGrey,
    padding: 10,
  },
  mhdItemText: {},
});
