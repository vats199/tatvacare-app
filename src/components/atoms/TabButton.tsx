import {
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewStyle,
} from 'react-native';
import React, {useState} from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import Button from './Button';
import SlotButton from './SlotButton';

type TabButtonProps = {
  containerStyle?: ViewStyle;
  btnTitles: string[];
};

const TabButton: React.FC<TabButtonProps> = ({btnTitles, containerStyle}) => {
  const [selectedBtn, setSelectedBtn] = useState<string>(btnTitles[0]);

  const onPressTabBtn = (item: string) => {
    setSelectedBtn(item);
  };

  const renderBtn = (item: string) => {
    const itemSelected = item == selectedBtn;
    const selectedBtnStyle = itemSelected
      ? styles.activeBtn
      : styles.inActiveBtn;
    const selectedBtnTxtStyle = itemSelected
      ? styles.activeBtnTxt
      : styles.inActiveBtnTxt;
    return (
      <SlotButton
        onPress={() => onPressTabBtn(item)}
        title={item}
        buttonStyle={{
          ...styles.btnCommonContainer,
          ...selectedBtnStyle,
        }}
        titleStyle={{...styles.btnTxtCommon, ...selectedBtnTxtStyle}}
      />
    );
  };

  return (
    <View style={[styles.container, styles.containerShadow, containerStyle]}>
      {btnTitles.map(renderBtn)}
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
    marginHorizontal: Matrics.s(15),
  },
  containerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.05,
    shadowRadius: 8,
    elevation: 2,
  },
  btnCommonContainer: {
    width: '50%',
    borderWidth: Matrics.s(1),
    paddingVertical: Matrics.vs(8),
    borderRadius: Matrics.mvs(12),
    marginBottom: 0,
    marginRight: 0,
  },
  btnTxtCommon: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    lineHeight: Matrics.vs(20),
  },
  activeBtn: {
    backgroundColor: colors.boxLightPurple,
    borderColor: colors.themePurple,
  },
  inActiveBtn: {
    borderWidth: 0,
    backgroundColor: colors.transparent,
  },
  activeBtnTxt: {
    color: colors.labelDarkGray,
  },
  inActiveBtnTxt: {
    color: colors.darkGray,
    fontFamily: Fonts.MEDIUM,
  },
});
