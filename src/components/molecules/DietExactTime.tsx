import React from 'react';
import {StyleSheet, Text, View} from 'react-native';
import {Icons} from '../../constants/icons';

interface ExactTimeProps {
  title: string;
  message: string;
}

const DietExactTime: React.FC<ExactTimeProps> = ({title, message}) => {
  return (
    <View style={styles.container}>
      <View style={styles.innerContainer}>
        <View style={styles.topRow}>
          <View style={styles.leftContent}>
            <View style={styles.circle} />
            <View style={styles.textContainer}>
              <Text style={styles.title}>{title}</Text>
              <Text style={styles.textBelowTitle}>
                Ideal Time | 0 of 600 cal
              </Text>
            </View>
          </View>
          <Icons.AddCircle />
        </View>
        <View style={styles.line} />
        <View style={styles.belowRow}>
          <Text style={styles.message}>{message}</Text>
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    borderColor: '#808080',
    borderRadius: 8,
    marginVertical: 8,
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
  circle: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#F3F3F3',
    marginRight: 10,
  },
  textContainer: {
    flex: 1,
  },
  title: {
    fontSize: 17,
    fontWeight: 'bold',
    color: '#313131',
  },
  textBelowTitle: {
    fontSize: 14,
    color: '#444444',
  },
  line: {
    borderBottomWidth: 0.4,
    borderColor: 'black',
  },
  belowRow: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 15,
  },
  message: {
    fontSize: 14,
    color: '#C5C5C5',
  },
});

export default DietExactTime;
