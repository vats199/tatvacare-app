import {ScrollView, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {MaterialTopTabScreenProps} from '@react-navigation/material-top-tabs';
import {
  AppStackParamList,
  TabParamList,
} from '../../interface/Navigation.interface';
import {colors} from '../../constants/colors';
import {StackScreenProps} from '@react-navigation/stack';
import RoutineHeader from '../../components/molecules/RoutineHeader';
import RoutineExercises from '../../components/molecules/RoutineExercises';

type ExerciseScreenProps = CompositeScreenProps<
  MaterialTopTabScreenProps<TabParamList, 'RoutineScreen'>,
  StackScreenProps<AppStackParamList, 'TabScreen'>
>;

const RoutineScreen: React.FC<ExerciseScreenProps> = ({navigation, route}) => {
  const exercise = [
    {id: 1, video: require('../../assets/video/Exercise.mp4'), levle: null},
    {id: 2, video: require('../../assets/video/Workout.mp4'), levle: 'Difficulty'},
    {id: 3, video: require('../../assets/video/Exercise.mp4'), levle: 'Difficulty'},
    {id: 4, video: require('../../assets/video/Workout.mp4'), levle: 'Difficulty'},
  ];
  const handleDone = () => {};
  const handleVedio = () => {};
  return (
    <ScrollView style={styles.container}>
      <RoutineHeader
        date={'17 Mar 2023'}
        Vadlidity={'Valid from 17 Mar 2023 to 21 Mar 2023'}
      />
      <View style={styles.exerciesContainer}>
        <RoutineExercises
          onPressOfDone={handleDone}
          onpressOfVideo={handleVedio}
          exerciseData={exercise}
        />
      </View>
    </ScrollView>
  );
};

export default RoutineScreen;

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: 'orange',
  },
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
  haederContainer: {flex: 0.15, margin: 5, marginHorizontal: 20},
  headerTitleContainer: {flexDirection: 'row', justifyContent: 'space-between'},
  headerTitle: {fontSize: 22, fontWeight: '700'},
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
    fontSize: 13,
    textAlign: 'center',
  },
  haederContent: {fontSize: 14, color: colors.darkBlue, marginTop: 12},
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
  exerciesContainer: {
    backgroundColor: colors.lightGray,
    flex: 0.85,
    borderRadius: 30,
  },
});
