import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';

type AppointmentYourServicesItem = {
  id: number;
  title: string;
  description: string;
};

interface AppointmentYourServicesProps {
  onPress: (id: number, title: string) => void;
}

const AppointmentYourServices: React.FC<AppointmentYourServicesProps> = ({
  onPress,
}) => {
  const yourServices: AppointmentYourServicesItem[] = [
    {
      id: 1,
      title: 'Book Lab Test',
      description: 'Select date & Time For Sample Collection',
    },
    {
      id: 2,
      title: 'Book Appoinment',
      description: 'With Nutritionist & Physiotherapist',
    },
    {
      id: 3,
      title: 'Devices',
      description: 'View All Health Details',
    },
  ];

  const renderIcon = (title: string) => {
    switch (title) {
      case 'Book Lab Test':
        return <Icons.RoundLab />;
      case 'Book Appoinment':
        return <Icons.RoundCalendar />;
      case 'Devices':
        return <Icons.HealthDiaryDevices />;
      default:
        break;
    }
  };

  const onPressItem = (id: number, title: string) => {
    onPress(id, title);
  };

  const renderItem = ({
    item,
    index,
  }: {
    item: AppointmentYourServicesItem;
    index: number;
  }) => {
    const {title, description, id} = item;
    return (
      <TouchableOpacity
        key={index.toString()}
        style={styles.servicesItemContainer}
        onPress={() => onPressItem(id, title)}
        activeOpacity={0.7}>
        {renderIcon(title)}
        <View style={styles.textContainer}>
          <Text style={styles.text}>{title}</Text>
          <Text style={styles.subText}>{description}</Text>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <Text numberOfLines={1} style={styles.servicesTxt}>
        Your Services
      </Text>
      <FlatList
        data={yourServices}
        scrollEnabled={false}
        renderItem={renderItem}
        style={styles.servicesListContainer}
      />
    </View>
  );
};

export default AppointmentYourServices;

const styles = StyleSheet.create({
  container: {
    marginVertical: Matrics.s(15),
    marginHorizontal: Matrics.s(17),
  },
  servicesTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(15),
    fontWeight: '600',
    color: colors.black,
  },
  servicesListContainer: {
    marginTop: Matrics.vs(5),
  },
  servicesItemContainer: {
    marginVertical: Matrics.s(4),
    padding: Matrics.s(10),
    backgroundColor: colors.white,
    borderRadius: Matrics.s(12),
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: Matrics.vs(13),
  },
  textContainer: {
    marginLeft: Matrics.s(10),
  },
  text: {
    fontSize: Matrics.mvs(14),
    fontWeight: '700',
    color: colors.labelDarkGray,
  },
  subText: {
    fontSize: Matrics.mvs(11),
    fontWeight: '300',
    color: colors.subTitleLightGray,
  },
});
