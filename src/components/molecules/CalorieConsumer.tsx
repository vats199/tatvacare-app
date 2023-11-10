import React, {useEffect} from 'react';
import {StyleSheet, View, Text, TouchableOpacity} from 'react-native';
import {Icons} from '../../constants/icons';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {useDiet} from '../../context/diet.context';
import AnimatedRoundProgressBar from '../atoms/AnimatedRoundProgressBar';

// type CalorieConsumerProps = {
//   totalConsumedcalories: any;
//   totalcalories: any;
// };
const CalorieConsumer = () => {
  const [values, setVAlues] = React.useState(0);
  const {totalCalories, totalConsumedCalories} = useDiet();
  useEffect(() => {
    let vale = Math.round((totalConsumedCalories / totalCalories) * 100);
    if (isNaN(vale)) {
      setVAlues(0);
    } else {
      setVAlues(vale);
    }
  }, [totalConsumedCalories, totalCalories]);

  return (
    <View style={styles.container}>
      <View style={styles.topRow}>
        <View style={styles.leftContent}>
          <AnimatedRoundProgressBar values={values} />
          <View style={styles.textContainer}>
            <View style={{flexDirection: 'row', alignItems: 'center'}}>
              <Text style={styles.boldTitle}>
                {!totalConsumedCalories ? 0 : totalConsumedCalories}
              </Text>
              <Text style={styles.regularTitle}>
                {' of '} {!totalCalories ? 0 : totalCalories}
              </Text>
            </View>
            <Text style={styles.textBelowTitle}>Calories consumed today!</Text>
          </View>
        </View>
        <Icons.Vector />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: 'white',
    paddingHorizontal: Matrics.s(5),
    borderRadius: Matrics.s(12),
  },
  topRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Matrics.s(10),
    paddingVertical: Matrics.vs(8),
  },
  leftContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  textContainer: {
    flex: 1,
    marginLeft: 10,
    justifyContent: 'space-between',
  },
  boldTitle: {
    fontSize: Matrics.mvs(18),
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
    lineHeight: 26,
  },
  regularTitle: {
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
    lineHeight: 20,
  },
  textBelowTitle: {
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
    lineHeight: 18,
  },
});

export default CalorieConsumer;
