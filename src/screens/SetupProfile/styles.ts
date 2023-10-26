import {StyleSheet} from 'react-native';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';

export const WelcomeScreenStyle = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
  image: {
    height: Matrics.screenHeight * 0.5,
    width: Matrics.screenWidth - Matrics.s(50),
    alignSelf: 'center',
  },
  titleText: {
    fontSize: Matrics.mvs(20),
    color: colors.labelDarkGray,
    fontFamily: Fonts.BOLD,
    textAlign: 'center',
  },
  descText: {
    fontSize: Matrics.mvs(14),
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
    textAlign: 'center',
    marginTop: Matrics.vs(12),
  },
  textCont: {
    marginHorizontal: Matrics.s(16),
    alignItems: 'center',
    flex: 1,
  },
});

export const QuestionOneScreenStyle = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
  pincodeInputStyle: {
    borderWidth: 0,
    width: '100%',
  },
  inputBoxStyle: {
    color: colors.darkGray,
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(14),
  },
  inputBoxFill: {
    color: colors.labelTitleDarkGray,
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(14),
  },
  inputCont: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: Matrics.vs(20),
    marginHorizontal: Matrics.s(20),
    height: Matrics.vs(60),
    borderWidth: 1,
    borderRadius: Matrics.mvs(16),
    paddingHorizontal: Matrics.s(10),
    paddingVertical: 0,
  },
  genderTitle: {
    marginTop: Matrics.vs(28),
    fontSize: Matrics.mvs(14),
    color: colors.labelDarkGray,
    fontFamily: Fonts.BOLD,
  },
  genderContainer: {
    marginHorizontal: Matrics.s(20),
  },
  genderWrapper: {
    marginTop: Matrics.vs(12),
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  itemWidth: {
    width: (Matrics.screenWidth - 84) / 3,
    height: Matrics.vs(40),
    borderRadius: Matrics.mvs(12),
    borderWidth: 1,
    borderColor: colors.inputBoxLightBorder,
    justifyContent: 'center',
    alignItems: 'center',
    flexDirection: 'row',
  },
  genderItemText: {
    fontSize: Matrics.mvs(12),
    color: colors.darkGray,
    fontFamily: Fonts.MEDIUM,
    marginLeft: Matrics.s(3),
  },
  genderItemSelectedText: {
    fontSize: Matrics.mvs(12),
    color: colors.labelDarkGray,
    fontFamily: Fonts.MEDIUM,
  },
  doctorCodeTitle: {
    marginTop: Matrics.vs(28),
    fontSize: Matrics.mvs(14),
    color: colors.labelDarkGray,
    fontFamily: Fonts.BOLD,
    marginHorizontal: Matrics.s(20),
  },
  optionalText: {
    fontSize: Matrics.mvs(14),
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
  },
  doctorCodeCont: {
    // display: 'flex',
    flexDirection: 'row',
    flex: 1,
    marginRight: Matrics.s(12),
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: Matrics.vs(12),
    height: Matrics.vs(60),
    borderWidth: 1,
    borderRadius: Matrics.mvs(16),
    paddingHorizontal: Matrics.s(10),
    paddingVertical: 0,
    backgroundColor: colors.white,
  },
  doctorCodeInputStyle: {
    borderWidth: 0,
    width: '100%',
  },
  wrapper: {
    flexDirection: 'row',
    marginHorizontal: Matrics.s(20),
    justifyContent: 'space-between',
  },
  scanButton: {
    height: Matrics.vs(60),
    width: Matrics.vs(60),
    backgroundColor: 'rgba(118, 15, 178, 0.08)',
    borderWidth: 1,
    borderColor: colors.themePurple,
    marginTop: Matrics.vs(12),
    borderRadius: Matrics.mvs(12),
    justifyContent: 'center',
    alignItems: 'center',
  },
});
