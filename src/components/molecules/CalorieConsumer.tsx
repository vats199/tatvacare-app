import React, { useEffect } from 'react';
import { StyleSheet, View, Text } from 'react-native';
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
      <View style={styles.innerContainer}>
        <View style={styles.topRow}>
          <View style={styles.leftContent}>
            <CircularProgress
              value={values}
              inActiveStrokeColor={'#2ecc71'}
              inActiveStrokeOpacity={0.2}
              progressValueColor={'green'}
              radius={Matrics.mvs(23)}
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
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    // borderColor: '#808080',
    borderRadius: 12,
    marginTop: 20,
    marginBottom: 5,
    overflow: 'hidden',
    shadowOffset: { width: 0, height: 0 },
    shadowColor: '#171717',
    shadowOpacity: 0.1,
    shadowRadius: 3,
    elevation: 2,
  },
  innerContainer: {
    backgroundColor: 'white',
    paddingHorizontal: Matrics.s(5),
  },
  topRow: {
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
  },
  leftContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  textContainer: {
    flex: 1,
    marginLeft: 10,
  },
  boldTitle: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#000',
  },
  regularTitle: {
    fontSize: 17,
    color: '#444444',
  },
  textBelowTitle: {
    fontSize: 13,
    color: '#444444',
  },
});

export default CalorieConsumer;
