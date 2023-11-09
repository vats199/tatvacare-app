import React, { useState } from 'react';
import { View, StyleSheet, Text, ViewStyle, TextStyle } from 'react-native';
import { Dropdown as ElementDropdown } from 'react-native-element-dropdown';
import { Icons } from '../../constants/icons';
import { Fonts, Matrics } from '../../constants';
import { colors } from '../../constants/colors';

interface DropdownProps {
  data: Array<{ label: string; value: string }>;
  dropdownStyle?: ViewStyle;
  labelStyle?: TextStyle;
  placeholderStyle?: TextStyle;
  selectedTextStyle?: TextStyle;
  iconStyle?: TextStyle;
  inputSearchStyle?: TextStyle;
  placeholder?: string;
  selectedItem: (data: string) => void;
  isDisable?: boolean;
  containerStyle?: TextStyle;
  defaultValues?: string;
}

const DropdownComponent: React.FC<DropdownProps> = ({
  data,
  dropdownStyle,
  labelStyle,
  placeholderStyle,
  selectedTextStyle,
  iconStyle,
  inputSearchStyle,
  placeholder,
  selectedItem,
  isDisable,
  containerStyle,
  defaultValues,
}) => {
  const [value, setValue] = useState<string | null>(defaultValues || null);
  const [isFocus, setIsFocus] = useState(false);
  const handeSelectItem = (item: string) => {
    selectedItem(item);
  };
  return (
    <ElementDropdown
      style={[
        styles.dropdown,
        isFocus && { borderColor: colors.darkGray },
        dropdownStyle,
      ]}
      placeholderStyle={[styles.placeholderStyle, placeholderStyle]}
      selectedTextStyle={[styles.selectedTextStyle, selectedTextStyle]}
      inputSearchStyle={[styles.inputSearchStyle, inputSearchStyle]}
      iconStyle={[styles.iconStyle]}
      iconColor="black"
      data={data}
      // search
      containerStyle={containerStyle}
      dropdownPosition={'top'}
      maxHeight={300}
      labelField="label"
      valueField="value"
      itemTextStyle={{ color: colors.subTitleLightGray }}
      placeholder={!isFocus ? placeholder : 'select'}
      searchPlaceholder="Search..."
      value={value}
      disable={isDisable}
      onFocus={() => setIsFocus(true)}
      onBlur={() => setIsFocus(false)}
      onChange={item => {
        handeSelectItem(item.value);
        setValue(item.value);
        setIsFocus(false);
      }}
      renderRightIcon={() => {
        return <Icons.DropdownIcon />;
      }}
    />
  );
};

export default DropdownComponent;

const styles = StyleSheet.create({
  dropdown: {
    height: Matrics.vs(44),
    borderColor: colors.inputBoxLightBorder,
    borderWidth: Matrics.s(1),
    borderRadius: Matrics.mvs(12),
    paddingHorizontal: Matrics.s(12),
    backgroundColor: colors.white,
  },
  label: {
    position: 'absolute',
    backgroundColor: 'white',
    left: 22,
    top: 8,
    zIndex: 999,
    paddingHorizontal: 8,
    fontSize: 20,
  },
  placeholderStyle: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(13),
    color: colors.subTitleLightGray,
  },
  selectedTextStyle: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(13),
    color: colors.subTitleLightGray,
  },
  iconStyle: {
    width: Matrics.mvs(20),
    height: Matrics.mvs(20),
    tintColor: '#919191',
  },
  inputSearchStyle: {
    height: 40,
    fontSize: 16,
  },
});
