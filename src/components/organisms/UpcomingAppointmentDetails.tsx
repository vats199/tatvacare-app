import {StyleSheet, View, ViewStyle} from 'react-native';
import React from 'react';
import {AppointmentDetailsScreenProps} from '../../screens/Appointment/AppointmentDetailsScreen';
import CoachDetailsCard from '../molecules/CoachDetailsCard';
import IconTitle from '../atoms/IconTitle';
import {Icons} from '../../constants/icons';
import moment from 'moment';
import {colors} from '../../constants/colors';
import {Matrics} from '../../constants';

type UpcomingAppointmentDetailsProp = {
  data: AppointmentDetailsScreenProps;
  containerStyle?: ViewStyle;
  children?: React.ReactNode;
};

const UpcomingAppointmentDetails: React.FC<UpcomingAppointmentDetailsProp> = ({
  data,
  containerStyle,
  children,
}) => {
  return (
    <View
      style={[
        styles.appointmentContainer,
        styles.appointmentContainerShadow,
        containerStyle,
      ]}>
      <CoachDetailsCard
        data={data?.coachDetails}
        containerStyle={{
          alignItems: 'flex-start',
        }}
        profileImageStyle={styles.coachProfile}
      />
      <View style={styles.seprator} />
      <IconTitle
        numberOfLines={1}
        title={moment(data?.date).format('dddd, DD MMM, YYYY')}
        icon={<Icons.CalendarRound />}
      />
      <IconTitle
        numberOfLines={1}
        title={`${data?.timeZone}, ${data?.time} ${moment(
          data?.time.split('-'),
        ).format('A')}`}
        icon={<Icons.Clock />}
      />
      {children}
    </View>
  );
};

export default UpcomingAppointmentDetails;

const styles = StyleSheet.create({
  appointmentContainer: {
    backgroundColor: colors.white,
    marginHorizontal: Matrics.s(15),
    paddingVertical: Matrics.vs(10),
    borderRadius: Matrics.s(15),
  },
  appointmentContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.05,
    shadowRadius: 9,
    elevation: 3,
  },
  coachProfile: {
    height: Matrics.vs(45),
    width: Matrics.s(45),
  },
  seprator: {
    height: Matrics.vs(0.5),
    backgroundColor: colors.lightGrey,
    marginTop: Matrics.s(12),
    marginHorizontal: Matrics.s(15),
  },
});
