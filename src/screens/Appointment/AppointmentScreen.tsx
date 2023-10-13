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
import CommonHeader from '../../components/molecules/CommonHeader';
import AppointmentYourServices from '../../components/organisms/AppointmentYourServices';
import YourBenefits from '../../components/organisms/YourBenefits';
import AppointmentFaqs from '../../components/organisms/AppointmentFaqs';
import {colors} from '../../constants/colors';
import ContactUs from '../../components/molecules/ContactUs';
import {Fonts, Matrics} from '../../constants';
import {
  BottomSheetBackdrop,
  BottomSheetBackdropProps,
  BottomSheetModal,
  BottomSheetModalProvider,
} from '@gorhom/bottom-sheet';
import {Icons} from '../../constants/icons';
import {AppointmentStackParamList} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import UpcomingAppointmentDetails from '../../components/organisms/UpcomingAppointmentDetails';
import Button from '../../components/atoms/Button';

type AppointmentType = {
  id: number;
  title: string;
};

const BottomSheetSnapPointValue = Platform.OS == 'ios' ? '23%' : '26%';

type AppointmentScreenProps = StackScreenProps<
  AppointmentStackParamList,
  'AppointmentScreen'
>;

const AppointmentScreen: React.FC<AppointmentScreenProps> = ({
  route,
  navigation,
}) => {
  const appointmentDetails = route.params?.appointmentDetails;
  console.log(
    '🚀 ~ file: AppointmentScreen.tsx:45 ~ appointmentDetails:',
    appointmentDetails,
  );

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

  const onPressAppointmentType = (type: string) => {
    bottomSheetModalRef.current?.forceClose();
    navigation.navigate('AppointmentWithScreen', {type: type});
  };

  const onPressJoinCall = () => {};

  const onPressRequestCancellation = () => {};

  const renderAppointmentType = (item: AppointmentType, index: number) => {
    const {title, id} = item;
    return (
      <>
        <TouchableOpacity
          onPress={() => onPressAppointmentType(title)}
          style={styles.appointmentItemContainer}>
          <Text style={styles.appointmentTypeTxt}>{title}</Text>
          <Icons.backArrow
            height={Matrics.s(10)}
            width={Matrics.s(10)}
            style={styles.backArrow}
          />
        </TouchableOpacity>
        {typeOfAppointment.length - 1 !== index ? (
          <View style={[styles.itemSeprator, {marginTop: 0}]} />
        ) : null}
      </>
    );
  };

  const renderBackdrop = React.useCallback(
    (props: BottomSheetBackdropProps) => (
      <BottomSheetBackdrop
        {...props}
        opacity={1}
        appearsOnIndex={0}
        disappearsOnIndex={-1}
        style={styles.overlay}
      />
    ),
    [],
  );

  return (
    <View style={styles.container}>
      <CommonHeader
        onPress={() => {
          navigation.goBack();
        }}
        title={'Your Chronic Care Program'}
      />
      <ScrollView showsVerticalScrollIndicator={false}>
        <AppointmentCarePlanCard />
        {appointmentDetails?.id ? (
          <>
            <Text numberOfLines={1} style={styles.upcomingTxt}>
              Upcoming
            </Text>
            <UpcomingAppointmentDetails
              containerStyle={styles.upcomingAppointmentContainer}
              data={appointmentDetails}
              children={
                <View style={styles.upcomingContainer}>
                  <TouchableOpacity
                    activeOpacity={0.5}
                    onPress={onPressRequestCancellation}>
                    <Text style={styles.requestCancelltionTxt}>
                      Request Cancellation
                    </Text>
                  </TouchableOpacity>
                  <Button
                    onPress={onPressJoinCall}
                    buttonStyle={styles.joinCallBtn}
                    titleStyle={styles.joinCallTxt}
                    title="Join Call"
                  />
                </View>
              }
            />
          </>
        ) : null}
        <AppointmentYourServices
          onPress={(id, title) => {
            if (title === 'Book Appoinment') handlePresentModalPress();
          }}
        />
        <YourBenefits />
        <AppointmentFaqs />
        <View style={[styles.bottomBtnContainer]}>
          <ContactUs />
        </View>
      </ScrollView>
      <BottomSheetModalProvider>
        <BottomSheetModal
          ref={bottomSheetModalRef}
          backdropComponent={renderBackdrop}
          index={0}
          snapPoints={snapPoints}
          handleIndicatorStyle={styles.handleIndicator}
          backgroundStyle={styles.bottomSheetBackground}
          onChange={handleSheetChanges}>
          <View style={{flex: 1, marginTop: Matrics.s(6)}}>
            <Text style={styles.bookAppointmentTxt}>Book appointment</Text>
            <View style={styles.itemSeprator} />
            <View style={styles.appointmentTypeContainer}>
              {typeOfAppointment.map(renderAppointmentType)}
            </View>
          </View>
        </BottomSheetModal>
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
    fontSize: Matrics.mvs(19),
    fontWeight: '600',
    color: colors.black,
    paddingHorizontal: Matrics.s(20),
    marginTop: Matrics.s(2),
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
    paddingVertical: Matrics.s(14),
  },
  appointmentTypeTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    color: colors.labelDarkGray,
  },
  handleIndicator: {
    width: Matrics.s(40),
    backgroundColor: colors.lightGrey,
    opacity: 0.5,
  },
  bottomSheetBackground: {
    borderTopLeftRadius: Matrics.s(20),
    borderTopRightRadius: Matrics.s(20),
  },
  backArrow: {
    transform: [{rotate: '180deg'}],
    marginRight: Matrics.s(5),
    colors: colors.darkLightGray,
  },
  upcomingTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(15),
    fontWeight: '600',
    color: colors.black,
    marginHorizontal: Matrics.s(15),
    marginVertical: Matrics.vs(10),
    marginTop: Matrics.s(25),
  },
  upcomingContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginHorizontal: Matrics.s(15),
    marginTop: Matrics.s(20),
  },
  requestCancelltionTxt: {
    textAlign: 'center',
    marginHorizontal: Matrics.s(20),
    color: colors.themePurple,
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(12),
    fontWeight: '600',
  },
  joinCallBtn: {
    paddingHorizontal: Matrics.s(35),
    paddingVertical: Matrics.vs(9),
    borderRadius: Matrics.s(15),
  },
  joinCallTxt: {
    fontSize: Matrics.mvs(12),
    fontWeight: '700',
  },
  upcomingAppointmentContainer: {
    marginBottom: Matrics.s(10),
    paddingBottom: Matrics.s(15),
  },
});
