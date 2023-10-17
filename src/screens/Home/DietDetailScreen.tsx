import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';
import {
  AppStackParamList,
  BottomTabParamList,
  HomeStackParamList
} from '../../interface/Navigation.interface';
import {Icons} from '../../constants/icons';
import { colors } from '../../constants/colors';
import MicronutrientsInformation from '../../components/organisms/MicronutrientsInformation';
import AddDiet from '../../components/organisms/AddDiet';
import {StackScreenProps} from '@react-navigation/stack';

type DietDetailProps = CompositeScreenProps<
  StackScreenProps<HomeStackParamList, 'DietDetail'>,
  CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
  >
>;
const DietDetailScreen: React.FC<DietDetailProps> = ({navigation}) => {
  const onPressBack = () => {
    navigation.goBack();
  };

  const onPressAdd = () => {
    navigation.navigate('DietScreen', {dietData: {title: 'add'}});
  };

  return (
    <View style={{flex: 1, backgroundColor: colors.lightGreyishBlue}}>
      <View style={styles.header}>
        <Icons.backArrow onPress={onPressBack} height={23} width={23} />
        <Text style={styles.dietTitle}>Chapati</Text>
      </View>
      <View style={styles.belowContainer}>
        <MicronutrientsInformation />
        <AddDiet onPressAdd={onPressAdd} />
      </View>
    </View>
  );
};

export default DietDetailScreen;

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 30,
    marginBottom: 20,
    marginLeft: 15,
  },
  dietTitle: {
    fontSize: 19,
    fontWeight: 'bold',
    color: colors.black,
    marginLeft: 10,
  },
  belowContainer: {
    flex: 1,
    justifyContent: 'space-between',
    marginBottom: 10,
  },
});
