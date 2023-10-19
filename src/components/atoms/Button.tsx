import {
  StyleSheet,
  Text,
  View,
  ButtonProps,
  TouchableOpacity,
  ViewStyle,
  TextStyle,
  ActivityIndicator,
} from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Constants, Fonts, Matrics } from '../../constants';

interface MyButtonProps extends ButtonProps {
  buttonStyle?: ViewStyle;
  titleStyle?: TextStyle;
  activeOpacity?: number;
  loading?: boolean;
  loaderColor?: string;
  type?: string;
}

const Button: React.FC<MyButtonProps> = ({
  title,
  onPress,
  buttonStyle,
  titleStyle,
  activeOpacity,
  disabled,
  loading = false,
  loaderColor = 'white',
  type = Constants.BUTTON_TYPE.PRIMARY,
}) => {
  return (
    <>
      {type == Constants.BUTTON_TYPE.PRIMARY && (
        <TouchableOpacity
          style={[
            styles.container,
            disabled && { backgroundColor: colors.disableButton },
            buttonStyle,
          ]}
          onPress={onPress}
          activeOpacity={activeOpacity ?? 0.7}
          disabled={disabled || loading}>
          {loading ? (
            <ActivityIndicator size={'small'} color={loaderColor} />
          ) : (
            <Text style={[styles.title, titleStyle]}>{title}</Text>
          )}
        </TouchableOpacity>
      )}

      {type == Constants.BUTTON_TYPE.SECONDARY && (
        <TouchableOpacity
          style={[
            styles.secondaryButtonContainer,
            disabled && {
              backgroundColor: colors.secondaryDisableButton,
              borderColor: colors.disableButton,
            },
            buttonStyle,
          ]}
          onPress={onPress}
          activeOpacity={activeOpacity ?? 0.7}
          disabled={disabled || loading}>
          {loading ? (
            <ActivityIndicator size={'small'} color={loaderColor} />
          ) : (
            <Text
              style={[
                styles.title,
                { color: disabled ? colors.disableButton : colors.themePurple },
                titleStyle,
              ]}>
              {title}
            </Text>
          )}
        </TouchableOpacity>
      )}

      {type == Constants.BUTTON_TYPE.TERTIARY && (
        <TouchableOpacity
          style={[
            styles.tertiaryButtonContainer,
            disabled && { borderBottomColor: colors.disableButton },
            buttonStyle,
          ]}
          onPress={onPress}
          activeOpacity={activeOpacity ?? 0.7}
          disabled={disabled || loading}>
          {loading ? (
            <ActivityIndicator size={'small'} color={loaderColor} />
          ) : (
            <Text
              style={[
                styles.tertiaryText,
                disabled && { color: colors.disableButton },
                titleStyle,
              ]}>
              {title}
            </Text>
          )}
        </TouchableOpacity>
      )}
    </>
  );
};

export default Button;

const styles = StyleSheet.create({
  container: {
    height: Matrics.vs(45),
    backgroundColor: colors.themePurple,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: Matrics.mvs(16),
    marginHorizontal: Matrics.s(20),
  },
  title: {
    color: 'white',
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.BOLD,
  },
  secondaryButtonContainer: {
    height: Matrics.vs(45),
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: Matrics.mvs(16),
    borderWidth: 1,
    borderColor: colors.themePurple,
    marginHorizontal: Matrics.s(16),
  },
  tertiaryButtonContainer: {
    alignSelf: 'center',
    borderBottomWidth: 1,
    borderBottomColor: colors.themePurple,
  },
  tertiaryText: {
    color: colors.themePurple,
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.BOLD,
  },
});
