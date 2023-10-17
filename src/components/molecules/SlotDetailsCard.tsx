import {StyleSheet, Text, View} from 'react-native';
import React, {useState} from 'react';
import {Icons} from '../../constants/icons';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import SlotButton from '../atoms/SlotButton';
import {
  AppointmentsType,
  SlotDetailsType,
} from '../../screens/Appointment/AppointmentWithScreen';

const SlotDetailsCard = ({
  item,
  index,
  selectedTimeSlot,
  onPress,
}: {
  item: SlotDetailsType;
  index: number;
  selectedTimeSlot?: AppointmentsType | null;
  onPress: (item: string) => void;
}) => {
  const renderImage = (title: string) => {
    const imageHeight = Matrics.vs(35);
    const imageWidth = Matrics.s(35);
    switch (title) {
      case 'Morning':
        return <Icons.Morning height={imageHeight} width={imageWidth} />;
      case 'Afternoon':
        return <Icons.Afternoon height={imageHeight} width={imageWidth} />;
      case 'Evening':
        return <Icons.Moon height={imageHeight} width={imageWidth} />;
      default:
        return null;
    }
  };

  const onPressTimeSlot = (item: string) => {
    onPress(item);
  };

  const renderSlots = (it: string, index: number) => {
    const selectedTime =
      selectedTimeSlot?.timeZone === item.timeZone &&
      selectedTimeSlot?.time == it;
    return (
      <SlotButton
        title={it}
        onPress={() => onPressTimeSlot(it)}
        buttonStyle={{
          backgroundColor: selectedTime ? colors.boxLightPurple : colors.white,
          borderColor: selectedTime ? colors.darkBorder : colors.lightBorder,
        }}
        titleStyle={
          selectedTime ? styles.activeTimeTxt : styles.inactiveTimeTxt
        }
      />
    );
  };

  return (
    <View style={[styles.container, styles.containerShadow]}>
      {renderImage(item.timeZone)}
      <View
        style={{
          marginLeft: Matrics.s(10),
        }}>
        <Text style={styles.timeZoneTxt}>{item.timeZone}</Text>
        <View style={styles.slotWraper}>{item.slots.map(renderSlots)}</View>
      </View>
    </View>
  );
};

export default SlotDetailsCard;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: colors.white,
    paddingHorizontal: Matrics.s(15),
    paddingTop: Matrics.s(10),
    borderRadius: Matrics.s(12),
    alignItems: 'flex-start',
    marginVertical: Matrics.s(8.5),
    marginHorizontal: Matrics.s(15),
  },
  containerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 3},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
  timeZoneTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    fontWeight: '700',
    color: colors.labelDarkGray,
    marginVertical: Matrics.s(10),
  },
  slotWraper: {
    flexWrap: 'wrap',
    flexDirection: 'row',
    maxWidth: Matrics.s(250),
  },
  activeTimeTxt: {
    color: colors.black,
    fontWeight: '500',
  },
  inactiveTimeTxt: {
    color: colors.inactiveGray,
  },
  timeTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    lineHeight: Matrics.vs(14),
    color: colors.titleLightGray,
  },
  timeContainerSlot: {
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: Matrics.s(12),
    borderWidth: Matrics.s(1),
    paddingHorizontal: Matrics.s(7),
    paddingVertical: Matrics.vs(7),
    marginRight: Matrics.s(10),
    marginBottom: Matrics.vs(10),
  },
  timeContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.04,
    shadowRadius: 3,
    elevation: 1,
  },
});
