import {Image, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import Button from '../atoms/Button';
import {EdgeInsets} from 'react-native-safe-area-context';

type AlertBottomSheetProps = {
  onPressCancel: () => void;
  onPressAccept: () => void;
  insets: EdgeInsets;
  title: string;
  rightButtonTitle?: string;
  leftButtonTitle?: string;
};

const AlertBottomSheet: React.FC<AlertBottomSheetProps> = ({
  onPressAccept,
  onPressCancel,
  insets,
  title,
  rightButtonTitle = 'Yes',
  leftButtonTitle = 'No',
}) => {
  return (
    <View style={styles.bottomSheetContainer}>
      <View style={styles.deviceDetailsContainer}>
        <Text numberOfLines={4} style={styles.deviceTxt}>
          {title}
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
          title={leftButtonTitle}
          buttonStyle={styles.noPurchaseBtn}
          titleStyle={styles.noPurchaseTxt}
        />

        <Button
          onPress={onPressAccept}
          title={rightButtonTitle}
          buttonStyle={styles.yesConnectBtn}
          titleStyle={styles.yesConnectTxt}
        />
      </View>
    </View>
  );
};

export default AlertBottomSheet;

const styles = StyleSheet.create({
  bottomSheetContainer: {flex: 1, backgroundColor: colors.white},

  deviceDetailsContainer: {
    flex: 1,
    paddingHorizontal: Matrics.s(24),
    // paddingVertical: Matrics.s(15),
    justifyContent: 'center',
  },
  deviceFunctionalityImg: {
    height: Matrics.s(80),
    width: Matrics.s(80),
  },
  deviceTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(16),
    // fontWeight: '700',
    textAlign: 'center',
    color: colors.labelDarkGray,
    // marginTop: Matrics.vs(11),
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
    // backgroundColor: colors.white,
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: Matrics.s(15),
    paddingTop: Matrics.vs(10),
    marginBottom: Matrics.vs(12),
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
    // paddingHorizontal: Matrics.s(25),
    backgroundColor: colors.white,
    borderWidth: Matrics.s(1),
    borderColor: colors.themePurple,
    borderRadius: Matrics.s(19),
    marginHorizontal: 0,
    height: Matrics.vs(40),
    width: '45%',
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
    width: '45%',
  },
});
