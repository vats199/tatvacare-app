import {View, Text} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {
  EngageStackParamList,
  BottomTabParamList,
  AppStackParamList,
} from '../../interface/Navigation.interface';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';
import {StackScreenProps} from '@react-navigation/stack';

type EngageDetailScreenProps = CompositeScreenProps<
  StackScreenProps<EngageStackParamList, 'EngageDetailScreen'>,
  CompositeScreenProps<
    BottomTabScreenProps<BottomTabParamList, 'EngageScreen'>,
    StackScreenProps<AppStackParamList, 'DrawerScreen'>
  >
>;

const EngageDetailScreen: React.FC<EngageDetailScreenProps> = () => {
  return (
    <View>
      <Text>EngageDetailScreen</Text>
    </View>
  );
};

export default EngageDetailScreen;
