import React, { useEffect, useMemo, useRef, useState } from 'react';
import { Platform, StyleSheet, View, ViewStyle } from 'react-native';
import { Picker, DatePicker } from 'react-native-wheel-pick';

import { Matrics } from '../../constants';
import { colors } from '../../constants/colors';

const dummyData = [...new Array(200)].map((item, index) => {
  return { label: `${String(index + 1)}`, value: index + 1 };
});

const additionalDataArr = [...new Array(12)].map((item, index) => {
  return { label: `${String(index + 1)}`, value: index + 1 };
});

export type PickerDataTypeProps = {
  label: string;
  value: number;
};
type onChangeTypeProps = {
  value: number;
  type: string;
};
export interface Props {
  selectedValue?: string | null;
  containerStyle?: ViewStyle | undefined;
  textSize?: number;
  selectTextColor?: string;
  textColor?: string;
  isShowSelectBackground?: boolean;
  leftArrowStyle?: ViewStyle | undefined;
  rightArrowStyle?: ViewStyle | undefined;
  pickerWrapperStyle?: ViewStyle | undefined;
  data?: PickerDataTypeProps[];
  additionalData?: PickerDataTypeProps[];
  isShowMultiplePicker?: boolean;
  rowContainerStyle?: ViewStyle | undefined;
  leftPickerContStyle?: ViewStyle | undefined;
  rightPickerContStyle?: ViewStyle | undefined;
  onChangeValue: (value: onChangeTypeProps, type?: string) => void;
}

const WheelPicker: React.FC<Props> = ({
  selectedValue,
  containerStyle,
  textSize = Matrics.mvs(30),
  selectTextColor = colors.labelDarkGray,
  textColor = colors.subTitleLightGray,
  isShowSelectBackground = false,
  leftArrowStyle,
  rightArrowStyle,
  pickerWrapperStyle,
  data = dummyData,
  additionalData = additionalDataArr,
  isShowMultiplePicker = false,
  rowContainerStyle,
  leftPickerContStyle,
  rightPickerContStyle,
  onChangeValue = () => { },
}) => {
  return (
    <>
      {!isShowMultiplePicker && (
        <View style={[styles.container, containerStyle]}>
          <Picker
            style={[styles.pickerStyle, pickerWrapperStyle]}
            textSize={textSize}
            isShowSelectBackground={isShowSelectBackground}
            selectTextColor={'red'}
            textColor={textColor}
            selectedValue={selectedValue}
            selectLineSize={0}
            pickerData={data}
            onValueChange={(value: number) => {
              onChangeValue({ value: value, type: 'left' });
            }}
          />
          <View style={[styles.leftArrow, leftArrowStyle]}></View>
          <View style={[styles.rightArrow, rightArrowStyle]}></View>
        </View>
      )}

      {isShowMultiplePicker && (
        <View style={[styles.rowContainer, rowContainerStyle]}>
          <View style={[styles.leftPickerCont, leftPickerContStyle]}>
            <Picker
              style={styles.leftPicker}
              textSize={textSize}
              isShowSelectBackground={isShowSelectBackground}
              selectTextColor={selectTextColor}
              textColor={textColor}
              selectedValue={selectedValue}
              selectLineSize={0}
              pickerData={data}
              onValueChange={(value: number) => {
                onChangeValue({ value: value, type: 'left' });
                console.log(value, 'valueeeeeee');
              }}
            />
          </View>
          <View style={[styles.rightPickerCont, rightPickerContStyle]}>
            <Picker
              style={styles.rightPikcer}
              textSize={textSize}
              isShowSelectBackground={isShowSelectBackground}
              selectTextColor={selectTextColor}
              textColor={textColor}
              selectedValue={selectedValue}
              selectLineSize={0}
              pickerData={additionalData}
              onValueChange={(value: number) => {
                onChangeValue({ value: value, type: 'right' });
                console.log(value, 'valueeeeeee');
              }}
            />
          </View>
          <View style={[styles.leftArrow, leftArrowStyle]}></View>
          <View style={[styles.rightArrow, rightArrowStyle]}></View>
        </View>
      )}
    </>
  );
};

export default WheelPicker;

const styles = StyleSheet.create({
  container: { justifyContent: 'center' },
  pickerStyle: {
    backgroundColor: colors.white,
    width: Matrics.screenWidth,
    alignSelf: 'center',
    justifyContent: 'center',
  },
  rightArrow: {
    height: Matrics.mvs(30),
    width: Matrics.mvs(30),
    backgroundColor: colors.themePurple,
    transform: [{ rotate: '45deg' }],
    position: 'absolute',
    right: Matrics.mvs(-15),
  },
  leftArrow: {
    height: Matrics.mvs(30),
    width: Matrics.mvs(30),
    backgroundColor: colors.themePurple,
    transform: [{ rotate: '45deg' }],
    position: 'absolute',
    left: Matrics.mvs(-15),
  },
  rowContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  leftPickerCont: {
    alignItems: 'flex-end',
  },
  rightPickerCont: {
    alignItems: 'flex-start',
  },
  leftPicker: {
    backgroundColor: colors.white,
    width: Matrics.s(80),
  },
  rightPikcer: {
    backgroundColor: colors.white,
    width: Matrics.s(80),
  },
});