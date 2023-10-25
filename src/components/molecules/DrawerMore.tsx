import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
// import {navigateTo, navigateToShareKit} from '../../routes/Router';
import {Fonts, Matrics} from '../../constants';

type DrawerMoreProps = {
  onPressAboutUs: () => void;
};

const DrawerMore: React.FC<DrawerMoreProps> = ({onPressAboutUs = () => {}}) => {
  const onAccountSettingsPress = () => {
    // navigateTo('AccountSettingVC');
  };
  const onHelpAndSupportPress = () => {
    // navigateTo('HelpAndSupportVC');
  };
  const onShareAppPress = () => {
    // navigateToShareKit();
  };

  return (
    <View style={styles.container}>
      <Text style={styles.headerText}>More</Text>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onAccountSettingsPress}>
        <View style={styles.icon}>
          <Icons.DrawerAccountSettings />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Account Settings</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onHelpAndSupportPress}>
        <View style={styles.icon}>
          <Icons.DrawerHelpSupport />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Help & Support</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressAboutUs}>
        <View style={styles.icon}>
          <Icons.DrawerAboutUs />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>About Us</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onShareAppPress}>
        <View style={styles.icon}>
          <Icons.DrawerShareApp />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Share App</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7}>
        <View style={styles.icon}>
          <Icons.DrawerRateApp />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Rate App</Text>
        </View>
      </TouchableOpacity>
    </View>
  );
};

export default DrawerMore;

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
