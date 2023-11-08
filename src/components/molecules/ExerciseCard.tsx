import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Image,
  Modal,
} from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import Video from 'react-native-video';
import { Icons } from '../../constants/icons';
type ExerciseCardProps = {
  // onPressOfDone: () => void;
  // onpressOfVideo: () => void;
  exerciseData: object;
  onPlayPause: () => void;
};
const ExerciseCard: React.FC<ExerciseCardProps> = ({
  exerciseData,
  onPlayPause,
}) => {
  const [modalVisible, setModalVisible] = React.useState<boolean>(false);
  const [showMore, setShowMore] = React.useState<boolean>(false);
  const handelReadMore = () => {
    setShowMore(!showMore);
  };

  const handlePlayPause = () => {
    onPlayPause();
  };
  const handle = () => { };
  return (
    <View style={styles?.shadowContainer}>
      <View style={styles.vedioConatiner}>
        <View style={styles.video}>
          <Video
            source={exerciseData?.video}
            style={styles.backgroundVideo}
            resizeMode="cover"
            paused={!exerciseData?.isPlaying}
            controls={true}
          />
          <TouchableOpacity
            onPress={handlePlayPause}
            style={{
              position: 'absolute',
              justifyContent: 'center',
              alignItems: 'center',
              width: '100%',
              marginTop: '12%',
            }}>
            {!exerciseData?.isPlaying ? <Icons.Play /> : null}
          </TouchableOpacity>
        </View>
        <View style={styles.videoDetails}>
          <Text style={styles.exerciseTypeText}>Biceps Stretch</Text>
          <View style={[styles.exerciseTypetextContainer, { flexWrap: 'wrap' }]}>
            <View style={styles.textConteiner}>
              <Text style={styles.exerciseToolText}>
                {'Fitness level:' + exerciseData?.levle}
              </Text>
            </View>
            <View style={[styles.textConteiner, { marginLeft: '2%' }]}>
              <Text style={styles.exerciseToolText}>
                Exercise tool: Non-EquiomentS
              </Text>
            </View>

            <View>
              <Text numberOfLines={2} style={styles.exerciseTypeTitle}>
                {exerciseData?.data}
              </Text>
              <View style={{ flexDirection: 'row' }}>
                <TouchableOpacity onPress={handelReadMore}>
                  <Image
                    style={{ height: 18, width: 18, margin: 5 }}
                    source={require('../../assets/images/like.png')}
                  />
                </TouchableOpacity>
                <TouchableOpacity onPress={handelReadMore}>
                  <Image
                    style={{ height: 18, width: 18, margin: 5 }}
                    source={require('../../assets/images/save.png')}
                  />
                </TouchableOpacity>
                <TouchableOpacity onPress={() => setModalVisible(!modalVisible)}>
                  <Image
                    style={{ height: 18, width: 18, margin: 5 }}
                    source={require('../../assets/images/info.png')}
                  />
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </View>
        <Modal
          animationType='fade'
          transparent={true}
          visible={modalVisible}
          onRequestClose={() => {
            setModalVisible(!modalVisible);
          }}>
          <View style={styles.centeredView}>
            <View style={styles.modalView}>
              <TouchableOpacity
                onPress={() => setModalVisible(!modalVisible)}
                style={styles.buttonClose}>
                <Text>X</Text>
              </TouchableOpacity>
              <Text style={styles.modalTitle}>Biceps Stretch</Text>
              <Text style={styles.modalText}> {exerciseData?.data}</Text>
              <TouchableOpacity
                style={styles.okButton}
                onPress={() => setModalVisible(!modalVisible)}>
                <Text style={styles.textStyle}> OK </Text>
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      </View>
    </View>
  );
};

export default ExerciseCard;

const styles = StyleSheet.create({
  exerciseTab: {
    marginHorizontal: 20,
    justifyContent: 'space-between',
    backgroundColor: 'red',
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
    width: '85%',
    justifyContent: 'flex-end',
    alignItems: 'flex-end',
    top: 10,
    right: 10,
    left: 30,
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
    height: 260,
    backgroundColor: 'white',
    borderRadius: 20,
    overflow: 'hidden',
  },
  video: {
    flex: 0.5,
    height: 10,
  },
  videoDetails: { flex: 0.5, marginHorizontal: 10 },
  exerciseTypetextContainer: { flexDirection: 'row', marginTop: 10 },
  textConteiner: {
    backgroundColor: colors.stock,
    borderRadius: 3,
  },
  exerciseTypeTitle: {
    color: colors.titleLightGray,
    fontSize: 13,
    fontWeight: '500',
    marginTop: '3%',
  },
  exerciseTypeText: {
    color: colors.darkBlue,
    fontSize: 16,
    fontWeight: '500',
    marginTop: '3%',
  },
  exerciseToolText: {
    color: colors.darkBlue,
    fontSize: 11,
    padding: 2,
  },

  backgroundVideo: {
    height: '100%',
    flex: 1,
  },
  emptyListContainer: {
    flex: 1,
  },
  restText: {
    fontSize: 24,
    textAlign: 'center',
    color: colors.darkBlue,
    fontWeight: '600',
  },
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.7)',
  },
  modalView: {
    margin: 20,
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 35,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },
  button: {
    borderRadius: 20,
    padding: 10,
    elevation: 2,
  },
  buttonClose: {
    backgroundColor: colors.darkGray,
    height: 18,
    width: 18,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 8,
    position: 'absolute',
    right: -7,
    top: -7,
  },
  okButton: {
    height: 30,
    backgroundColor: colors.themePurple,
    width: 80,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 5,
  },
  textStyle: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  },
  modalText: {
    marginBottom: 15,
    textAlign: 'left',
  },
  modalTitle: {
    color: colors.darkBlue,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 15,
    fontSize: 18,
  },
  shadowContainer: {
    shadowOffset: { width: -2, height: 2 },
    shadowColor: colors.shadow,
    shadowOpacity: 0.3,
    shadowRadius: 3,
    elevation: 3,
  },
});
