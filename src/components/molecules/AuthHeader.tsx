import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import {Matrics} from '../../constants';
import fonts from '../../constants/fonts';

type AuthHeaderProps = {
  onPressBack: () => void;
  onPressSkip?: () => void;
  isShowSkipButton?: boolean;
};

const AuthHeader: React.FC<AuthHeaderProps> = ({
  onPressBack,
  onPressSkip,
  isShowSkipButton = false,
}) => {
  return (
    <View style={styles.headerContainer}>
      <TouchableOpacity activeOpacity={0.7} onPress={onPressBack}>
        <Icons.BackIcon />
      </TouchableOpacity>
      {isShowSkipButton && (
        <TouchableOpacity activeOpacity={0.7} onPress={onPressSkip}>
          <Text style={styles.skipText}>{`Skip`}</Text>
        </TouchableOpacity>
      )}
    </View>
  );
};

export default AuthHeader;

const styles = StyleSheet.create({
  headerContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    height: Matrics.vs(40),
    alignItems: 'center',
    paddingHorizontal: Matrics.s(20),
    // backgroundColor: colors.white,
  },
  skipText: {
    color: colors.themePurple,
    fontFamily: fonts.MEDIUM,
    fontSize: Matrics.mvs(13),
    textDecorationLine: 'underline',
    textDecorationColor: colors.themePurple,
    textDecorationStyle: 'solid',
  },
});
