import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {
  DrawerContentComponentProps,
  DrawerContentScrollView,
  DrawerItemList,
} from '@react-navigation/drawer';
import {colors} from '../../constants/colors';
import DrawerUserInfo from '../molecules/DrawerUserInfo';
import DrawerMyHealthDiary from '../molecules/DrawerMyHealthDiary';
import DrawerBookings from '../molecules/DrawerBookings';
import DrawerMore from '../molecules/DrawerMore';
import DeviceInfo from 'react-native-device-info';

const CustomDrawer = (props: DrawerContentComponentProps) => {
  const onPressAboutUs = () => {
    props.navigation.navigate('AboutUsScreen');
  };

  return (
    <View style={styles.screen}>
      <DrawerContentScrollView
        {...props}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.container}>
        <DrawerUserInfo />
        <DrawerMyHealthDiary />
        <DrawerBookings />
        <DrawerMore onPressAboutUs={onPressAboutUs} />
        <Text style={styles.version}>Version {DeviceInfo.getVersion()}</Text>
      </DrawerContentScrollView>
    </View>
  );
};

export default CustomDrawer;

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: '#F9F9FF',
  },
  container: {
    backgroundColor: '#F9F9FF',
    paddingBottom: 90,
  },
  version: {
    color: colors.inactiveGray,
    textAlign: 'center',
    paddingVertical: 10,
  },
});
