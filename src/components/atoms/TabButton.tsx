import {StyleSheet, Text, View, ViewStyle} from 'react-native';
import React, {useState} from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import Button from './Button';

type TabButtonProps = {
  containerStyle?: ViewStyle;
  btnTitles: string[];
};

const TabButton: React.FC<TabButtonProps> = ({btnTitles}) => {
  const [selectedBtn, setSelectedBtn] = useState<string>(btnTitles[0]);

  const renderBtn = (item: string) => {
    const itemSelected = item == selectedBtn;
    const selectedBtnStyle = itemSelected
      ? styles.activeBtn
      : styles.inActiveBtn;
    const selectedBtnTxtStyle = itemSelected
      ? styles.activeBtn
      : styles.inActiveBtn;
    return (
      <Button
        title="Feet"
        buttonStyle={{
          ...styles.btnCommonContainer,
          ...styles.activeBtn,
        }}
        titleStyle={{
          fontFamily: Fonts.BOLD,
          fontSize: Matrics.mvs(16),
          fontWeight: '700',
          lineHeight: Matrics.vs(20),
          color: colors.labelDarkGray,
        }}
      />
    );
  };

  return (
    <View style={[styles.container, styles.containerShadow]}>
      {btnTitles.map(renderBtn)}
      {/* <Button
        title="Feet"
        buttonStyle={{
          ...styles.btnCommonContainer,
          ...styles.activeBtn,
        }}
        titleStyle={{
          fontFamily: Fonts.BOLD,
          fontSize: Matrics.mvs(16),
          fontWeight: '700',
          lineHeight: Matrics.vs(20),
          color: colors.labelDarkGray,
        }}
      />
      <Button
        title="cm"
        buttonStyle={{
          ...styles.btnCommonContainer,
          ...styles.inActiveBtn,
        }}
        titleStyle={{
          color: colors.darkGray,
          ...styles.btnTxtCommon,
        }}
      /> */}
    </View>
  );
};

export default TabButton;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.white,
    borderRadius: Matrics.mvs(12),
    borderWidth: Matrics.s(1),
    borderColor: colors.inputBoxLightBorder,
    overflow: 'hidden',
  },
  containerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
  btnCommonContainer: {
    width: '50%',
    borderWidth: Matrics.s(1),
    paddingVertical: Matrics.vs(8),
    borderRadius: Matrics.mvs(12),
  },
  btnTxtCommon: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    lineHeight: Matrics.vs(20),
  },
  activeBtn: {
    backgroundColor: colors.boxLightPurple,
    borderColor: colors.themePurple,
  },
  inActiveBtn: {
    borderWidth: 0,
    backgroundColor: colors.white,
  },
  activeBtnTxt: {
    color: colors.labelDarkGray,
  },
  inActiveBtnTxt: {},
});
