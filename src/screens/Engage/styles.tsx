import { StyleSheet } from 'react-native';
import { Fonts, Matrics } from '../../constants';
import { colors } from '../../constants/colors';

export const EngageStyle = StyleSheet.create({
  mainContainer: {
    flex: 1,
    backgroundColor: colors.white, paddingBottom: 0
  },
  headerContainer: {
    flex: 0.1,
    backgroundColor: colors.white,
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: Matrics.s(15),
    alignItems: 'center',
  },
  headerText: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(22),
    fontWeight: '700',
    color: colors.darkBlue,
  },
  categoryContainer: {
    height: Matrics.s(85),
    width: Matrics.s(85),
    backgroundColor: 'red',
    marginHorizontal: Matrics.s(10),
    borderRadius: Matrics.mvs(10),
    marginVertical: Matrics.s(20),
    justifyContent: 'center',
    alignItems: 'center',
  },
  categoryView: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  icons: {
    height: Matrics.s(30),
    width: Matrics.s(30),
  },
  categoryText: {
    fontSize: Matrics.mvs(12),
    color: colors.white,
    textAlign: 'center',
  },
  categoryDataContainer: {
    flex: 1,
    backgroundColor: colors.lightGray,
    borderTopRightRadius: Matrics.mvs(28),
    borderTopLeftRadius: Matrics.mvs(28),
    height: '100%'
  },
  dropdownContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginHorizontal: Matrics.s(20),
    marginVertical: Matrics.s(15),
  },
  dropdown: {
    backgroundColor: colors.themePurple,
    height: Matrics.vs(25),
    width: Matrics.s(100),
    borderRadius: Matrics.mvs(5),
  },
  dropdownText: {
    color: colors.white,
    margin: Matrics.s(5.5)
  }
});
