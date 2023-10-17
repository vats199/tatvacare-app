import React, {useRef, useState} from 'react';
import {
  FlatList,
  ImageSourcePropType,
  Platform,
  StyleSheet,
  View,
} from 'react-native';
import {colors} from '../../constants/colors';
import {StackScreenProps} from '@react-navigation/stack';
import {AppointmentStackParamList} from '../../interface/Navigation.interface';
import {Matrics} from '../../constants';
import AppointmentDaySlot from '../../components/organisms/AppointmentDaySlot';
import AppointmentTimeSlot from '../../components/organisms/AppointmentTimeSlot';
import Button from '../../components/atoms/Button';
import CoachDetailsCard from '../../components/molecules/CoachDetailsCard';
import {BottomSheetModal} from '@gorhom/bottom-sheet';
import AppointmentAllSlots from '../../components/organisms/AppointmentAllSlots';
import {AppointmentDetailsScreenProps} from './AppointmentDetailsScreen';
import CommonHeader from '../../components/molecules/CommonHeader';

type AppointmentScreenProps = StackScreenProps<
  AppointmentStackParamList,
  'AppointmentWithScreen'
>;

export type LanguagesType = {
  id: number;
  language: string;
};

export type SlotType = {
  id: number;
  time: string;
};

export type SlotDetailsType = {
  id: number;
  timeZone: string;
  slots: string[];
};

export type CoachDetailsType = {
  name: string;
  profile: ImageSourcePropType & string;
  type: string;
  level: string;
  languages: LanguagesType[];
};

export type AppointmentsType = {
  id: number;
  date: string;
  time: string;
  timeZone?: string;
};

export type CoachDataType = {
  id: number;
  coachDetails: CoachDetailsType;
  slots: SlotDetailsType[];
};

