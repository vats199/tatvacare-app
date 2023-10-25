import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
// import {navigateTo} from '../../routes/Router';
import {Fonts, Matrics} from '../../constants';

type DrawerBookingsProps = {};

const DrawerBookings: React.FC<DrawerBookingsProps> = ({}) => {
  const onPressConsultations = () => {
    // navigateTo('AppointmentsHistoryVC');
  };
  const onPressLabTests = () => {
    // navigateTo('LabTestListVC');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.headerText}>Drawer Bookings</Text>
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
