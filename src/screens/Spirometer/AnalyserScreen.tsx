import {
  Platform,
  StyleSheet,
  Switch,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useRef, useState} from 'react';
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
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import {BottomSheetModal} from '@gorhom/bottom-sheet';
import {Icons} from '../../constants/icons';

type AnalyserScreenProps = CompositeScreenProps<
  StackScreenProps<AppStackParamList>,
  StackScreenProps<HomeStackParamList>
>;
const LungTab = createMaterialTopTabNavigator<LungTabParamList>();

const AnalyserScreen: React.FC<AnalyserScreenProps> = ({navigation, route}) => {
  const insets = useSafeAreaInsets();
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);

  const [isEnabled, setIsEnabled] = useState(false);
  const toggleSwitch = () => setIsEnabled(previousState => !previousState);

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
      <MyStatusbar backgroundColor={colors.lightGreyishBlue} />
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
            fontSize: Matrics.mvs(18),
            fontFamily: Fonts.MEDIUM,
            textTransform: 'none',
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
      <CommonBottomSheetModal
        ref={bottomSheetModalRef}
        snapPoints={['50%']}
        index={0}>
        <View style={{flex: 1, backgroundColor: colors.white}}>
          <Text
            style={{
              marginHorizontal: Matrics.s(15),
              fontFamily: Fonts.BOLD,
              fontSize: Matrics.mvs(17),
              color: colors.labelTitleDarkGray,
            }}>
            Connect Lung Function Analyser
          </Text>
          <View
            style={{
              height: Matrics.vs(1),
              backgroundColor: '#E9E9E9',
              marginVertical: Matrics.vs(10),
            }}
          />
          <View
            style={{
              flexDirection: 'row',
              justifyContent: 'space-between',
              marginHorizontal: Matrics.s(15),
              alignItems: 'center',
            }}>
            <Text
              style={{
                fontFamily: Fonts.MEDIUM,
                fontSize: Matrics.mvs(15),
                color: colors.labelTitleDarkGray,
              }}>
              Bluetooth
            </Text>
            <Switch
              trackColor={{
                false: colors.switchBackgroundColor,
                true: colors.switchBackgroundColor,
              }}
              thumbColor={colors.white}
              ios_backgroundColor={colors.switchBackgroundColor}
              onValueChange={toggleSwitch}
              value={isEnabled}
            />
          </View>
          <View
            style={{
              height: Matrics.vs(1),
              backgroundColor: '#E9E9E9',
              marginVertical: Matrics.vs(10),
              marginHorizontal: Matrics.s(15),
            }}
          />
          {/* <Icons.bl */}
          <View
            style={{
              alignItems: 'center',
              flex: 1,
              justifyContent: 'center',
            }}>
            <Icons.Bluetooth
              width={Matrics.mvs(45)}
              height={Matrics.mvs(45)}
              style={{
                marginVertical: Matrics.vs(10),
              }}
            />
            <Text
              style={{
                fontFamily: Fonts.MEDIUM,
                fontSize: Matrics.mvs(16),
                color: colors.dimGray,
                textAlign: 'center',
                width: '65%',
              }}>
              Turn on Bluetooth to connect your device
            </Text>
          </View>
          <View
            style={[
              styles.bottomBtnContainerShadow,
              styles.bottonBtnContainer,
              {
                paddingBottom:
                  insets.bottom !== 0
                    ? Platform.OS == 'android'
                      ? insets.bottom + Matrics.vs(10)
                      : insets.bottom
                    : Matrics.vs(15),
              },
            ]}>
            <Button
              title="Connect"
              titleStyle={styles.saveBtnTxt}
              onPress={() => {
                bottomSheetModalRef.current?.present();
              }}
            />
          </View>
        </View>
      </CommonBottomSheetModal>
      <View
        style={[
          styles.bottomBtnContainerShadow,
          styles.bottonBtnContainer,
          {
            paddingBottom:
              insets.bottom !== 0
                ? Platform.OS == 'android'
                  ? insets.bottom + Matrics.vs(10)
                  : insets.bottom
                : Matrics.vs(15),
          },
        ]}>
        <Button
          title="Connect"
          titleStyle={styles.saveBtnTxt}
          onPress={() => {
            bottomSheetModalRef.current?.present();
          }}
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
