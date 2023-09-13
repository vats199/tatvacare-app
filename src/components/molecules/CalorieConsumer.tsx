import React from 'react';
import {StyleSheet, View, Text} from 'react-native';
import {Icons} from '../../constants/icons';
import CircularProgress from 'react-native-circular-progress-indicator';

const CalorieConsumer: React.FC = () => {
  return (
    <View style={styles.container}>
      <View style={styles.innerContainer}>
        <View style={styles.topRow}>
          <View style={styles.leftContent}>
            <CircularProgress
              value={85}
              inActiveStrokeColor={'#2ecc71'}
              inActiveStrokeOpacity={0.2}
              progressValueColor={'green'}
              valueSuffix={'%'}
              radius={23}
              activeStrokeWidth={3}
              inActiveStrokeWidth={3}
            />
            <View style={styles.textContainer}>
              <View style={{flexDirection: 'row', alignItems: 'center'}}>
                <Text style={styles.boldTitle}>120 </Text>
                <Text style={styles.regularTitle}>of 2300</Text>
              </View>
              <Text style={styles.textBelowTitle}>Calories Consumed Today</Text>
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
    borderRadius: 6,

    overflow: 'hidden',
  },
  innerContainer: {
    backgroundColor: 'white',
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
  icon: {
    marginRight: 10,
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
