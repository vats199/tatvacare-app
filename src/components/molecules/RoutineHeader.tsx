import {View, Text, StyleSheet} from 'react-native';
import {colors} from '../../constants/colors';
import React from 'react';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {Icons} from '../../constants/icons';

type RoutineHeaderProps = {
  date: String;
  Vadlidity: String;
};
const RoutineHeader: React.FC<RoutineHeaderProps> = ({date, Vadlidity}) => {
  return (
    <View style={styles.haederContainer}>
      <View style={styles.headerTitleContainer}>
        <Text style={styles.headerTitle}> Exercise Plan Name</Text>
        <View style={styles.dateBox}>
          <Icons.calendar />
          <Text style={styles.dateText}>{date}</Text>
        </View>
      </View>
      <Text style={styles.haederContent}>{Vadlidity}</Text>
      <View style={styles.routineTab}>
        <TouchableOpacity>
          <Text style={styles.routineText}> Routine 1 </Text>
          <View style={styles.routineTabUnderline}></View>
        </TouchableOpacity>
        <TouchableOpacity>
          <Text
            style={[
              styles.routineText,
              {color: colors.darkBlue, fontWeight: '400'},
            ]}>
            {' '}
            Routine 2{' '}
          </Text>
        </TouchableOpacity>
        <TouchableOpacity>
          <Text
            style={[
              styles.routineText,
              {color: colors.darkBlue, fontWeight: '400'},
            ]}>
            {' '}
            Routine 3{' '}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

export default RoutineHeader;

const styles = StyleSheet.create({
  haederContainer: {
    flex: 0.2,
    margin: 5,
    marginHorizontal: 20,
    marginTop: 20,
  },
  headerTitleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  headerTitle: {
    fontSize: 22,
    fontWeight: '700',
  },
  dateBox: {
    height: 30,
    width: 103,
    borderRightColor: colors.darkBlue,
    borderWidth: 1,
    flexDirection: 'row',
    borderRadius: 6,
    justifyContent: 'center',
    alignItems: 'center',
  },
  dateText: {
    color: colors.darkBlue,
    fontSize: 12,
    textAlign: 'center',
    marginLeft: 2
  },
  haederContent: {fontSize: 14, color: colors.darkBlue, marginTop: 12},
  cardTitleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 20,
  },
  routineTab: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 12,
  },
  routineText: {
    color: colors.themePurple,
    fontSize: 16,
    fontWeight: '700',
  },
  routineTabUnderline: {
    backgroundColor: colors.themePurple,
    height: 4,
    borderRadius: 4,
    marginTop: 10,
  },
});
