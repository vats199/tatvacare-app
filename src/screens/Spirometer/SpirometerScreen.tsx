import {
  Image,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import React, {useCallback, useMemo, useRef, useState} from 'react';
import {colors} from '../../constants/colors';
import SpirometerHeader from '../../components/molecules/SpirometerHeader';
import {Fonts, Matrics} from '../../constants';
import AppointmentCarePlanCard from '../../components/molecules/AppointmentCarePlanCard';
import {Icons} from '../../constants/icons';
import MyCare from '../../components/organisms/MyCare';
import MyDevices from '../../components/organisms/MyDevices';
import DailySummaryView from '../../components/organisms/DailySummaryView';
import {BottomSheetModal} from '@gorhom/bottom-sheet';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import DeviceBottomSheet from '../../components/organisms/DeviceBottomSheet';
import {
  AppStackParamList,
  HomeStackParamList,
} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import {CompositeScreenProps} from '@react-navigation/native';

type SpirometerScreenProps = CompositeScreenProps<
  StackScreenProps<AppStackParamList>,
  StackScreenProps<HomeStackParamList>
>;

const SpirometerScreen: React.FC<SpirometerScreenProps> = ({
  navigation,
  route,
}) => {
  const [selectedItem, setSelectedItem] = useState<string>('');

  const bottomSheetModalRef = useRef<BottomSheetModal>(null);

  const onPressConnect = (title: string) => {
    setSelectedItem(title);
    bottomSheetModalRef.current?.present();
  };

  const onPressAccept = () => {
    bottomSheetModalRef.current?.forceClose();
    navigation.navigate('DeviceConnectionScreen');
  };

  const onPressCancel = () => {
    bottomSheetModalRef.current?.forceClose();
  };

  return (
    <View style={styles.container}>
      <SpirometerHeader />
      <ScrollView>
        <View style={styles.dailySummaryContainer}>
          <Text style={styles.DailySummaryTxt}>Your Daily Summary</Text>
          <Icons.Info height={Matrics.s(20)} width={Matrics.s(20)} />
        </View>
        <DailySummaryView />
        <AppointmentCarePlanCard
          containerStyle={styles.appointmentCarePlanCardContainer}
        />
        <MyCare />
        <MyDevices onPress={onPressConnect} />
      </ScrollView>
      <CommonBottomSheetModal snapPoints={['48%']} ref={bottomSheetModalRef}>
        <DeviceBottomSheet
          device={selectedItem}
          onPressAccept={onPressAccept}
          onPressCancel={onPressCancel}
        />
      </CommonBottomSheetModal>
    </View>
  );
};

export default SpirometerScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
  },
  dailySummaryContainer: {
    flexDirection: 'row',
    paddingHorizontal: Matrics.s(15),
    marginVertical: Matrics.s(10),
    alignItems: 'center',
  },
  DailySummaryTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(15),
    fontWeight: '700',
    lineHeight: Matrics.vs(20),
    color: colors.inputValueDarkGray,
    marginRight: Matrics.s(10),
  },

  appointmentCarePlanCardContainer: {
    marginHorizontal: Matrics.s(15),
    marginTop: Matrics.vs(12),
  },
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    ...StyleSheet.absoluteFillObject,
  },
});
