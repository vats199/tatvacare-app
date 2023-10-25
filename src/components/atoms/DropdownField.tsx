import {
  Image,
  ImageSourcePropType,
  ImageStyle,
  StyleSheet,
  Text,
  TextStyle,
  TouchableOpacity,
  View,
  ViewStyle,
} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';

type DropdownFieldProps = {
  value: string;
  title: string;
  error?: string;
  onPress: () => void;
  containerStyle?: ViewStyle;
  titleTxtStyle?: TextStyle;
  subTitleTxtStyle?: TextStyle;
  icon?: ImageSourcePropType;
  iconStyle?: ImageStyle;
};

const DropdownField: React.FC<DropdownFieldProps> = ({
  title,
  value,
  error = '',
  onPress,
  containerStyle,
  icon,
  iconStyle,
  subTitleTxtStyle,
  titleTxtStyle,
}) => {
  const haveValue = value !== '';
  const haveError = error !== '';
  return (
    <>
      <TouchableOpacity
        activeOpacity={0.8}
        onPress={onPress}
        style={[
          styles.container,
          styles.containerShadow,
          {
            paddingVertical: Matrics.vs(haveValue ? 5 : 12),
            borderColor: haveError
              ? 'red'
              : haveValue
              ? colors.disableButton
              : colors.inputBoxLightBorder,
          },
          containerStyle,
        ]}>
        <View>
          <Text
            style={[
              styles.titleTxt,
              {
                fontSize: Matrics.mvs(haveValue ? 10 : 14),
                lineHeight: Matrics.vs(haveValue ? 12 : 18),
                color: haveValue ? colors.disableButton : colors.darkGray,
              },
              titleTxtStyle,
            ]}>
            {title}
          </Text>
          {value !== '' ? (
            <Text
              style={[
                styles.valueTxt,
                {
                  color: haveValue ? colors.disableButton : colors.darkGray,
                },
                subTitleTxtStyle,
              ]}>
              {value}
            </Text>
          ) : null}
        </View>
        <Image
          source={icon ?? require('../../assets/images/downArrow.png')}
          style={[styles.downArrowIcon, iconStyle]}
          resizeMode="contain"
        />
      </TouchableOpacity>
      {error ? <Text style={styles.errorTxt}>{error}</Text> : null}
    </>
  );
};

export default DropdownField;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: Matrics.s(10),
    justifyContent: 'space-between',
    backgroundColor: colors.white,
    paddingHorizontal: Matrics.s(15),
    borderRadius: Matrics.s(12),
    borderWidth: Matrics.s(1),
  },
  containerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.05,
    shadowRadius: 3,
    elevation: 2,
  },
  titleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontWeight: '400',
    color: colors.darkGray,
  },
  valueTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    fontWeight: '600',
    lineHeight: Matrics.vs(18),
    color: colors.darkGray,
  },
  downArrowIcon: {
    height: Matrics.mvs(16),
    width: Matrics.mvs(16),
  },
  errorTxt: {
    marginHorizontal: Matrics.s(5),
    color: colors.red,
  },
});