const AppointmentWithScreen: React.FC<AppointmentScreenProps> = ({
  route,
  navigation,
}) => {
  const CoachData: CoachDataType[] = [
    {
      id: 1,
      coachDetails: {
        name: 'Health coach name',
        profile: require('../../assets/images/User.png'),
        type: 'Specialisation',
        level: 'Experience',
        languages: [
          {
            id: 1,
            language: 'Language 1',
          },
          {
            id: 2,
            language: 'Language 2',
          },
          {
            id: 3,
            language: 'Language 1',
          },
          {
            id: 4,
            language: 'Language 2',
          },
          {
            id: 5,
            language: 'Language 1',
          },
          {
            id: 6,
            language: 'Language2',
          },
          {
            id: 7,
            language: 'Language1',
          },
          {
            id: 8,
            language: 'Language2',
          },
        ],
      },
      slots: [
        {
          id: 1,
          timeZone: 'Morning',
          slots: [
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
            '10:30 - 11:30',
            '10:30 - 11:30',
          ],
        },
        {
          id: 2,
          timeZone: 'Afternoon',
          slots: ['08:30 - 09:30', '09:30 - 10:30', '10:30 - 11:30'],
        },
        {
          id: 3,
          timeZone: 'Evening',
          slots: ['08:30 - 09:30', '09:30 - 10:30', '10:30 - 11:30'],
        },
      ],
    },
    {
      id: 2,
      coachDetails: {
        name: 'Health coach name 2',
        profile: require('../../assets/images/User.png'),
        type: 'Specialisation',
        level: 'Experience',
        languages: [
          {
            id: 1,
            language: 'Language1',
          },
          {
            id: 2,
            language: 'Language2',
          },
        ],
      },
      slots: [
        {
          id: 1,
          timeZone: 'Morning',
          slots: [
            '07:30 - 08:30',
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
          ],
        },
        {
          id: 2,
          timeZone: 'Afternoon',
          slots: [
            '07:30 - 08:30',
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
          ],
        },
        {
          id: 3,
          timeZone: 'Evening',
          slots: [
            '07:30 - 08:30',
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
          ],
        },
      ],
    },
    {
      id: 3,
      coachDetails: {
        name: 'Health coach name 3',
        profile: require('../../assets/images/User.png'),
        type: 'Specialisation',
        level: 'Experience',
        languages: [
          {
            id: 1,
            language: 'Language1',
          },
          {
            id: 2,
            language: 'Language2',
          },
        ],
      },
      slots: [
        {
          id: 1,
          timeZone: 'Morning',
          slots: [
            '07:30 - 08:30',
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
          ],
        },
        {
          id: 2,
          timeZone: 'Afternoon',
          slots: [
            '07:30 - 08:30',
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
          ],
        },
        {
          id: 3,
          timeZone: 'Evening',
          slots: [
            '07:30 - 08:30',
            '08:30 - 09:30',
            '09:30 - 10:30',
            '10:30 - 11:30',
          ],
        },
      ],
    },
  ];
  const [appointment, setAppointments] = useState<AppointmentsType | null>(
    null,
  );
  const [selectedId, setSelectedId] = useState<number | null>(null);
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);
  const type = route?.params?.type;

  const timeFrom = (count: number) => {
    let dates: string[] = [];
    for (let I = 0; I < Math.abs(count); I++) {
      dates.push(
        new Date(
          new Date().getTime() -
            (count >= 0 ? I : I - I - I) * 24 * 60 * 60 * 1000,
        ).toUTCString(),
      );
    }
    return dates;
  };

  const onPressDaySlot = (date: string, item: CoachDataType) => {
    const sameAppointment = appointment?.id == item.id;
    const tempAppointment: AppointmentsType = {
      id: item.id,
      date: date,
      time: sameAppointment ? appointment.time : '',
      timeZone: '',
    };
    setAppointments(tempAppointment);
  };

  const onPressTimeSlot = (
    time: string,
    item: CoachDataType,
    timeZone: string,
  ) => {
    const sameAppointment = appointment?.id == item.id;
    const today = new Date().toUTCString();
    const tempAppointment: AppointmentsType = {
      id: item.id,
      date: sameAppointment ? appointment.date : today,
      time: time,
      timeZone: timeZone ?? '',
    };
    setAppointments(tempAppointment);
  };

  const onPressSaveNextBtn = () => {
    console.log('appointment', appointment);
    if (appointment?.id) {
      const coachDetails = CoachData.filter(item => item.id == appointment.id);
      const props: AppointmentDetailsScreenProps = {
        coachDetails: coachDetails[0].coachDetails,
        ...appointment,
      };
      bottomSheetModalRef.current?.forceClose({duration: 600});
      navigation.navigate('AppointmentDetailsScreen', {
        appointmentDetails: props,
      });
    }
  };

  const openSlotDetailsBottomSheet = (id: number, item: CoachDataType) => {
    bottomSheetModalRef.current?.present();
    const sameAppointment = appointment?.id == item.id;
    if (!sameAppointment) {
      const today = new Date().toUTCString();
      setAppointments({
        id: id,
        date: today,
        time: '',
      });
    }
  };

  const renderItem = ({item, index}: {item: CoachDataType; index: number}) => {
    const {coachDetails, slots, id} = item;
    // generate dates
    const dates = timeFrom(10);
    return (
      <View style={[styles.coachContainer, styles.coachContainerShadow]}>
        <CoachDetailsCard data={coachDetails} />
        <View style={[styles.seprator]} />
        <AppointmentDaySlot
          data={dates}
          onPress={date => onPressDaySlot(date, item)}
          selectedData={appointment?.id == item.id ? appointment : null}
        />
        <AppointmentTimeSlot
          data={slots[0]}
          viewAllslot={slots?.length > 1}
          onPress={(time, timeZone) => onPressTimeSlot(time, item, timeZone)}
          selectedData={appointment?.id == item.id ? appointment : null}
          onViewallPress={() => {
            setSelectedId(id);
            openSlotDetailsBottomSheet(id, item);
          }}
        />
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <CommonHeader
        onPress={() => {
          navigation.goBack();
        }}
        title={`Appointment with ${type}`}
      />
      <FlatList
        data={CoachData}
        renderItem={renderItem}
        keyExtractor={(_item, index) => index.toString()}
        showsVerticalScrollIndicator={false}
      />
      <View
        style={[
          styles.bottomBtn,
          styles.bottomBtnShadow,
          {
            marginBottom: Platform.OS == 'android' ? Matrics.s(20) : 0,
          },
        ]}>
        <Button
          disabled={appointment?.date && appointment?.time ? false : true}
          onPress={onPressSaveNextBtn}
          title="Save & Next"
          titleStyle={{
            fontWeight: '700',
          }}
          buttonStyle={{
            paddingVertical: Matrics.vs(10),
          }}
        />
      </View>
      <AppointmentAllSlots
        ref={bottomSheetModalRef}
        coachDetails={CoachData?.filter(item => item.id == selectedId)[0]}
        selectedData={appointment ?? null}
        setSelectedData={setAppointments}
        onPress={onPressSaveNextBtn}
      />
    </View>
  );
};

export default AppointmentWithScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
  },
  itemSeprator: {
    height: Matrics.vs(11),
  },
  seprator: {
    height: Matrics.vs(0.5),
    backgroundColor: colors.lightGrey,
    marginTop: Matrics.s(12),
    marginHorizontal: Matrics.s(15),
  },
  coachContainer: {
    backgroundColor: colors.white,
    flex: 1,
    marginHorizontal: Matrics.s(15),
    paddingVertical: Matrics.s(15),
    borderRadius: Matrics.s(15),
    marginVertical: Matrics.vs(5),
  },
  coachContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.05,
    shadowRadius: 5,
    elevation: 3,
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
