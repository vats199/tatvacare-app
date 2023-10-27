import {StyleSheet} from 'react-native';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';

export const GoalsScreen = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
  headingText: {
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.BOLD,
    color: colors.darkBlue,
    marginHorizontal: Matrics.s(12),
  },
  descText: {
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.REGULAR,
    color: colors.darkBlue,
  },
  itemTitleStyle: {
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.MEDIUM,
    color: colors.darkBlue,
  },
  itemDescStyle: {
    fontSize: Matrics.mvs(8),
    fontFamily: Fonts.REGULAR,
    color: colors.darkBlue,
    marginTop: Matrics.s(2),
  },
  itemButtonStyle: {
    fontSize: Matrics.mvs(8),
    fontFamily: Fonts.REGULAR,
    color: colors.themePurple,
  },
  sectionHeaderText: {
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.BOLD,
    color: colors.darkBlue,
  },
});
