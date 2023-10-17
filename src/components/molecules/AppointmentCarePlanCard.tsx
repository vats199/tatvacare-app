import {Image, StyleSheet, Text, View, ViewStyle} from 'react-native';
import React, {useState} from 'react';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import ProgressBar from '../atoms/ProgressBar';

type AppointmentCarePlanCardProps = {
  containerStyle?: ViewStyle;
};

const AppointmentCarePlanCard: React.FC<AppointmentCarePlanCardProps> = ({
  containerStyle,
}) => {
  const [progress, setProgress] = useState<number>(50);

  return (
    <View
      style={[
        styles.carePlanContainer,
        styles.containerShadow,
        containerStyle,
      ]}>
      <View style={styles.carePlanSubContainer}>
        <>
          <Text numberOfLines={1} style={styles.carePlanTxt}>
            Care Plan Name
          </Text>
          <Text numberOfLines={2} style={styles.carePlanDesTxt}>
            Bundled with diagnostic tests and monitoring devices.
          </Text>
        </>
        <>
          <ProgressBar progress={progress} />
          <Text numberOfLines={1} style={styles.carePlanDateTxt}>
            Expire on july 30th 2023
          </Text>
        </>
      </View>
      <Image
        source={require('../../assets/images/carePlan.png')}
        style={styles.carePlanImage}
        resizeMode="contain"
      />
    </View>
  );
};

export default AppointmentCarePlanCard;

const styles = StyleSheet.create({
  carePlanContainer: {
    backgroundColor: colors.white,
    padding: Matrics.s(12),
    borderRadius: Matrics.s(10),
    marginTop: Matrics.vs(20),
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginHorizontal: Matrics.s(17),
  },
  containerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
  carePlanSubContainer: {
    flex: 1,
    justifyContent: 'space-around',
    marginRight: Matrics.s(10),
  },
  carePlanTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    fontWeight: '600',
    color: colors.black,
  },
  carePlanDesTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(9),
    color: colors.secondaryLabel,
    paddingVertical: Matrics.vs(5),
  },
  carePlanDateTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(12),
    color: colors.secondaryLabel,
  },
  carePlanImage: {
    width: Matrics.s(75),
    height: Matrics.vs(60),
  },
});
