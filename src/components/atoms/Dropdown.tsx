import React, { useState } from 'react';
import { View, StyleSheet, Text, ViewStyle, TextStyle } from 'react-native';
import { Dropdown as ElementDropdown } from 'react-native-element-dropdown';
import { Icons } from '../../constants/icons';

interface DropdownProps {
  data: Array<{ label: string; value: string }>;
  dropdownStyle?: ViewStyle;
  labelStyle?: TextStyle;
  placeholderStyle?: TextStyle;
  selectedTextStyle?: TextStyle;
  iconStyle?: TextStyle;
  inputSearchStyle?: TextStyle;
  placeholder?: string;
  selectedItem?: (data: string) => void;
  isDisable?: boolean;
  containerStyle?: TextStyle;
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
}) => {
  const [value, setValue] = useState<string | null>(null);
  const [isFocus, setIsFocus] = useState(false);
  const handeSelectItem = (item: string) => {
    selectedItem(item);
  };
  return (
    <View style={[styles.container, dropdownStyle]}>
      <ElementDropdown
        style={[styles.dropdown, isFocus && { borderColor: 'blue' }]}
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
      />
    </View>
  );
};

export default DropdownComponent;

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'white',
    marginRight: 10,
  },
  dropdown: {
    height: 44,
    borderColor: '#E0E0E0',
    borderWidth: 1.3,
    borderRadius: 14,
    paddingHorizontal: 8,

    // elevation: 0.2,
  },
  icon: {
    marginRight: 5,
  },
  label: {
    position: 'absolute',
    backgroundColor: 'white',
    left: 22,
    top: 8,
    zIndex: 999,
    paddingHorizontal: 8,
    fontSize: 14,
  },
  placeholderStyle: {
    fontSize: 16,
  },
  selectedTextStyle: {
    fontSize: 16,
  },
  iconStyle: {
    width: 20,
    height: 20,
    // tintColor: '#919191',
  },
  inputSearchStyle: {
    height: 40,
    fontSize: 16,
  },
});
