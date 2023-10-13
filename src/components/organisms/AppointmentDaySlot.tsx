import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {AppointmentsType} from '../../screens/Appointment/AppointmentWithScreen';
import moment from 'moment';

type AppointmentDaySlotProps = {
  data: string[];
  onPress: (item: string) => void;
  selectedData: AppointmentsType | null;
};

const AppointmentDaySlot: React.FC<AppointmentDaySlotProps> = ({
  data,
  onPress,
  selectedData,
}) => {
  const onPressDateSlot = (item: string) => {
    onPress(item);
  };

  const renderDays = ({item, index}: {item: string; index: number}) => {
    const convertedDate = moment(item).format('ddd DD');
    const dayName = convertedDate?.split(' ')[0];
    const date = convertedDate?.split(' ')[1];
    const dateSelected =
      moment(selectedData?.date).format('ddd DD') === convertedDate ||
      (selectedData == null && index == 0);
    return (
      <TouchableOpacity
        onPress={() => onPressDateSlot(item)}
        activeOpacity={0.6}
        style={[
          styles.dayContainer,
          styles.dayContainerShadow,
          {
            backgroundColor: dateSelected
              ? colors.boxLightPurple
              : colors.white,
            borderColor: dateSelected ? colors.darkBorder : colors.lightBorder,
            marginLeft: Matrics.s(index == 0 ? 15 : 8),
            marginRight: Matrics.s(data.length - 1 == index ? 15 : 0),
          },
        ]}>
        <Text
          style={[
            dateSelected ? styles.activeDayTxt : styles.inactiveDayTxt,
            styles.dayTxt,
          ]}>
          {dayName}
        </Text>
        <Text
          style={[
            dateSelected ? styles.activeDayTxt : styles.inactiveDayTxt,
            styles.dayTxt,
          ]}>
          {date}
        </Text>
      </TouchableOpacity>
    );
  };

  return (
    <View>
      <FlatList
        data={data}
        renderItem={renderDays}
        horizontal
        showsHorizontalScrollIndicator={false}
        keyExtractor={(_item, index) => index.toString()}
      />
    </View>
  );
};

export default AppointmentDaySlot;

const styles = StyleSheet.create({
  dayContainer: {
    alignItems: 'center',
    width: Matrics.s(43),
    height: Matrics.vs(40),
    justifyContent: 'center',
    borderRadius: Matrics.s(10),
    borderWidth: Matrics.s(1),
    marginVertical: Matrics.vs(10),
  },
  dayContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.05,
    shadowRadius: 3,
    elevation: 3,
  },
  activeDayTxt: {
    color: colors.black,
    fontWeight: '500',
  },
  inactiveDayTxt: {
    color: colors.labelDarkGray,
  },
  dayTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    lineHeight: Matrics.vs(14),
  },
});
