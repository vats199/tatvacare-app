import React, { useEffect } from 'react';
import { StyleSheet, View, Text } from 'react-native';
import { Icons } from '../../constants/icons';
import CircularProgress from 'react-native-circular-progress-indicator';
import Matrics from '../../constants/Matrics';

type CalorieConsumerProps = {
  totalConsumedcalories: number,
  totalcalories: number
}
const CalorieConsumer: React.FC<CalorieConsumerProps> = ({ totalConsumedcalories, totalcalories }) => {
  const [values, setVAlues] = React.useState(0)
  useEffect(() => {
    let vale = Math.round((totalConsumedcalories / totalcalories) * 100)

    if (isNaN(vale)) {
      setVAlues(0);
    } else {
      console.log("vale is a number");
      setVAlues(vale);
    }

  }, [totalConsumedcalories, totalcalories])
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
              valueSuffix={'%'}
              radius={23}
              activeStrokeWidth={3}
              inActiveStrokeWidth={3}
            />
            <View style={styles.textContainer}>
              <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                <Text style={styles.boldTitle}>{isNaN(totalConsumedcalories) ? 0 : totalConsumedcalories}</Text>
                <Text style={styles.regularTitle}>{" of " + totalcalories}</Text>
              </View>
              <Text style={styles.textBelowTitle}>Calories consumed today!</Text>
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
    borderColor: '#808080',
    borderRadius: 12,
    marginTop: 20,
    marginBottom: 5,
    overflow: 'hidden',
  },
  innerContainer: {
    backgroundColor: 'white',
    paddingHorizontal:Matrics.s(10)
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
