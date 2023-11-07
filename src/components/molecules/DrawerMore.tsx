import { Linking, NativeModules, Platform, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { trackEvent } from '../../helpers/TrackEvent';
//import { navigateTo, navigateToShareKit } from '../../routes/Router';

type DrawerMoreProps = {
  onPressAboutUs: () => void;
};

const DrawerMore: React.FC<DrawerMoreProps> = ({ onPressAboutUs = () => { } }) => {
  const trackCommonEvent = (name: string) => {
    trackEvent("MENU_NAVIGATION", {
      menu: name
    })
  }

  const onAccountSettingsPress = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("Account Settings")
      //navigateTo('AccountSettingVC');
    } else {
      NativeModules.AndroidBridge.openAccountSettingScreen();
    }
  };
  const onHelpAndSupportPress = () => {
    if (Platform.OS == 'ios') {
      //navigateTo('HelpAndSupportVC');
    } else {
      NativeModules.AndroidBridge.openHelpSupportScreen();
    }
  };
  const onShareAppPress = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("Share App")
      //navigateToShareKit();
    } else {
      NativeModules.AndroidBridge.openShareAppScreen();
    }
  };

  const onPressRateApp = () => {
    if (Platform.OS == 'ios') {
      trackCommonEvent("Rate App")
      Linking.openURL('https://apps.apple.com/in/app/mytatva/id1590299281');
    } else {
      NativeModules.AndroidBridge.openRateAppScreen();
    }
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
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressRateApp}>
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
