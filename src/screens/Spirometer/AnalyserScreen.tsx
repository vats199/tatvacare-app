import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {SafeAreaView} from 'react-native-safe-area-context';
import {colors} from '../../constants/colors';
import {CompositeScreenProps} from '@react-navigation/native';
import {
  AppStackParamList,
  HomeStackParamList,
  LungTabParamList,
} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import CommonHeader from '../../components/molecules/CommonHeader';
import {createMaterialTopTabNavigator} from '@react-navigation/material-top-tabs';
import HealthInsightsScreen from './HealthInsightsScreen';
import ExerciseInsights from './ExerciseInsights';
import {Matrics} from '../../constants';

type AnalyserScreenProps = CompositeScreenProps<
  StackScreenProps<AppStackParamList>,
  StackScreenProps<HomeStackParamList>
>;
const LungTab = createMaterialTopTabNavigator<LungTabParamList>();

const AnalyserScreen: React.FC<AnalyserScreenProps> = ({navigation, route}) => {
  console.log('🚀 ~ file: AnalyserScreen.tsx:18 ~ route:', route);

  const onPressBackArrow = () => {
    navigation.goBack();
  };
  const header =
    route?.params?.type == 'Lung Health'
      ? 'Lung Function Analyser'
      : 'Lung Exercise';

  return (
    <SafeAreaView
      edges={['top']}
      style={{
        flex: 1,
        backgroundColor: colors.lightPurple,
      }}>
      <CommonHeader title={header} onPress={onPressBackArrow} />
      <LungTab.Navigator
        initialRouteName={
          route?.params?.type == 'Lung Health'
            ? 'HealthInsightsScreen'
            : 'ExerciseInsightsScreen'
        }
        screenOptions={{
          tabBarActiveTintColor: colors.themePurple,
          tabBarInactiveTintColor: colors.tabTitleColor,
          tabBarLabelStyle: {
            textAlign: 'center',
            fontSize: 18,
            textTransform: 'none',
            fontWeight: '600',
          },
          tabBarIndicatorStyle: {
            borderBottomColor: colors.themePurple,
            borderBottomWidth: Matrics.vs(2),
            borderRadius: Matrics.vs(3),
          },
          tabBarStyle: {backgroundColor: colors.lightPurple},
        }}>
        <LungTab.Screen
          name={'HealthInsightsScreen'}
          component={HealthInsightsScreen}
          options={{tabBarLabel: 'Health Insights'}}
        />
        <LungTab.Screen
          name={'ExerciseInsightsScreen'}
          component={ExerciseInsights}
          options={{tabBarLabel: 'Exercise Insights'}}
        />
      </LungTab.Navigator>
    </SafeAreaView>
  );
};

export default AnalyserScreen;

const styles = StyleSheet.create({});
