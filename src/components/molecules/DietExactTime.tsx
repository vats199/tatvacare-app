import {DrawerItemList} from '@react-navigation/drawer';
import React from 'react';
import {StyleSheet, Text, View} from 'react-native';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import DietOption from './DietOption';

interface ExactTimeProps {
  title: string;
  message: string;
  onPressPlus: () => void;
  dietOption: boolean;
}

const DietExactTime: React.FC<ExactTimeProps> = ({
  title,
  message,
  onPressPlus,
  dietOption,
}) => {
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
          <Icons.AddCircle onPress={onPressPlus} height={25} width={25} />
        </View>
        <View style={styles.line} />
        <View style={styles.belowRow}>
          {dietOption && title === 'Breakfast' ? (
            <DietOption />
          ) : (
            <View style={styles.messageContainer}>
              <Text>{message}</Text>
            </View>
          )}
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    borderColor: 'white',
    borderRadius: 12,
    marginVertical: 8,
    overflow: 'hidden',
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  topRow: {
    paddingHorizontal: 18,
    paddingVertical: 8,
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
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.labelDarkGray,
  },
  textBelowTitle: {
    fontSize: 13,
    color: '#444444',
  },
  line: {
    borderBottomWidth: 0.2,
    borderColor: '#808080',
  },
  belowRow: {
    padding: 15,
  },
  messageContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  message: {
    fontSize: 13,
    color: '#C5C5C5',
  },
});

export default DietExactTime;
