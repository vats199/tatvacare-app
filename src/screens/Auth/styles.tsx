import {StyleSheet} from 'react-native';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import fonts from '../../constants/fonts';

export const OnBoardStyle = StyleSheet.create({
  container: {
    flex: 1,
  },
  buttonStyle: {
    marginHorizontal: Matrics.s(20),
    marginBottom: Matrics.vs(12),
  },
  spaceView: {
    height: Matrics.vs(42),
  },
  title: {
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
    textAlign: 'center',
    fontSize: Matrics.mvs(24),
    marginHorizontal: Matrics.s(32),
  },
  desc: {
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
    textAlign: 'center',
    fontSize: Matrics.mvs(16),
    marginHorizontal: Matrics.s(4),
    marginTop: Matrics.vs(12),
  },
  img: {
    height: Matrics.screenHeight * 0.5,
    width: Matrics.screenWidth - Matrics.s(20),
    alignSelf: 'center',
  },
  pagingCont: {
    position: 'absolute',
    bottom: 10,
    alignSelf: 'center',
    flexDirection: 'row',
  },
  wrapper: {
    backgroundColor: colors.white,
    flex: 1,
    borderBottomRightRadius: Matrics.mvs(32),
    borderBottomLeftRadius: Matrics.mvs(32),
  },
});

export const OtpStyle = StyleSheet.create({
  title: {
    color: colors.labelDarkGray,
    fontFamily: fonts.BOLD,
    fontSize: Matrics.mvs(24),
    marginTop: Matrics.vs(16),
  },
  container: {
    flex: 1,
    backgroundColor: colors.white,
    paddingHorizontal: Matrics.s(20),
  },
  description: {
    color: colors.labelDarkGray,
    fontFamily: fonts.REGULAR,
    fontSize: Matrics.mvs(14),
    marginTop: Matrics.vs(12),
  },
  nestedBoldText: {
    fontFamily: fonts.BOLD,
    color: colors.labelDarkGray,
  },
  resendDesc: {
    color: colors.subTitleLightGray,
    fontFamily: fonts.REGULAR,
    fontSize: Matrics.mvs(12),
  },
  resendNestedTest: {
    fontFamily: fonts.MEDIUM,
    color: colors.inactiveGray,
  },
  resendCode: {
    fontFamily: fonts.BOLD,
    fontSize: Matrics.mvs(13),
    color: colors.themePurple,
  },
  resendCont: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  underlineStyleBase: {
    borderWidth: 1,
    borderRadius: Matrics.mvs(12),
    fontSize: Matrics.mvs(14),
    fontFamily: fonts.MEDIUM,
    color: colors.inputValueDarkGray,
  },

  underlineStyleHighLighted: {
    borderColor: colors.inputBoxDarkBorder,
  },
});
