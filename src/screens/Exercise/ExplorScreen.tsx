import {View, Text} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {MaterialTopTabScreenProps} from '@react-navigation/material-top-tabs';
import {StackScreenProps} from '@react-navigation/stack';
import {
  TabParamList,
  AppStackParamList,
} from '../../interface/Navigation.interface';

type ExplorScreenProps = CompositeScreenProps<
  MaterialTopTabScreenProps<TabParamList, 'ExplorScreen'>,
  StackScreenProps<AppStackParamList, 'TabScreen'>
>;
 
const ExplorScreen: React.FC<ExplorScreenProps> = ({route, navigation}) => {
  return (
    <View>
      <Text>ExplorScreen</Text>
    </View>
  );
};

export default ExplorScreen;
