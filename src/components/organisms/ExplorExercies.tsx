import {
  View,
  Text,
  FlatList,
  StyleSheet,
  Dimensions,
  Image,
} from 'react-native';
import React from 'react';
import ExerciseCard from '../molecules/ExerciseCard';
import {colors} from '../../constants/colors';
import Video from 'react-native-video';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {Icons} from '../../constants/icons';

const {width} = Dimensions.get('window');
type ExplorExerciesProps = {
   exerciseCardData: any[];
};

const ExplorExercies: React.FC<ExplorExerciesProps> = ({
   exerciseCardData = [],
}) => {
  const [data, setData] = React.useState(exerciseCardData);

  const handlePlayPause = (id: number) => {
    const updatedArray = data.map(item => ({
      ...item,
      isPlaying: id === item?.id ? true : false,
    }));
    setData(updatedArray);
  };
 
  const rendringData = ({item, index}: {item: any; index: number}) => {
    return (
      <View style={styles.vedioConatiner}>
        <ExerciseCard
          exerciseData={item}
          onPlayPause={() => handlePlayPause(item?.id)}
        />
      </View>
    );
  };

  return (
    <View style={styles.Container}>
    <FlatList
        horizontal={true}
        data={data}
        renderItem={rendringData}
        keyExtractor={(_item, index) => index.toString()}
        showsHorizontalScrollIndicator={false}
        nestedScrollEnabled={false}
        contentContainerStyle={{marginHorizontal: 10}}
      />
    </View>
  );
};

export default ExplorExercies;
const styles = StyleSheet.create({
  Container: {
    width: '100%',
    marginVertical: 10,
  },
  item: {
    width: 150,
    height: 100,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#e0e0e0',
    margin: 10,
    borderRadius: 8,
  },
  vedioConatiner: {
    height: 260,
    backgroundColor: 'red',
    borderRadius: 20,
    overflow: 'hidden',
    width: width - 40,
    marginHorizontal: 5,
  },
  titleContainer: {
    flexDirection: 'row',
    marginHorizontal: 20,
    justifyContent: 'space-between',
    marginVertical: 10,
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
});
