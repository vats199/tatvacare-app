import {StyleSheet, Text, View} from 'react-native';
import React, {useState} from 'react';
import IconButton from '../atoms/IconButton';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import {Fonts, Matrics} from '../../constants';

type DeviceConnectGenderButtonsPorps = {
  onPress: (value: string) => void;
  error?: string;
};

const DeviceConnectGenderButtons: React.FC<DeviceConnectGenderButtonsPorps> = ({
  onPress,
  error,
}) => {
  const [isMale, setIsMale] = useState<boolean>(true);

  const onPressGenderBtn = (value: string) => {
    setIsMale(value == 'Male' ? true : false);
    onPress(value);
  };

  return (
    <>
      <Text style={styles.biologicalSexTxt}>Biological Sex*</Text>
      <View style={styles.genderBtnsContainer}>
        <IconButton
          onPressBtn={() => onPressGenderBtn('Male')}
          containetStyle={{
            backgroundColor: isMale ? colors.genderActiveButton : colors.white,
            borderColor: isMale
              ? colors.genderActiveButtonBorder
              : colors.genderInactiveButtonBorder,
            ...styles.genderBtnContainer,
          }}
          style={styles.genderBtnTxt}
          title="Male"
          leftIcon={
            <Icons.Male
              height={Matrics.mvs(24)}
              weight={Matrics.mvs(24)}
              style={styles.genderIcon}
            />
          }
        />
        <IconButton
          onPressBtn={() => onPressGenderBtn('Female')}
          containetStyle={{
            backgroundColor: isMale ? colors.white : colors.genderActiveButton,

            borderColor: isMale
              ? colors.genderInactiveButtonBorder
              : colors.genderActiveButtonBorder,
            ...styles.genderBtnContainer,
          }}
          style={styles.genderBtnTxt}
          title="Female"
          leftIcon={
            <Icons.Female
              height={Matrics.mvs(24)}
              weight={Matrics.mvs(24)}
              style={styles.genderIcon}
            />
          }
        />
      </View>
      {error ? <Text style={styles.errorTxt}>{error}</Text> : null}
    </>
  );
};

export default DeviceConnectGenderButtons;

const styles = StyleSheet.create({
  genderBtnContainer: {
    padding: Matrics.s(8),
    width: Matrics.s(150),
    borderRadius: Matrics.s(10),
    borderWidth: Matrics.s(1),
    marginHorizontal: 0,
    marginTop: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  genderBtnTxt: {
    marginHorizontal: 0,
    marginLeft: 0,
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    color: colors.disableButton,
    fontWeight: '600',
  },
  genderIcon: {
    marginRight: Matrics.s(5),
  },
  genderBtnsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  biologicalSexTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    fontWeight: '700',
    color: colors.labelDarkGray,
    lineHeight: Matrics.vs(18),
    marginVertical: Matrics.vs(10),
  },
  errorTxt: {
    color: colors.red,
    marginTop: Matrics.vs(5),
  },
});
