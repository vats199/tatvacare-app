import {
  StyleSheet,
  Text,
  TextStyle,
  TouchableOpacity,
  TouchableOpacityProps,
  View,
  ViewStyle,
} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {Icons} from '../../constants/icons';
import {Image} from 'react-native-svg';
import {Icon} from 'react-native-vector-icons/Icon';

interface AppointmentHeaderProps {
  containerStyle?: ViewStyle;
  title: string;
  textStyle?: TextStyle;
}

const AppointmentHeader: React.FC<
  AppointmentHeaderProps & TouchableOpacityProps
> = props => {
  const {containerStyle, title, textStyle} = props;
  return (
    <View style={[styles.container, containerStyle]}>
      <TouchableOpacity {...props} style={[styles.btnStyle, props.style]}>
        <Icons.backArrow height={Matrics.s(20)} width={Matrics.s(15)} />
      </TouchableOpacity>
      <Text style={[styles.headerTxt, textStyle]}>{title}</Text>
    </View>
  );
};

export default AppointmentHeader;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    marginVertical: Matrics.s(10),
    alignItems: 'center',
    marginHorizontal: Matrics.s(17),
  },
  backArrowImage: {
    height: Matrics.s(20),
    width: Matrics.s(20),
  },
  headerTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    marginLeft: Matrics.s(10),
    fontWeight: '600',
  },
  btnStyle: {
    paddingHorizontal: Matrics.s(5),
    paddingVertical: Matrics.s(2),
    marginLeft: Matrics.s(-5),
  },
});
