import {
  View,
  Text,
  FlatList,
  StyleSheet,
  Dimensions,
  SafeAreaView,
} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {DrawerScreenProps} from '@react-navigation/drawer';
import {StackScreenProps} from '@react-navigation/stack';
import {
  AppStackParamList,
  DrawerParamList,
} from '../../interface/Navigation.interface';
import ExerciseCard from '../../components/molecules/ExerciseCard';
import {colors} from '../../constants/colors';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {Icons} from '../../constants/icons';
const {width} = Dimensions.get('window');

type ExerciseDetailProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'ExerciseDetailScreen'>,
  StackScreenProps<AppStackParamList, 'TabScreen'>
>;
const ExerciseDetailScreen: React.FC<ExerciseDetailProps> = ({
  route,
  navigation,
}) => {
  const {Data} = route?.params;
  const [data, setData] = React.useState(Data);

  const handlePlayPause = (id: number) => {
    const updatedArray = data.map((item: any) => ({
      ...item,
      isPlaying: id === item?.id ? true : false,
    }));
    setData(updatedArray);
  };

  const handleBackButton = () => {
    navigation.goBack()
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
    <SafeAreaView>
      <TouchableOpacity onPress={handleBackButton} style={styles.backArrowConatiner}>
        <Icons.backArrow />
        <Text style={styles.title2}>{'Breathing'}</Text>
      </TouchableOpacity>
      <FlatList
        data={data}
        renderItem={rendringData}
        showsVerticalScrollIndicator={false}
        nestedScrollEnabled={false}
      />
    </SafeAreaView>
  );
};

export default ExerciseDetailScreen;

const styles = StyleSheet.create({
  vedioConatiner: {
    height: 260,
    backgroundColor: 'red',
    borderRadius: 20,
    overflow: 'hidden',
    width: width - 40,
    marginHorizontal: 20,
    marginVertical: 10,
  },
  title2: {
    fontSize: 22,
    color: colors.darkBlue,
    fontWeight: '600',
    lineHeight: 22,
    marginLeft: 10,
  },
  backArrowConatiner: {
    flexDirection: 'row',
    marginTop: 20,
    marginHorizontal: 20,
  },
});
