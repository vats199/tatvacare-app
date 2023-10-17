import {Platform, StyleSheet, Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {CoachDetailsType} from './AppointmentWithScreen';
import {StackScreenProps} from '@react-navigation/stack';
import {AppointmentStackParamList} from '../../interface/Navigation.interface';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';
import Button from '../../components/atoms/Button';
import UpcomingAppointmentDetails from '../../components/organisms/UpcomingAppointmentDetails';
import CommonHeader from '../../components/molecules/CommonHeader';

export type AppointmentDetailsScreenProps = {
  id: number;
  coachDetails: CoachDetailsType;
  date: string;
  time: string;
  timeZone?: string;
};

type AppointmentScreenProps = StackScreenProps<
  AppointmentStackParamList,
  'AppointmentDetailsScreen'
>;

const AppointmentDetailsScreen: React.FC<AppointmentScreenProps> = ({
  navigation,
  route,
}) => {
  const appointmentDetails = route.params.appointmentDetails;

  const [appointmentBooked, setAppointmentBooked] = useState<boolean>(false);

  const onPressBook = () => {
    setAppointmentBooked(true);
  };

  useEffect(() => {
    if (appointmentBooked) {
      setTimeout(() => {
        setAppointmentBooked(false);
        navigation.navigate('AppointmentScreen', {
          appointmentDetails: route.params.appointmentDetails,
        });
      }, 2000);
    }
  }, [appointmentBooked]);

  return (
    <View style={styles.container}>
      {appointmentBooked ? (
        <View style={styles.appointmentBookedContainer}>
          <Icons.Correct height={Matrics.s(85)} width={Matrics.s(85)} />
          <Text style={styles.congratulationTxt}>Congratulations!</Text>
          <Text style={styles.bookedAppointmentTxt}>
            Your payment is successful, and your appointment is booked
            successfully.
          </Text>
        </View>
      ) : (
        <>
          <CommonHeader
            onPress={() => navigation.goBack()}
            title="Appointment Details"
          />
          <View style={styles.subContainer}>
            <UpcomingAppointmentDetails data={appointmentDetails} />
            <View
              style={[
                styles.bottomBtn,
                styles.bottomBtnShadow,
                {
                  marginBottom: Platform.OS == 'android' ? Matrics.s(20) : 0,
                },
              ]}>
              <Button
                onPress={onPressBook}
                title="Book"
                titleStyle={{
                  fontWeight: '700',
                }}
                buttonStyle={{
                  paddingVertical: Matrics.vs(10),
                }}
              />
            </View>
          </View>
        </>
      )}
    </View>
  );
};

export default AppointmentDetailsScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
  },
  subContainer: {
    flex: 1,
    justifyContent: 'space-between',
    marginTop: Matrics.s(20),
  },
  appointmentBookedContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    marginHorizontal: Matrics.s(15),
  },
  congratulationTxt: {
    marginTop: Matrics.s(10),
    marginBottom: Matrics.s(4),
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    lineHeight: Matrics.s(22),
    color: colors.labelDarkGray,
  },
  bookedAppointmentTxt: {
    textAlign: 'center',
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(13),
    fontWeight: '400',
    lineHeight: Matrics.s(19),
    color: colors.subTitleLightGray,
  },
  bottomBtn: {
    backgroundColor: colors.white,
    paddingHorizontal: Matrics.s(15),
    paddingVertical: Matrics.s(10),
  },
  bottomBtnShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.2,
    shadowRadius: 9,
    elevation: 3,
  },
});
