import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import {navigateTo} from '../../routes/Router';

type DrawerBookingsProps = {};

const DrawerBookings: React.FC<DrawerBookingsProps> = ({}) => {
  const onPressConsultations = () => {
    navigateTo('AppointmentsHistoryVC');
  };
  const onPressLabTests = () => {
    navigateTo('LabTestListVC');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.headerText}>Bookings</Text>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressConsultations}>
        <View style={styles.icon}>
          <Icons.DrawerConsultations />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Consultations</Text>
        </View>
      </TouchableOpacity>
      <TouchableOpacity
        style={styles.itemContainer}
        activeOpacity={0.7}
        onPress={onPressLabTests}>
        <View style={styles.icon}>
          <Icons.DrawerLabTests />
        </View>
        <View style={styles.mhdItemTextContainer}>
          <Text style={styles.mhdItemText}>Lab Tests</Text>
        </View>
      </TouchableOpacity>
    </View>
  );
};

export default DrawerBookings;

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
    fontWeight: '700',
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
