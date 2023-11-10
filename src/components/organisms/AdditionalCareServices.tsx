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
import {useApp} from '../../context/app.context';
type AdditionalServicesProps = {
  onPressConsultNutritionist: () => void;
  onPressConsultPhysio: (type: 'HC' | 'D') => void;
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
  const {userData} = useApp();

  const showDoctorButton: boolean = !!userData?.patient_guid ?? false;

  const options: AdditionalServicesItem[] = [
    {
      title: 'Consult\nNutritionist',
      onPress: onPressConsultNutritionist,
    },
    {
      title: 'Consult\nPhysio',
      onPress: () => onPressConsultPhysio('HC'),
    },
    {
      title: 'Book\nDiagnostic',
      onPress: onPressBookDiagnostic,
    },
    {
      title: 'Book\nDevices',
      onPress: onPressBookDevices,
    },
  ];

  let doctorButton: AdditionalServicesItem = {
    title: 'Doctor\nAppointment',
    onPress: () => onPressConsultPhysio('D'),
  };
  if (showDoctorButton) {
    options.push(doctorButton);
  }

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
      <ScrollView
        horizontal
        style={styles.itemsContainer}
        contentContainerStyle={{paddingLeft: 16}}
        showsHorizontalScrollIndicator={false}>
        {options.map(renderServiceItem)}
      </ScrollView>
    </View>
  );
};

export default AdditionalCareServices;

const styles = StyleSheet.create({
  container: {
    marginTop: 24,
  },
  title: {
    fontSize: 16,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.black,
    marginLeft: 16,
  },
  itemsContainer: {
    paddingVertical: 16,
  },
  serviceItemContainer: {
    // flex: 1,
    gap: 5,
    marginRight: 10,
    height: 110,
    width: 75,
    shadowColor: '#212121',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
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
    fontFamily: 'SFProDisplay-Regular',
    color: colors.inputValueDarkGray,
    lineHeight: 16.71,
    textAlign: 'center',
  },
});
