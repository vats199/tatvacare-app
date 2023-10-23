import {
  Animated,
  StyleSheet,
  Text,
  TextInput,
  TextInputProps,
  TextStyle,
  ViewStyle,
  TouchableOpacity,
} from 'react-native';
import DateTimePickerModal from 'react-native-modal-datetime-picker';
import {TapGestureHandler} from 'react-native-gesture-handler';

import React, {forwardRef, useImperativeHandle, useState} from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import moment from 'moment';

interface AnimatedInputFieldProps extends TextInputProps {
  style?: ViewStyle;
  textStyle?: TextStyle;
  label?: string;
  error?: string;
  showErrorText?: boolean;
  showAnimatedLabel?: boolean;
  onSetDate: (date: string) => void;
}

export type AnimatedInputFieldRef = {
  blur: () => void;
  focus: () => void;
};

const AnimatedDatePicker = forwardRef<
  AnimatedInputFieldRef,
  AnimatedInputFieldProps
>(
  (
    {
      style,
      placeholder,
      value,
      error,
      showErrorText = true,
      showAnimatedLabel = true,
      onFocus = () => {},
      onSetDate = () => {},
    },
    ref,
  ) => {
    const textInputRef = React.useRef<TextInput>(null);

    // Expose methods using useImperativeHandle
    useImperativeHandle(ref, () => ({
      focus: () => {
        textInputRef.current?.focus();
      },
      blur: () => {
        textInputRef.current?.blur();
      },
    }));

    const [isFocused, setIsFocused] = React.useState<boolean>(false);
    const translateY = new Animated.Value(0);
    const [date, setDate] = useState<string | null>(null);
    const [isDatePickerVisible, setDatePickerVisibility] =
      useState<boolean>(false);
    const handleFocus = () => {
      setIsFocused(true);
      Animated.timing(translateY, {
        toValue: -10,
        duration: 300,
        useNativeDriver: false,
      }).start();
    };

    // const handleBlur = (e: any) => {
    //   onBlur(e);
    //   setIsFocused(false);
    //   Animated.timing(translateY, {
    //     toValue: 0,
    //     duration: 300,
    //     useNativeDriver: false,
    //   }).start();
    // };

    const showDatePicker = () => {
      setDatePickerVisibility(true);
    };

    const hideDatePicker = () => {
      setDatePickerVisibility(false);
    };

    const handleConfirm = (dateVal: Date) => {
      handleFocus();
      setDate(moment(dateVal).format('YYYY-MM-DD'));
      onSetDate(moment(dateVal).format('YYYY-MM-DD'));
      //   console.warn('A date has been picked: ', dateVal);
      hideDatePicker();
    };
    return (
      <>
        <TouchableOpacity
          onPress={() => {
            handleFocus();
            showDatePicker();
          }}
          style={[
            styles.container,
            style,
            (error?.length ?? 0) > 0 && styles.errorContainer,
          ]}>
          <TapGestureHandler onHandlerStateChange={handleFocus}>
            <Animated.View style={[styles.row]}>
              {showAnimatedLabel && (isFocused || (date?.length ?? 0) > 0) && (
                <Animated.Text
                  style={{
                    position: 'absolute',
                    transform: [{translateY}],
                    color: colors.subTitleLightGray,
                    fontSize: Matrics.mvs(10),
                    fontFamily: Fonts.REGULAR,
                  }}>
                  {placeholder}
                </Animated.Text>
              )}

              {date !== '' && date != null ? (
                <Text style={styles.valueText}>
                  {moment(date).format('DD/MM/YYYY')}
                </Text>
              ) : (
                <Text style={styles.placeholderText}>
                  {isFocused
                    ? ''
                    : showAnimatedLabel || !isFocused
                    ? placeholder
                    : ''}
                </Text>
              )}
            </Animated.View>
          </TapGestureHandler>

          <DateTimePickerModal
            isVisible={isDatePickerVisible}
            mode="date"
            onConfirm={handleConfirm}
            onCancel={hideDatePicker}
          />
        </TouchableOpacity>
        {(error?.length ?? 0) > 0 && showErrorText && (
          <Text style={styles.error}>{error}</Text>
        )}
      </>
    );
  },
);

export default AnimatedDatePicker;

const styles = StyleSheet.create({
  container: {
    // borderWidth: 1,
    // borderRadius: 5,
    // borderColor: 'gray',
    // paddingVertical: Matrics.vs(5),
    paddingHorizontal: Matrics.s(10),
    marginVertical: Matrics.vs(5),
    flex: 1,
    // backgroundColor: 'red',
  },
  placeholderText: {
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(14),
  },
  valueText: {
    color: colors.inputValueDarkGray,
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
    paddingTop: Matrics.vs(15),
  },
  errorContainer: {
    borderColor: 'red',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  qtyBtn: {
    padding: 5,
    backgroundColor: 'blue',
    borderRadius: 2,
    aspectRatio: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  label: {
    color: colors.labelTitleDarkGray,
    fontSize: Matrics.mvs(14),
  },
  rightlabel: {
    color: 'black',
    fontSize: Matrics.mvs(10),
  },
  canEdit: {
    padding: 0,
    flex: 1,
    color: colors.inputValueDarkGray,
    fontWeight: '600',
    fontSize: Matrics.mvs(14),
  },
  cannotEdit: {
    color: 'gray',
    padding: 0,
    flex: 1,
  },
  error: {
    color: 'red',
  },
  labelContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
});
