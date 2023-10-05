import {View, Text, StyleSheet, TouchableOpacity, FlatList} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import Video from 'react-native-video';
import {Icons} from '../../constants/icons';
type RoutineExercisesProps = {
  onPressOfDone: () => void;
  onpressOfVideo: () => void;
  exerciseData: any[];
};
const RoutineExercises: React.FC<RoutineExercisesProps> = ({
  onPressOfDone,
  onpressOfVideo,
  exerciseData = [],
}) => {
  const [showMore, setShowMore] = React.useState<boolean>(false);
  const [isPlayingList, setIsPlayingList] = React.useState<boolean[]>(
    Array(exerciseData.length).fill(false),
  );
  const [isDone, setIsDone] = React.useState<boolean[]>(
    Array(exerciseData.length).fill(false),
  );
  const [isDifficult, setIsDifficult] = React.useState<boolean[]>(
    Array(exerciseData.length).fill(false),
  );

  const handelReadMore = () => {
    setShowMore(!showMore);
  };

  const handlePlay = (index: number) => {
    const updatedIsPlayingList = [...isPlayingList];
    updatedIsPlayingList[index] = !updatedIsPlayingList[index];
    setIsPlayingList(updatedIsPlayingList);
  };

  const handleExerciseCompletion = (index: number) => {
    const updatedIsDoneList = [...isDone];
    updatedIsDoneList[index] = !updatedIsDoneList[index];
    setIsDone(updatedIsDoneList);
  };
  const handleLevleOfDifficulty = (index: number) => {
    const updatedIsDifficultList = [...isDifficult];
    updatedIsDifficultList[index] = !updatedIsDifficultList[index];
    setIsDifficult(updatedIsDifficultList);
  };

  return (
    <View style={styles.exerciseTab}>
      <FlatList
        data={exerciseData}
        showsVerticalScrollIndicator={false}
        renderItem={({item, index}: {item: any; index: number}) => {
          return (
            <View>
              <View style={styles.cardTitleContainer}>
                <Text style={styles.title}>Lungs</Text>
                <TouchableOpacity
                  style={styles.doneBtn}
                  onPress={() => handleExerciseCompletion(index)}>
                  {!isDone[index] ? <Icons.Pending /> : <Icons.DoneIcon />}
                  <Text style={styles.doneText}>Done</Text>
                </TouchableOpacity>
              </View>
              <View style={styles.vedioConatiner}>
                <View style={styles.video}>
                  <Video
                    source={item?.video}
                    style={styles.backgroundVideo}
                    resizeMode="cover"
                    paused={!isPlayingList[index]}
                    controls={true}
                  />
                  {!isPlayingList[index] ? (
                    <TouchableOpacity
                      onPress={() => handlePlay(index)}
                      style={{
                        position: 'absolute',
                        justifyContent: 'center',
                        alignItems: 'center',
                        width: '100%',
                        marginTop: '17%',
                      }}>
                      <Icons.Play />
                    </TouchableOpacity>
                  ) : null}
                  {item?.levle ? (
                    <View style={styles.dificultBtnContainer}>
                      <TouchableOpacity
                        style={styles.dificultBtn}
                        onPress={() => handleLevleOfDifficulty(index)}>
                        {!isDifficult[index] ? (
                          <Icons.Pending />
                        ) : (
                          <Icons.DoneIcon />
                        )}
                        <Text style={styles.doneText}>
                          {item?.levle}
                          {isDifficult[index] ? ': Easy' : null}
                        </Text>
                      </TouchableOpacity>
                    </View>
                  ) : null}
                </View>
                <View style={styles.videoDetails}>
                  <View style={styles.exerciseTypetextContainer}>
                    <View style={styles.textConteiner}>
                      <Text style={styles.exerciseTypeTitle}>
                        Exercise Type :{' '}
                      </Text>
                      <Text style={styles.exerciseTypeText}>Exercise</Text>
                    </View>
                    <View style={[styles.textConteiner, {marginLeft: 10}]}>
                      <Text style={styles.exerciseTypeTitle}>Reps : </Text>
                      <Text style={styles.exerciseTypeText}>1</Text>
                    </View>
                    <View style={[styles.textConteiner, {marginLeft: 10}]}>
                      <Text style={styles.exerciseTypeTitle}>Sets : </Text>
                      <Text style={styles.exerciseTypeText}>1</Text>
                    </View>
                  </View>
                  <View
                    style={[
                      styles.exerciseTypetextContainer,
                      {flexWrap: 'wrap'},
                    ]}>
                    <View style={styles.textConteiner}>
                      <Text style={styles.exerciseTypeTitle}>
                        Rest Post Sets :{' '}
                      </Text>
                      <Text style={styles.exerciseTypeText}>3 mins</Text>
                    </View>
                    <View style={styles.textConteiner}>
                      <Text style={styles.exerciseTypeTitle}>
                        Rest Post Exercise :{' '}
                      </Text>
                      <Text style={styles.exerciseTypeText}>10 mins</Text>
                    </View>
                    <View style={styles.line}></View>
                    <View>
                      {!showMore ? (
                        <View>
                          <Text
                            numberOfLines={2}
                            style={styles.exerciseTypeTitle}>
                            Venenatis id eget tincidunt enim adipiscing amet
                            sollicitudin feugiat. Eros pharetra phasellus urna
                            vitae
                          </Text>
                          <TouchableOpacity onPress={handelReadMore}>
                            <Text style={styles.readMore}>Read More</Text>
                          </TouchableOpacity>
                        </View>
                      ) : (
                        <View>
                          <Text style={styles.exerciseTypeTitle}>
                            Venenatis id eget tincidunt enim adipiscing amet
                            sollicitudin feugiat. Eros pharetra phasellus urna
                            vitae
                          </Text>
                          <TouchableOpacity onPress={handelReadMore}>
                            <Text style={styles.readMore}>Read less</Text>
                          </TouchableOpacity>
                        </View>
                      )}
                    </View>
                  </View>
                </View>
              </View>
            </View>
          );
        }}
      />
    </View>
  );
};

