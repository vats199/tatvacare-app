import React, {useEffect, useMemo, useRef, useState} from 'react';
import {StyleSheet, View, ViewStyle} from 'react-native';
import {Picker, DatePicker} from 'react-native-wheel-pick';

import {Matrics} from '../../constants';
import {colors} from '../../constants/colors';

const dummyData = [...new Array(100)].map((item, index) => {
  return {label: String(index + 1), value: index + 1};
});
type PickerDataTypeProps = {
  label: string;
  value: number;
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
  data?: PickerDataTypeProps;
  isShowMultiplePicker?: boolean;
  rowContainerStyle?: ViewStyle | undefined;
  leftPickerContStyle?: ViewStyle | undefined;
  rightPickerContStyle?: ViewStyle | undefined;
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
  isShowMultiplePicker = false,
  rowContainerStyle,
  leftPickerContStyle,
  rightPickerContStyle,
}) => {
  return (
    <>
      {!isShowMultiplePicker && (
        <View style={[styles.container, containerStyle]}>
          <Picker
            style={[styles.pickerStyle, pickerWrapperStyle]}
            textSize={textSize}
            isShowSelectBackground={isShowSelectBackground}
            selectTextColor={selectTextColor}
            textColor={textColor}
            selectedValue={selectedValue}
            selectLineSize={0}
            pickerData={data}
            onValueChange={value => {
              console.log(value, 'valueeeeeee');
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
              onValueChange={value => {
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
              pickerData={data}
              onValueChange={value => {
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
  container: {flex: 1, justifyContent: 'center'},
  pickerStyle: {
    backgroundColor: colors.white,
    width: Matrics.screenWidth,
    marginVertical: 16,
    height: Matrics.vs(250),
  },
  rightArrow: {
    height: Matrics.mvs(32),
    width: Matrics.mvs(32),
    backgroundColor: colors.themePurple,
    transform: [{rotate: '45deg'}],
    position: 'absolute',
    right: Matrics.s(-16),
  },
  leftArrow: {
    height: Matrics.mvs(32),
    width: Matrics.mvs(32),
    backgroundColor: colors.themePurple,
    transform: [{rotate: '45deg'}],
    position: 'absolute',
    left: Matrics.s(-16),
  },
  rowContainer: {flex: 1, flexDirection: 'row', alignItems: 'center'},
  leftPickerCont: {
    width: Matrics.screenWidth / 2,
    height: Matrics.vs(250),
    alignItems: 'flex-end',
  },
  rightPickerCont: {
    width: Matrics.screenWidth / 2,
    height: Matrics.vs(250),
    alignItems: 'flex-start',
  },
  leftPicker: {
    backgroundColor: colors.white,
    width: Matrics.s(70),
    height: Matrics.vs(250),
  },
  rightPikcer: {
    backgroundColor: colors.white,
    width: Matrics.s(40),
    height: Matrics.vs(250),
  },
});
