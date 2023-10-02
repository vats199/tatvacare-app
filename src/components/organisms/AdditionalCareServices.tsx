import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
type AdditionalServicesProps = {
  onPressConsultNutritionist: () => void;
  onPressConsultPhysio: () => void;
  onPressBookDiagnostic: () => void;
  onPressBookDevices: () => void;
};

type AdditionalServicesItem = {
  title:
    | 'Consult\nNutritionist'
    | 'Consult\nPhysio'
    | 'Book\nDiagnostic'
    | 'Book\nDevices'
    | 'Doctor\nAppointment';
  onPress: () => void;
};

const AdditionalCareServices: React.FC<AdditionalServicesProps> = ({
  onPressConsultNutritionist,
  onPressConsultPhysio,
  onPressBookDiagnostic,
  onPressBookDevices,
}) => {
  const options: AdditionalServicesItem[] = [
    {
      title: 'Consult\nNutritionist',
      onPress: onPressConsultNutritionist,
    },
    {
      title: 'Consult\nPhysio',
      onPress: onPressConsultPhysio,
    },
    {
      title: 'Book\nDiagnostic',
      onPress: onPressBookDiagnostic,
    },
    {
      title: 'Book\nDevices',
      onPress: onPressBookDevices,
    },
    {
      title: 'Doctor\nAppointment',
      onPress: onPressConsultPhysio,
    },
  ];

  const renderIcon = (
    title:
      | 'Consult\nNutritionist'
      | 'Consult\nPhysio'
      | 'Book\nDiagnostic'
      | 'Book\nDevices'
      | 'Doctor\nAppointment',
  ) => {
    switch (title) {
      case 'Consult\nNutritionist':
        return <Icons.ServicesNutritionist />;
      case 'Consult\nPhysio':
        return <Icons.ServicesPhysio />;
      case 'Book\nDiagnostic':
        return <Icons.ServicesDiagnostic />;
      case 'Book\nDevices':
        return <Icons.ServicesDevices />;
      case 'Doctor\nAppointment':
        return <Icons.ServicesPhysio />;
    }
  };

  const renderServiceItem = (item: AdditionalServicesItem, index: number) => {
    const {title, onPress} = item;
    return (
      <TouchableOpacity
        key={index.toString()}
        onPress={onPress}
        activeOpacity={0.7}
        style={styles.serviceItemContainer}>
        <View style={styles.iconContainer}>{renderIcon(title)}</View>
        <Text style={styles.text}>{title}</Text>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Additional Care Services</Text>
      <ScrollView horizontal style={styles.itemsContainer}>
        {options.map(renderServiceItem)}
      </ScrollView>
    </View>
  );
};

export default AdditionalCareServices;

const styles = StyleSheet.create({
  container: {
    marginVertical: 10,
  },
  title: {
    fontSize: 16,
    fontWeight: '700',
    color: colors.black,
  },
  itemsContainer: {
    paddingVertical: 10,
  },
  serviceItemContainer: {
    // flex: 1,
    gap: 5,
    marginRight: 10,
    height: 110,
    width: 75,
  },
  iconContainer: {
    backgroundColor: colors.white,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    minHeight: 70,
  },
  text: {
    fontSize: 12,
    fontWeight: '500',
    color: colors.inputValueDarkGray,
    lineHeight: 16.71,
    textAlign: 'center',
  },
});
