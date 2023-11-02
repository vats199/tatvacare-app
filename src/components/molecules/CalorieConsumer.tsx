import React, { useEffect } from 'react';
import { StyleSheet, View, Text, TouchableOpacity } from 'react-native';
import { Icons } from '../../constants/icons';
import CircularProgress from 'react-native-circular-progress-indicator';
import { Fonts, Matrics } from '../../constants';
import { colors } from '../../constants/colors';

type CalorieConsumerProps = {
  totalConsumedcalories: any;
  totalcalories: any;
};
const CalorieConsumer: React.FC<CalorieConsumerProps> = ({
  totalConsumedcalories = 0,
  totalcalories = 0,
}) => {
  const [values, setVAlues] = React.useState(0);
  useEffect(() => {
    let vale = Math.round((totalConsumedcalories / totalcalories) * 100);
    if (isNaN(vale)) {
      setVAlues(0);
    } else {
      setVAlues(vale);
    }
  }, [totalConsumedcalories, totalcalories]);

  return (
    <View style={styles.container}>
      <View style={styles.topRow}>
        <View style={styles.leftContent}>
          <CircularProgress
            value={values}
            inActiveStrokeColor={'#2ecc71'}
            inActiveStrokeOpacity={0.2}
            progressValueColor={'green'}
            radius={Matrics.mvs(22)}
            activeStrokeWidth={3}
            inActiveStrokeWidth={3}
            duration={1000}
            maxValue={100}
            allowFontScaling={false}
            showProgressValue={false}
            title={`${values}%`}
            titleStyle={{
              fontSize: Matrics.mvs(11),
              fontFamily: Fonts.BOLD,
            }}
          />

          <View style={styles.textContainer}>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <Text style={styles.boldTitle}>
                {isNaN(totalConsumedcalories) ? 0 : totalConsumedcalories}
              </Text>
              <Text style={styles.regularTitle}>
                {' of ' + totalcalories}
              </Text>
            </View>
            <Text style={styles.textBelowTitle}>
              Calories consumed today!
            </Text>
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
    borderRadius: Matrics.s(12)
  },
  topRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: Matrics.s(10),
    paddingVertical: Matrics.vs(8)
  },
  leftContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  textContainer: {
    flex: 1,
    marginLeft: 10,
    justifyContent: 'space-between'
  },
  boldTitle: {
    fontSize: Matrics.mvs(18),
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
    lineHeight: 26
  },
  regularTitle: {
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.MEDIUM,
    color: colors.subTitleLightGray,
    lineHeight: 20

  },
  textBelowTitle: {
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.MEDIUM,
    color: colors.subTitleLightGray,
    lineHeight: 18
  },
});

export default CalorieConsumer;
