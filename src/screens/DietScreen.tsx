import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import {StyleSheet, Text, View} from 'react-native';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';

import CalorieConsumer from '../components/molecules/CalorieConsumer';
import DietHeader from '../components/molecules/DietHeader';
import DietTime from '../components/Organisms/DietTime';
import {colors} from '../constants/colors';
import {
  AppStackParamList,
  BottomTabParamList,
} from '../interface/Navigation.interface';

type DietScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
  NativeStackScreenProps<AppStackParamList, 'DietScreen'>
>;

const DietScreen: React.FC<DietScreenProps> = ({navigation}) => {
  const onPressBack = () => {
    navigation.goBack();
  };
  return (
    <>
      <DietHeader onPressBack={onPressBack} />
      <View style={styles.belowContainer}>
        <CalorieConsumer />
        <DietTime />
      </View>
    </>
  );
};

const styles = StyleSheet.create({
  belowContainer: {
    flex: 1,
    marginBottom: 10,
    paddingHorizontal: 13,
    paddingVertical: 15,
    backgroundColor: colors.veryLightGreyishBlue,
  },
});

export default DietScreen;
