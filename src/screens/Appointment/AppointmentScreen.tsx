import React, {useCallback, useMemo, useRef} from 'react';
import {
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import AppointmentCarePlanCard from '../../components/molecules/AppointmentCarePlanCard';
import AppointmentHeader from '../../components/molecules/AppointmentHeader';
import AppointmentYourServices from '../../components/organisms/AppointmentYourServices';
import YourBenefits from '../../components/organisms/YourBenefits';
import AppointmentFaqs from '../../components/organisms/AppointmentFaqs';
import {colors} from '../../constants/colors';
import ContactUs from '../../components/molecules/ContactUs';
import {Fonts, Matrics} from '../../constants';
import {BottomSheetModal, BottomSheetModalProvider} from '@gorhom/bottom-sheet';
import {Icons} from '../../constants/icons';
import {CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {AppStackParamList} from '../../interface/Navigation.interface';

type AppointmentType = {
  id: number;
  title: string;
};

const BottomSheetSnapPointValue = Platform.OS == 'ios' ? '23%' : '26%';

type AppointmentScreenProps = StackScreenProps<AppStackParamList>;

const AppointmentScreen: React.FC<AppointmentScreenProps> = ({
  route,
  navigation,
}) => {
  const typeOfAppointment = [
    {
      id: 1,
      title: 'Nutritionist',
    },
    {
      id: 2,
      title: 'Physiotherapist',
    },
  ];

  const bottomSheetModalRef = useRef<BottomSheetModal>(null);

  const snapPoints = useMemo(() => [BottomSheetSnapPointValue], []);

  const handlePresentModalPress = useCallback(() => {
    bottomSheetModalRef.current?.present();
  }, []);

  const handleSheetChanges = useCallback((index: number) => {
    console.log('handleSheetChanges', index);
  }, []);

  const pressAppointmentType = (type: string) => {
    bottomSheetModalRef.current?.forceClose();
    navigation.navigate('AppointmentWithScreen', {type: type});
  };

  const renderAppointmentType = (item: AppointmentType, index: number) => {
    const {title, id} = item;
    return (
      <>
        <TouchableOpacity
          onPress={() => pressAppointmentType(title)}
          style={styles.appointmentItemContainer}>
          <Text style={styles.appointmentTypeTxt}>{title}</Text>
          <Icons.backArrow
            height={Matrics.s(10)}
            width={Matrics.s(10)}
            style={{
              transform: [{rotate: '180deg'}],
            }}
          />
        </TouchableOpacity>
        {typeOfAppointment.length - 1 !== index ? (
          <View style={[styles.itemSeprator, {marginTop: 0}]} />
        ) : null}
      </>
    );
  };

  return (
    <View style={styles.container}>
      <AppointmentHeader
        onPress={() => {
          navigation.goBack();
        }}
        title={'Your Chronic Care Program'}
      />
      <ScrollView showsVerticalScrollIndicator={false}>
        <AppointmentCarePlanCard />
        <AppointmentYourServices
          onPress={(id, title) => {
            if (title === 'Book Appoinment') handlePresentModalPress();
          }}
        />
        <YourBenefits />
        <AppointmentFaqs />
        <View style={styles.bottomBtnContainer}>
          <ContactUs />
        </View>
      </ScrollView>
      <BottomSheetModalProvider>
        <View style={styles.container}>
          <BottomSheetModal
            ref={bottomSheetModalRef}
            backdropComponent={() => <View style={styles.overlay} />}
            index={0}
            snapPoints={snapPoints}
            handleIndicatorStyle={styles.handleIndicator}
            onChange={handleSheetChanges}>
            <View style={{flex: 1, marginTop: Matrics.s(6)}}>
              <Text style={styles.bookAppointmentTxt}>Book appointment</Text>
              <View style={styles.itemSeprator} />
              <View style={styles.appointmentTypeContainer}>
                {typeOfAppointment.map(renderAppointmentType)}
              </View>
            </View>
          </BottomSheetModal>
        </View>
      </BottomSheetModalProvider>
    </View>
  );
};

export default AppointmentScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
  },
  bottomBtnContainer: {
    backgroundColor: colors.white,
    paddingTop: Matrics.s(15),
    paddingBottom: Matrics.s(Platform.OS == 'ios' ? 15 : 30),
  },
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    ...StyleSheet.absoluteFillObject,
  },
  bookAppointmentTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(20),
    fontWeight: '600',
    color: colors.black,
    paddingHorizontal: Matrics.s(20),
  },
  itemSeprator: {
    height: Matrics.s(1),
    backgroundColor: colors.darkGray,
    marginTop: Matrics.s(10),
    opacity: 0.5,
  },
  appointmentTypeContainer: {
    paddingHorizontal: Matrics.s(20),
  },
  appointmentItemContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: Matrics.s(12),
  },
  appointmentTypeTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(15),
    color: colors.labelDarkGray,
  },
  handleIndicator: {
    width: Matrics.s(40),
    backgroundColor: colors.lightGrey,
    opacity: 0.5,
  },
});
