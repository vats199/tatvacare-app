import {ImageStyle, StyleSheet, Text, View, ViewStyle} from 'react-native';
import React from 'react';
import {Image} from 'react-native';
import {
  CoachDetailsType,
  LanguagesType,
} from '../../screens/Appointment/AppointmentWithScreen';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';

type CoachDetailsCardProps = {
  data: CoachDetailsType;
  containerStyle?: ViewStyle;
  profileImageStyle?: ImageStyle;
};

const CoachDetailsCard: React.FC<CoachDetailsCardProps> = ({
  data: {languages, level, name, profile, type},
  containerStyle,
  profileImageStyle,
}) => {
  const renderLanguage = (item: LanguagesType[]) => {
    const combineLanguage = item.map(item => item.language).join(', ');
    return (
      <Text numberOfLines={2} style={styles.languageTxt}>
        {combineLanguage}
      </Text>
    );
  };

  return (
    <View style={[styles.coachDetailContainer, containerStyle]}>
      <Image
        source={profile}
        style={[styles.coachProfileImage, profileImageStyle]}
        resizeMode="contain"
      />
      <View style={styles.coachNameContainer}>
        <Text numberOfLines={1} style={styles.coachNameTxt}>
          {name}
        </Text>
        <View style={styles.coachTypeContainer}>
          <Text numberOfLines={1} style={styles.coachTypeTxt}>
            {type}
          </Text>
          <View style={styles.dotContainer} />
          <Text numberOfLines={1} style={styles.coachLevelTxt}>
            {level}
          </Text>
        </View>
        {renderLanguage(languages)}
      </View>
    </View>
  );
};

export default CoachDetailsCard;

const styles = StyleSheet.create({
  coachDetailContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Matrics.s(15),
  },
  coachProfileImage: {
    height: Matrics.vs(50),
    width: Matrics.s(50),
  },
  coachNameContainer: {
    flex: 1,
    marginLeft: Matrics.s(10),
  },
  coachNameTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    fontWeight: '500',
    color: colors.black,
  },
  coachTypeContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  coachTypeTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(11),
    color: colors.subTitleLightGray,
    lineHeight: Matrics.vs(20),
    maxWidth: Matrics.s(110),
  },
  dotContainer: {
    width: Matrics.s(4),
    height: Matrics.s(4),
    borderRadius: Matrics.s(4),
    backgroundColor: colors.inactiveGray,
    marginHorizontal: Matrics.s(5),
  },
  coachLevelTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(11),
    color: colors.subTitleLightGray,
    lineHeight: Matrics.vs(20),
    maxWidth: Matrics.s(110),
  },
  languageTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(11),
    color: colors.subTitleLightGray,
  },
});
