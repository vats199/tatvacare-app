import {StyleSheet, Text, View, TextInput} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';
import {
  AppStackParamList,
  BottomTabParamList,
} from '../interface/Navigation.interface';
import RecentSearchDiet from '../components/Organisms/RecentSearchFood';
import DietSearchHeader from '../components/molecules/DietSearchHeader';
import {colors} from '../constants/colors';

type AddFoodScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
  NativeStackScreenProps<AppStackParamList, 'DietScreen'>
>;

const AddDietScreen: React.FC<AddFoodScreenProps> = ({navigation}) => {
  const onPressBack = () => {
    navigation.goBack();
  };
  const onPressPlus = () => {
    navigation.navigate('DietDetail');
  };

  return (
    <View style={styles.container}>
      <DietSearchHeader onPressBack={onPressBack} />
      <RecentSearchDiet onPressPlus={onPressPlus} />
    </View>
  );
};

export default AddDietScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 15,
    backgroundColor: colors.lightGreyishBlue,
  },
});
