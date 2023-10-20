import React, {
  forwardRef,
  SetStateAction,
  useEffect,
  useImperativeHandle,
  useState,
} from 'react';
import {
  BottomSheetModalProvider,
  BottomSheetModal,
  BottomSheetModalProps,
} from '@gorhom/bottom-sheet';
import {StyleSheet, Text, TextInput, View} from 'react-native';
import {Icons} from '../../constants/icons';
import Button from '../atoms/Button';
import {colors} from '../../constants/colors';
import {Matrics} from '../../constants';
import fonts from '../../constants/fonts';

type LoginBottomSheetProps = {
  onPressContinue: (mobileNumber: string) => void;
};

export type LoginBottomSheetRef = {
  show: () => void;
  hide: () => void;
};

const LoginBottomSheet = forwardRef<LoginBottomSheetRef, LoginBottomSheetProps>(
  ({onPressContinue = () => {}}, ref) => {
    const bottomSheetModalRef = React.useRef<BottomSheetModal>(null);
    // Expose methods using useImperativeHandle
    useImperativeHandle(ref, () => ({
      show: () => {
        bottomSheetModalRef.current?.present();
        setMobileNumber('');
      },
      hide: () => {
        bottomSheetModalRef.current?.dismiss();
        setMobileNumber('');
      },
    }));
    const [mobileNumber, setMobileNumber] = React.useState<string>('');

    const onChangeText = (text: string) => {
      setMobileNumber(text);
    };

    return (
      <BottomSheetModalProvider>
        <BottomSheetModal
          ref={bottomSheetModalRef}
          backdropComponent={() => <View style={styles.overlay} />}
          handleIndicatorStyle={{
            backgroundColor: '#E0E0E0',
            width: Matrics.s(45),
            height: Matrics.vs(4),
          }}
          index={0}
          snapPoints={['85%']}
          enablePanDownToClose={true}
          // enableContentPanningGesture={false}
          keyboardBehavior="interactive"
          backgroundStyle={styles.container}>
          <View style={[styles.sheetContainer, styles.smallHeight]}>
            <>
              <Text
                style={
                  styles.loginTitle
                }>{`Login or signup to your account`}</Text>
              <Text
                style={
                  styles.loginDesc
                }>{`Enter your number to receive a One Time Password.`}</Text>
              <View style={styles.inputRowCont}>
                <Icons.FlagIcon />
                <View style={{flex: 1, paddingHorizontal: Matrics.s(12)}}>
                  <Text style={styles.inputTitle}>{`Mobile Number`}</Text>
                  <View style={styles.inputContainer}>
                    <Text style={styles.contryCode}>{`+91`}</Text>
                    <TextInput
                      style={styles.inputWrapper}
                      keyboardType="number-pad"
                      maxLength={10}
                      autoFocus={true}
                      onBlur={() => bottomSheetModalRef.current?.snapToIndex(0)}
                      onFocus={() => bottomSheetModalRef.current?.expand()}
                      onChangeText={onChangeText}
                    />
                  </View>
                </View>
              </View>
              <Button
                title="Continue"
                buttonStyle={{marginVertical: Matrics.vs(20)}}
                disabled={mobileNumber.length < 10}
                onPress={() => onPressContinue(mobileNumber)}
              />
            </>
          </View>
        </BottomSheetModal>
      </BottomSheetModalProvider>
    );
  },
);

export default LoginBottomSheet;

const styles = StyleSheet.create({
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    ...StyleSheet.absoluteFillObject,
  },
  container: {
    borderTopRightRadius: Matrics.mvs(20),
    borderTopLeftRadius: Matrics.mvs(20),
  },
  sheetContainer: {
    width: '100%',
    paddingHorizontal: Matrics.s(22),
  },
  smallHeight: {
    height: '40%',
  },
  loginTitle: {
    color: colors.labelDarkGray,
    fontFamily: fonts.BOLD,
    fontSize: Matrics.mvs(24),
    marginTop: Matrics.vs(24),
  },
  loginDesc: {
    color: colors.subTitleLightGray,
    fontFamily: fonts.REGULAR,
    fontSize: Matrics.mvs(14),
    marginTop: Matrics.vs(12),
  },
  inputTitle: {
    color: colors.subTitleLightGray,
    fontFamily: fonts.REGULAR,
    fontSize: Matrics.mvs(10),
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: Matrics.vs(2),
  },
  inputRowCont: {
    flexDirection: 'row',
    height: Matrics.vs(44),
    borderRadius: Matrics.mvs(12),
    borderWidth: 1,
    borderColor: colors.inputBoxDarkBorder,
    marginTop: Matrics.vs(24),
    alignItems: 'center',
    paddingLeft: Matrics.s(16),
  },
  contryCode: {
    color: colors.inputValueDarkGray,
    fontFamily: fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
  },
  inputWrapper: {
    color: colors.inputValueDarkGray,
    fontFamily: fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    flex: 1,
    paddingLeft: Matrics.s(4),
    paddingTop: 0,
    paddingBottom: 0,
  },
});
