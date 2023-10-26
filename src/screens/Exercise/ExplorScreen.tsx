import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  TouchableOpacity,
} from 'react-native';
import React from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import { MaterialTopTabScreenProps } from '@react-navigation/material-top-tabs';
import { StackScreenProps } from '@react-navigation/stack';
import {
  TabParamList,
  AppStackParamList,
  ExerciesStackParamList,
  BottomTabParamList,
} from '../../interface/Navigation.interface';
import ExerciseCard from '../../components/molecules/ExerciseCard';
import ExplorExercies from '../../components/organisms/ExplorExercies';
import { colors } from '../../constants/colors';
import { DrawerScreenProps } from '@react-navigation/drawer';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';

type ExplorScreenProps = CompositeScreenProps<
  MaterialTopTabScreenProps<TabParamList, 'ExplorScreen'>,
  CompositeScreenProps<
    StackScreenProps<ExerciesStackParamList, 'ExplorScreen'>,
    CompositeScreenProps<
      BottomTabScreenProps<BottomTabParamList, 'Exercies'>,
      StackScreenProps<AppStackParamList, 'DrawerScreen'>
    >
  >
>;

const ExplorScreen: React.FC<ExplorScreenProps> = ({ route, navigation }) => {
  const [exerciseOfWeek, setExerciseOfWeek] = React.useState({
    id: 1,
    video: require('../../assets/video/Exercise.mp4'),
    levle: null,
    data: 'Eros pharetra phasellus urna vitae sollicitudin feugiat. Eros pharetra phasellus urna vitae Venenatis id eget tincidunt enim adipiscing amet sollicitudin feugiat. Eros pharetra phasellus urna vitae',
    isPlaying: false,
  });
  const exercise = [
    {
      id: 1,
      video: require('../../assets/video/Exercise.mp4'),
      levle: null,
      data: 'sollicitudin feugiat. Eros pharetra phasellus urna vitae sollicitudin feugiat. Eros pharetra phasellus urna vitae sollicitudin feugiat. Eros pharetra phasellus urna vitae',
      isPlaying: false,
    },
    {
      id: 2,
      video: require('../../assets/video/Workout.mp4'),
      levle: 'Difficulty',
      data: 'adipiscing amet sollicitudin feugiat. Eros pharetra phasellus urna vitae phasellus urna vitae sollicitudin feugiat. Eros pharetra phasellus',

      isPlaying: false,
    },
    {
      id: 3,
      video: require('../../assets/video/Exercise.mp4'),
      levle: 'Difficulty',
      data: 'tincidunt enim adipiscing amet sollicitudin feugiat. Eros pharetra phasellus urna vitae Venenatis id eget Venenatis id eget ',

      isPlaying: false,
    },
    {
      id: 4,
      video: require('../../assets/video/Workout.mp4'),
      levle: 'Difficulty',
      data: 'Eros pharetra phasellus urna vitae, Venenatis id eget tincidunt enim adipiscing amet sollicitudin feugiat.',
      isPlaying: false,
    },
  ];
  const handlePlay = () => { };
  const handleViewMore = () => {
    navigation.navigate('ExerciseDetailScreen', { Data: exercise });
  };

  return (
    <ScrollView style={{ flex: 1 }} showsVerticalScrollIndicator={false}>
      <View style={styles.Container}>
        <View style={styles.titleContainer}>
          <Text style={styles.title}>Exercise Of the week</Text>
        </View>
        <ExerciseCard
          exerciseData={exerciseOfWeek}
          onPlayPause={() => handlePlay}
        />
      </View>
      <View>
        <View style={styles.titleContainer2}>
          <Text style={styles.title2}>{'Breathing'}</Text>
          <TouchableOpacity onPress={handleViewMore}>
            <Text style={styles.ViewMore}>View More</Text>
          </TouchableOpacity>
        </View>
        <ExplorExercies exerciseCardData={exercise} />
      </View>
      <View>
        <View style={styles.titleContainer2}>
          <Text style={styles.title2}>{'Walking'}</Text>
          <TouchableOpacity onPress={handleViewMore}>
            <Text style={styles.ViewMore}>View More</Text>
          </TouchableOpacity>
        </View>
        <ExplorExercies exerciseCardData={exercise} />
      </View>
    </ScrollView>
  );
};

export default ExplorScreen;
const styles = StyleSheet.create({
  Container: {
    marginHorizontal: 15,
  },
  titleContainer: {
    flexDirection: 'row',
    marginVertical: 10,
    marginTop: 20,
  },
  title: {
    fontSize: 22,
    color: colors.darkBlue,
    fontWeight: '600',
  },
  ViewMore: {
    fontSize: 16,
    color: colors.themePurple,
    fontWeight: '500',
  },
  titleContainer2: {
    flexDirection: 'row',
    marginHorizontal: 20,
    justifyContent: 'space-between',
    marginTop: 20,
  },
  title2: {
    fontSize: 22,
    color: colors.darkBlue,
    fontWeight: '600',
  },
});
