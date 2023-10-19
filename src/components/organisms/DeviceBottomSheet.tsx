import {Image, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import Button from '../atoms/Button';
import {EdgeInsets} from 'react-native-safe-area-context';

type DeviceBottomSheetProps = {
  device: string;
  onPressCancel: () => void;
  onPressAccept: () => void;
  insets: EdgeInsets;
};

const DeviceBottomSheet: React.FC<DeviceBottomSheetProps> = ({
  device,
  onPressAccept,
  onPressCancel,
  insets,
}) => {
  return (
    <View style={styles.bottomSheetContainer}>
      <View style={styles.deviceDetailsContainer}>
        <Image
          source={require('../../assets/images/LungAnalyser.png')}
          style={styles.deviceFunctionalityImg}
          resizeMode="contain"
        />
        <Text style={styles.deviceTxt}>{device}</Text>
        <Text numberOfLines={4} style={styles.deviceDesTxt}>
          This portable medical device can assist you in monitoring your lung
          health. By keeping track of your condition, it can help prevent
          attacks and minimise the need for hospital visits.
        </Text>
        <Text numberOfLines={1} style={styles.questionTxt}>
          Do you have the device to monitor your lung health?
        </Text>
      </View>
      <View
        style={[
          styles.bottomSheetBtnContainer,
          styles.bottomSheetContainerShadow,
          {
            paddingBottom: insets.bottom != 0 ? insets.bottom : Matrics.vs(16),
          },
        ]}>
        <Button
          onPress={onPressCancel}
          title="No, Purchase"
          buttonStyle={styles.noPurchaseBtn}
          titleStyle={styles.noPurchaseTxt}
        />
        <Button
          onPress={onPressAccept}
          title="Yes, Connect"
          buttonStyle={styles.yesConnectBtn}
          titleStyle={styles.yesConnectTxt}
        />
      </View>
    </View>
  );
};

export default DeviceBottomSheet;

const styles = StyleSheet.create({
  bottomSheetContainer: {flex: 1, backgroundColor: colors.white},

  deviceDetailsContainer: {
    flex: 1,
    paddingHorizontal: Matrics.s(15),
    paddingVertical: Matrics.s(15),
  },
  deviceFunctionalityImg: {
    height: Matrics.s(80),
    width: Matrics.s(80),
  },
  deviceTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    color: colors.labelDarkGray,
    marginTop: Matrics.vs(11),
  },
  deviceDesTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '400',
    color: colors.subTitleLightGray,
    marginVertical: Matrics.vs(10),
  },
  questionTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    fontWeight: '400',
    color: colors.subTitleLightGray,
  },
  bottomSheetBtnContainer: {
    flexDirection: 'row',
    backgroundColor: colors.white,
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: Matrics.s(15),
    paddingTop: Matrics.vs(10),
  },
  bottomSheetContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.1,
    shadowRadius: 10,
    elevation: 3,
  },
  noPurchaseBtn: {
    paddingVertical: Matrics.vs(9),
    paddingHorizontal: Matrics.s(25),
    backgroundColor: colors.white,
    borderWidth: Matrics.s(1),
    borderColor: colors.themePurple,
    borderRadius: Matrics.s(19),
    marginHorizontal: 0,
    height: Matrics.vs(40),
  },
  noPurchaseTxt: {
    color: colors.themePurple,
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    lineHeight: Matrics.vs(20),
  },
  yesConnectTxt: {
    color: colors.white,
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    lineHeight: Matrics.vs(20),
  },
  yesConnectBtn: {
    paddingVertical: Matrics.vs(9),
    paddingHorizontal: Matrics.s(25),
    borderRadius: Matrics.s(19),
    marginHorizontal: 0,
    height: Matrics.vs(40),
  },
});
