import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';

interface RecentDietItemProps {
  title: string;
  message: string;
  calorieValue: number;
  onPressPlus: () => void;
}

const RecentDietItem: React.FC<RecentDietItemProps> = ({
  title,
  message,
  calorieValue,
  onPressPlus,
}) => {
  return (
    <View style={styles.container}>
      <View>
        <Text style={styles.titleText}>{title}</Text>
        <Text style={styles.messageText}>{message}</Text>
      </View>
      <View style={styles.leftContainer}>
        <Text style={styles.calorieText}>{calorieValue}cal</Text>
        <Icons.AddCircle height={25} width={25} onPress={onPressPlus} />
      </View>
    </View>
  );
};

export default RecentDietItem;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 6,
  },
  titleText: {
    fontSize: 17,
    // fontWeight: 'bold',
    color: colors.labelDarkGray,
  },
  messageText: {
    fontSize: 13,
  },
  calorieText: {
    fontSize: 15,
    color: colors.labelDarkGray,
    marginRight: 10,
  },
  leftContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
});
