import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';

const ContactUs = () => {
  return (
    <TouchableOpacity
      activeOpacity={0.8}
      style={[styles.container, styles.containerShadow]}>
      <Text style={styles.titleTxt}>Need Help with something?</Text>
      <Text style={styles.contactUsTxt}>Contact Us</Text>
    </TouchableOpacity>
  );
};

export default ContactUs;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    padding: Matrics.s(15),
    backgroundColor: colors.white,
    borderRadius: Matrics.s(15),
    marginHorizontal: Matrics.s(15),
    justifyContent: 'space-between',
  },
  containerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },
  titleTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    color: colors.labelDarkGray,
  },
  contactUsTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(12),
    color: colors.themePurple,
    fontWeight: '700',
  },
});
