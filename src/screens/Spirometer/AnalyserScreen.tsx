import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
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
import {Fonts, Matrics} from '../../constants';
import Button from '../../components/atoms/Button';

type AnalyserScreenProps = CompositeScreenProps<
  StackScreenProps<AppStackParamList>,
  StackScreenProps<HomeStackParamList>
>;
const LungTab = createMaterialTopTabNavigator<LungTabParamList>();

const AnalyserScreen: React.FC<AnalyserScreenProps> = ({navigation, route}) => {
  const insets = useSafeAreaInsets();

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
      <View
        style={[
          styles.bottomBtnContainerShadow,
          styles.bottonBtnContainer,
          {
            paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(16),
          },
        ]}>
        <Button
          title="Connect"
          titleStyle={styles.saveBtnTxt}
          buttonStyle={{
            borderRadius: Matrics.s(19),
          }}
          onPress={() => {}}
        />
      </View>
    </SafeAreaView>
  );
};

export default AnalyserScreen;

const styles = StyleSheet.create({
  bottomBtnContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
  bottonBtnContainer: {
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(8),
  },
  saveBtnTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
  },
});
