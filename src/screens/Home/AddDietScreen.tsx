import {StyleSheet, Text, View, TextInput} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';
import {
  AppStackParamList,
  BottomTabParamList,
  HomeStackParamList
} from '../../interface/Navigation.interface';
import RecentSearchDiet from '../../components/organisms/RecentSearchFood';
import DietSearchHeader from '../../components/molecules/DietSearchHeader';
import {colors} from '../../constants/colors';
import {StackScreenProps} from '@react-navigation/stack';

type AddDietScreenProps = CompositeScreenProps<
  StackScreenProps<HomeStackParamList, 'AddDiet'>,
  CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
  >
>;

const AddDietScreen: React.FC<AddDietScreenProps> = ({navigation}) => {
  const onPressBack = () => {
    navigation.goBack();
  };
  const onPressPlus = () => {
    navigation.navigate('DietDetail');
  };
console.log("data");

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
