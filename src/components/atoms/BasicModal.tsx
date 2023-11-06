import {View, Text, Modal, TouchableOpacity, StyleSheet} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

type BasicModalProps = {
  modalVisible: boolean;
  messgae: string;
  onPressOK: () => void;
  onPressCancle: () => void;
  positiveButtonText: string;
  NegativeButtonsText: string;
};

const BasicModal: React.FC<BasicModalProps> = ({
  modalVisible,
  messgae,
  onPressOK,
  onPressCancle,
  positiveButtonText,
  NegativeButtonsText,
}) => {
  return (
    <View>
      <Modal animationType="fade" transparent={true} visible={modalVisible}>
        <View style={styles.centeredView}>
          <View style={styles.modalView}>
            <Text style={styles.modalTitle}>{messgae}</Text>

            <View style={{flexDirection: 'row'}}>
              <TouchableOpacity style={styles.okButton} onPress={onPressOK}>
                <Text style={styles.textStyle}>{positiveButtonText} </Text>
              </TouchableOpacity>
              <TouchableOpacity style={styles.okButton} onPress={onPressCancle}>
                <Text style={styles.textStyle}>{NegativeButtonsText}</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
};

export default BasicModal;

const styles = StyleSheet.create({
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
  okButton: {
    height: 30,
    backgroundColor: colors.themePurple,
    width: 80,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 5,
    marginHorizontal: 10,
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
});
