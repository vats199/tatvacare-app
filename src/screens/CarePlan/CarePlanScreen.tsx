import { View, Text } from 'react-native';
import React from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import {
  AppStackParamList,
  BottomTabParamList,
} from '../../interface/Navigation.interface';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView } from 'react-native-safe-area-context';

type CarePlanScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'CarePlanScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;
const CarePlanScreen: React.FC<CarePlanScreenProps> = () => {
  return (
    <SafeAreaView edges={['top']}>
      <Text>CarePlanScreen</Text>
    </SafeAreaView>
  );
};

export default CarePlanScreen;
