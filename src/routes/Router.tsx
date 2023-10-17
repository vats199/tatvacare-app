import HomeScreen from '../screens/HomeScreen';
import RoutineScreen from '../screens/Exercise/RoutineScreen';
import React from 'react';
import ExplorScreen from '../screens/Exercise/ExplorScreen';
import ExerciseDetailScreen from '../screens/Exercise/ExerciseDetailScreen';
import LoginScreen from '../screens/Auth/LoginScreen';
import OnBoardingScreen from '../screens/Auth/OnBoardingScreen';
import OTPScreen from '../screens/Auth/OTPScreen';
import EngageScreen from '../screens/Engage/EngageScreen';
import CarePlanScreen from '../screens/CarePlan/CarePlanScreen';
import {
  AppStackParamList,
  DrawerParamList,
  AuthStackParamList,
  TabParamList,
  BottomTabParamList,
  ExerciesStackParamList,
  AppointmentStackParamList,
  HomeStackParamList,
} from '../interface/Navigation.interface';
import {NavigationContainer} from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {createStackNavigator} from '@react-navigation/stack';
import {createMaterialTopTabNavigator} from '@react-navigation/material-top-tabs';
import {colors} from '../constants/colors';
import {Image} from 'react-native';
import AppointmentScreen from '../screens/Appointment/AppointmentScreen';
import AppointmentWithScreen from '../screens/Appointment/AppointmentWithScreen';
import AppointmentDetailsScreen from '../screens/Appointment/AppointmentDetailsScreen';
import SpirometerScreen from '../screens/Spirometer/SpirometerScreen';
import {BottomSheetModalProvider} from '@gorhom/bottom-sheet';
import DeviceConnectionScreen from '../screens/Spirometer/DeviceConnectionScreen';

const Drawer = createDrawerNavigator<DrawerParamList>();
const DrawerScreen = () => {
  return (
    <Drawer.Navigator
      initialRouteName={'Home'}
      drawerContent={(props: DrawerContentComponentProps) => (
        <CustomDrawer {...props} />
      )}
      screenOptions={{
        drawerPosition: 'right',
        headerShown: false,
      }}>
      <Drawer.Screen name={'Home'} component={BottomTabScreen} />
    </Drawer.Navigator>
  );
};

const BottomTab = createBottomTabNavigator<BottomTabParamList>();
const BottomTabScreen = () => {
  return (
    <BottomTab.Navigator
      screenOptions={({route}) => ({
        headerShown: false,
        tabBarIcon: ({focused}) => {
          let iconName;
          let rn = route.name;
          if (rn === 'HomeScreen') {
            iconName = require('../assets/images/Home.png');
          } else if (rn === 'Exercies') {
            iconName = require('../assets/images/Exercise.png');
          } else if (rn === 'EngageScreen') {
            iconName = require('../assets/images/Engage.png');
          } else if (rn === 'CarePlanScreen') {
            iconName = require('../assets/images/Caree.png');
          }
          return (
            <Image
              source={iconName}
              style={{
                tintColor: focused ? colors.themePurple : colors.secondaryLabel,
              }}
            />
          );
        },
        tabBarActiveTintColor: colors.themePurple,
        tabBarInactiveTintColor: colors.secondaryLabel,
        tabBarStyle: {
          borderTopRightRadius: 30,
          borderTopLeftRadius: 30,
          flex: 0.1,
        },
        tabBarLabelStyle: {
          paddingBottom: 10,
          fontSize: 12,
          paddingTop: 10,
        },
        tabBarIconStyle: {
          marginTop: 15,
        },
      })}>
      <BottomTab.Screen
        name={'HomeScreen'}
        component={HomeStackScreen}
        options={{tabBarLabel: 'Home'}}
      />
      <BottomTab.Screen
        name={'CarePlanScreen'}
        component={CarePlanScreen}
        options={{tabBarLabel: 'Care Plan'}}
      />
      <BottomTab.Screen
        name={'EngageScreen'}
        component={EngageScreen}
        options={{tabBarLabel: 'Engage'}}
      />
      <BottomTab.Screen
        name={'Exercies'}
        component={ExerciesStackScreen}
        options={{tabBarLabel: 'Exercies'}}
      />
    </BottomTab.Navigator>
  );
};