export default RoutineExercises;

const styles = StyleSheet.create({
  exerciseTab: {
    marginHorizontal: 20,
    justifyContent: 'space-between',
    marginBottom: '15%',
  },
  cardTitleContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 20,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: colors.darkBlue,
  },
  doneBtn: {
    height: 30,
    borderRadius: 6,
    backgroundColor: colors.white,
    borderRightColor: colors.stock,
    justifyContent: 'space-between',
    alignItems: 'center',
    flexDirection: 'row',
    borderRightWidth: 1,
    padding: 5,
  },
  dificultBtnContainer: {
    height: 30,
    position: 'absolute',
    width: '100%',
    justifyContent: 'flex-end',
    alignItems: 'flex-end',
    top: 10,
    right: 10,
  },
  dificultBtn: {
    height: 30,
    borderRadius: 6,
    backgroundColor: colors.white,
    borderRightColor: colors.stock,
    justifyContent: 'space-between',
    alignItems: 'center',
    flexDirection: 'row',
    borderRightWidth: 1,
    padding: 5,
  },
  doneDot: {
    height: 18,
    width: 18,
    borderRadius: 9,
    backgroundColor: colors.stock,
  },
  doneText: {
    color: colors.titleLightGray,
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 10,
  },
  vedioConatiner: {
    height: 310,
    backgroundColor: 'white',
    width: '100%',
    borderRadius: 20,
    overflow: 'hidden',
  },
  video: {
    flex: 0.5,
    height: 160,
  },
  videoDetails: {flex: 0.5, marginHorizontal: 10},
  exerciseTypetextContainer: {flexDirection: 'row', marginTop: 10},
  textConteiner: {flexDirection: 'row'},
  exerciseTypeTitle: {
    color: colors.titleLightGray,
    fontSize: 14,
    fontWeight: '500',
  },
  exerciseTypeText: {
    color: colors.darkBlue,
    fontSize: 14,
    fontWeight: '500',
  },
  line: {
    backgroundColor: colors.darkBlue,
    height: 0.2,
    width: '100%',
    marginVertical: 10,
  },
  readMore: {
    fontSize: 14,
    color: colors.themePurple,
    marginTop: 5,
  },
  backgroundVideo: {
    height: '100%',
    flex: 1,
  },
});
