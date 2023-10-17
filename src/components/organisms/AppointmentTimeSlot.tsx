import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {
  AppointmentsType,
  SlotDetailsType,
} from '../../screens/Appointment/AppointmentWithScreen';
import SlotButton from '../atoms/SlotButton';

type AppointmentTimeSlotProps = {
  data: SlotDetailsType;
  viewAllslot: boolean;
  onPress: (data: string, timeZone: string) => void;
  selectedData: AppointmentsType | null;
  onViewallPress: () => void;
};

const AppointmentTimeSlot: React.FC<AppointmentTimeSlotProps> = ({
  data,
  onPress,
  viewAllslot,
  selectedData,
  onViewallPress,
}) => {
  const onPressTimeSlot = (item: string) => {
    onPress(item, data.timeZone);
  };

  const renderSlots = ({item, index}: {item: string; index: number}) => {
    const baseValidation = selectedData?.id && selectedData?.time == item;
    const selectedTimeSlot = selectedData?.timeZone
      ? selectedData?.timeZone == data.timeZone && baseValidation
      : baseValidation;
    return (
      <SlotButton
        title={item.replaceAll(' ', '')}
        onPress={() => onPressTimeSlot(item)}
        buttonStyle={{
          backgroundColor: selectedTimeSlot
            ? colors.boxLightPurple
            : colors.white,
          borderColor: selectedTimeSlot
            ? colors.darkBorder
            : colors.lightBorder,
        }}
        titleStyle={
          selectedTimeSlot ? styles.activeTimeTxt : styles.inactiveTimeTxt
        }
      />
    );
  };

  return (
    <View style={styles.slotContainer}>
      <Text numberOfLines={1} style={styles.nextAvailableSlotTxt}>
        Next Available Slots
      </Text>
      <FlatList
        data={data.slots.slice(0, 3)}
        renderItem={renderSlots}
        numColumns={3}
        scrollEnabled={false}
        style={{
          marginTop: Matrics.s(6),
        }}
        keyExtractor={(_item, index) => index.toString()}
      />
      {viewAllslot ? (
        <TouchableOpacity
          onPress={onViewallPress}
          style={styles.viewAllTxtContainer}>
          <Text style={styles.viewAllSlotsTxt}>View All Slots</Text>
        </TouchableOpacity>
      ) : null}
    </View>
  );
};

export default AppointmentTimeSlot;

const styles = StyleSheet.create({
  viewAllSlotsTxt: {
    color: colors.themePurple,
    fontWeight: '600',
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(13),
    lineHeight: Matrics.s(12),
  },
  viewAllTxtContainer: {
    alignSelf: 'center',
    marginTop: Matrics.s(5),
  },
  slotContainer: {
    marginHorizontal: Matrics.s(15),
  },
  activeTimeTxt: {
    color: colors.black,
    fontWeight: '500',
  },
  inactiveTimeTxt: {
    color: colors.labelDarkGray,
  },
  timeTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    lineHeight: Matrics.vs(14),
    color: colors.titleLightGray,
  },
  nextAvailableSlotTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(14),
    lineHeight: Matrics.vs(20),
    color: colors.labelTitleDarkGray,
    flex: 1,
  },
});