const Tab = createMaterialTopTabNavigator<TabParamList>();
const TabScreen = () => {
  return (
    <Tab.Navigator
      initialRouteName="RoutineScreen"
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
          borderBottomWidth: 6,
          borderRadius: 3,
        },
      }}>
      <Tab.Screen
        name={'RoutineScreen'}
        component={RoutineScreen}
        options={{tabBarLabel: 'My Routine'}}
      />
      <Tab.Screen
        name={'ExplorScreen'}
        component={ExplorScreen}
        options={{tabBarLabel: 'Explore'}}
      />
    </Tab.Navigator>
  );
};

const HomeStack = createStackNavigator<HomeStackParamList>();
const HomeStackScreen = () => {
  return (
    <HomeStack.Navigator screenOptions={{headerShown: false}}>
      <HomeStack.Screen name="HomeScreen" component={HomeScreen} />
      <HomeStack.Screen name="SpirometerScreen" component={SpirometerScreen} />
    </HomeStack.Navigator>
  );
};

const ExerciesStack = createStackNavigator<ExerciesStackParamList>();
const ExerciesStackScreen = () => {
  return (
    <ExerciesStack.Navigator
      initialRouteName="ExplorScreen"
      screenOptions={{headerShown: false}}>
      <ExerciesStack.Screen name="ExplorScreen" component={TabScreen} />
      <ExerciesStack.Screen
        name="ExerciseDetailScreen"
        component={ExerciseDetailScreen}
      />
    </ExerciesStack.Navigator>
  );
};

const AppointmentStack = createStackNavigator<AppointmentStackParamList>();
const AppointmentStackScreen = () => {
  return (
    <AppointmentStack.Navigator
      initialRouteName="AppointmentScreen"
      screenOptions={{headerShown: false}}>
      <AppointmentStack.Screen
        name="AppointmentScreen"
        component={AppointmentScreen}
      />
      <AppointmentStack.Screen
        name={'AppointmentWithScreen'}
        component={AppointmentWithScreen}
      />
      <AppointmentStack.Screen
        name={'AppointmentDetailsScreen'}
        component={AppointmentDetailsScreen}
      />
    </AppointmentStack.Navigator>
  );
};

const AuthStack = createStackNavigator<AuthStackParamList>();
const AuthStackScreen = () => {
  return (
    <AuthStack.Navigator
      initialRouteName="OnBoardingScreen"
      screenOptions={{
        headerShown: false,
      }}>
      <AuthStack.Screen name="LoginScreen" component={LoginScreen} />
      <AuthStack.Screen name="OTPScreen" component={OTPScreen} />
      <AuthStack.Screen name="OnBoardingScreen" component={OnBoardingScreen} />
    </AuthStack.Navigator>
  );
};
const AppStack = createStackNavigator<AppStackParamList>();
const Router = () => {
  return (
    <NavigationContainer>
      <BottomSheetModalProvider>
        <AppStack.Navigator
          initialRouteName="DrawerScreen"
          screenOptions={{
            headerShown: false,
          }}>
          <AppStack.Screen name={'TabScreen'} component={TabScreen} />
          {/* <AppStack.Screen name={'AuthStackScreen'} component={AuthStackScreen} /> */}
          <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
          <AppStack.Screen
            name={'AppointmentStackScreen'}
            component={AppointmentStackScreen}
          />
          <AppStack.Screen
            name={'DeviceConnectionScreen'}
            component={DeviceConnectionScreen}
          />
        </AppStack.Navigator>
      </BottomSheetModalProvider>
    </NavigationContainer>
  );
};

export default Router;
