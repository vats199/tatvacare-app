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
  onPress?: (item: string) => void;
};

const TabButton: React.FC<TabButtonProps> = ({
  btnTitles,
  containerStyle,
  onPress,
}) => {
  const [selectedBtn, setSelectedBtn] = useState<string>(btnTitles[0]);

  const onPressTabBtn = (item: string) => {
    if (selectedBtn != item) {
      setSelectedBtn(item);
      onPress && onPress(item);
    }
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
      <TouchableOpacity
        style={{
          ...selectedBtnStyle,
        }}
        onPress={() => onPressTabBtn(item)}>
        <Text
          style={{
            ...selectedBtnTxtStyle,
          }}>
          {item}
        </Text>
      </TouchableOpacity>
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
    borderRadius: Matrics.mvs(16),
    borderWidth: 1,
    height: Matrics.mvs(44),
    borderColor: colors.inputBoxLightBorder,
    marginHorizontal: Matrics.s(15),
    overflow: 'hidden',
  },
  containerShadow: {
    shadowColor: colors.OVERLAY_DARK_50,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.05,
    shadowRadius: 4,
    elevation: 1,
  },
  btnCommonContainer: {
    width: '50%',
    borderWidth: 1,
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
    height: '100%',
    width: '50%',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.boxLightPurple,
    borderColor: colors.themePurple,
    borderWidth: 1,
    borderRadius: Matrics.mvs(16),
  },
  inActiveBtn: {
    height: '100%',
    width: '50%',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderColor: colors.themePurple,
    borderWidth: 0,
    borderRadius: Matrics.mvs(16),
  },
  activeBtnTxt: {
    color: colors.labelDarkGray,
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.BOLD,
  },
  inActiveBtnTxt: {
    color: colors.darkGray,
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.REGULAR,
  },
});
