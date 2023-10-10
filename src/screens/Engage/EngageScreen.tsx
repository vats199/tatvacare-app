import { View, Text } from 'react-native'
import React from 'react'
import { CompositeScreenProps } from '@react-navigation/native';
import { AppStackParamList, BottomTabParamList } from '../../interface/Navigation.interface';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { StackScreenProps } from '@react-navigation/stack';

type EngageScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'EngageScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;
const EngageScreen: React.FC<EngageScreenProps> = () => {
  return (
    <View>
      <Text>EngageScreen</Text>
    </View>
  )
}

export default EngageScreen