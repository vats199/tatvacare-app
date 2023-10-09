import React, {useState, useEffect} from 'react';
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

const DietScreen: React.FC<DietScreenProps> = ({navigation, route}) => {
  const title = route.params?.dietData;
  const [dietOption, setDietOption] = useState<boolean>(false);

  useEffect(() => {
    if (title) {
      setDietOption(true);
    } else {
      setDietOption(false);
    }
  }, [title]);

  const onPressBack = () => {
    navigation.goBack();
  };
  const onPressPlus = () => {
    navigation.navigate('AddDiet');
  };

  return (
    <View style={{flex: 1}}>
      <DietHeader onPressBack={onPressBack} />
      <View style={styles.belowContainer}>
        <CalorieConsumer />
        <DietTime onPressPlus={onPressPlus} dietOption={dietOption} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  belowContainer: {
    flex: 1,
    paddingHorizontal: 15,
    backgroundColor: colors.veryLightGreyishBlue,
    paddingBottom: 30,
  },
});

export default DietScreen;
