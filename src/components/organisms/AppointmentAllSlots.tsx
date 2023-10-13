import {Platform, StyleSheet, Text, View} from 'react-native';
import React, {useCallback, useMemo} from 'react';
import {
  BottomSheetBackdrop,
  BottomSheetBackdropProps,
  BottomSheetModal,
  BottomSheetModalProvider,
} from '@gorhom/bottom-sheet';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {
  AppointmentsType,
  CoachDataType,
  SlotDetailsType,
} from '../../screens/Appointment/AppointmentWithScreen';
import CoachDetailsCard from '../molecules/CoachDetailsCard';
import SlotDetailsCard from '../molecules/SlotDetailsCard';
import Button from '../atoms/Button';
import moment from 'moment';
import {FlatList} from 'react-native-gesture-handler';

const BottomSheetSnapPointValue = '95%';

type AppointmentAllSlotsProps = {
  coachDetails: CoachDataType;
  selectedData: AppointmentsType | null;
  setSelectedData: React.Dispatch<
    React.SetStateAction<AppointmentsType | null>
  >;
  onPress: () => void;
};

const AppointmentAllSlots = React.forwardRef<
  BottomSheetModal,
  AppointmentAllSlotsProps
>(({coachDetails, selectedData, setSelectedData, onPress}, ref) => {
  const snapPoints = useMemo(() => [BottomSheetSnapPointValue], []);

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

  const onPressTimeSlot = (item: string, parentItem: SlotDetailsType) => {
    if (selectedData !== null)
      setSelectedData({
        ...selectedData,
        time: item,
        timeZone: parentItem.timeZone,
      });
  };

  return (
    <BottomSheetModalProvider>
      <BottomSheetModal
        ref={ref}
        backdropComponent={renderBackdrop}
        index={0}
        snapPoints={snapPoints}
        handleIndicatorStyle={styles.handleIndicator}
        backgroundStyle={styles.bottomSheetBackground}>
        <View style={styles.container}>
          <Text style={styles.allSlotTxt}>All Slots</Text>
          <View
            style={[
              styles.seprator,
              {
                marginHorizontal: 0,
              },
            ]}
          />
          <CoachDetailsCard
            data={coachDetails?.coachDetails}
            containerStyle={styles.coachDetailContainer}
            profileImageStyle={styles.coachProfileImage}
          />
          <View style={styles.seprator} />
          <Text style={styles.slotDateTxt}>
            {moment(selectedData?.date).format('DD MMM,YYYY,dddd')}
          </Text>
          <FlatList
            data={coachDetails?.slots}
            renderItem={props => (
              <SlotDetailsCard
                {...props}
                selectedTimeSlot={selectedData}
                onPress={item => onPressTimeSlot(item, props.item)}
              />
            )}
            showsVerticalScrollIndicator={false}
          />
          {selectedData?.date && selectedData?.time ? (
            <View
              style={[
                styles.bottomBtn,
                styles.bottomBtnShadow,
                {
                  marginBottom: Platform.OS == 'android' ? Matrics.s(20) : 0,
                },
              ]}>
              <Button
                disabled={
                  selectedData?.date && selectedData?.time ? false : true
                }
                onPress={onPress}
                title="Save & Next"
                titleStyle={{
                  fontWeight: '700',
                }}
                buttonStyle={{
                  paddingVertical: Matrics.vs(10),
                }}
              />
            </View>
          ) : null}
        </View>
      </BottomSheetModal>
    </BottomSheetModalProvider>
  );
});

export default AppointmentAllSlots;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    marginTop: Matrics.s(6),
    backgroundColor: colors.white,
  },
  allSlotTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(18),
    marginHorizontal: Matrics.s(15),
    fontWeight: '700',
    color: colors.labelDarkGray,
  },
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    ...StyleSheet.absoluteFillObject,
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
  seprator: {
    height: Matrics.vs(0.5),
    backgroundColor: colors.lightGrey,
    marginTop: Matrics.s(12),
    marginHorizontal: Matrics.s(15),
  },
  coachDetailContainer: {
    marginTop: Matrics.s(15),
    alignItems: 'flex-start',
  },
  coachProfileImage: {
    height: Matrics.vs(45),
    width: Matrics.s(45),
  },
  slotDateTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    fontWeight: '600',
    color: colors.labelDarkGray,
    marginHorizontal: Matrics.s(15),
    marginVertical: Matrics.s(15),
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
