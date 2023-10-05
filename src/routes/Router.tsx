import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';

import {
  AppStackParamList,
  DrawerParamList,
  AuthStackParamList
} from '../interface/Navigation.interface';
import { NavigationContainer } from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import { NativeModules } from 'react-native';
import { createStackNavigator } from '@react-navigation/stack';
import LoginScreen from '../screens/Auth/LoginScreen';
import OnBoardingScreen from '../screens/Auth/OnBoardingScreen';
import OTPScreen from '../screens/Auth/OTPScreen';
// const Navigation = NativeModules.Navigation;
// export const navigateTo = Navigation.navigateTo;
// export const navigateToHistory = Navigation.navigateToHistory;
// export const navigateToBookmark = Navigation.navigateToBookmark;
// export const navigateToPlan = Navigation.navigateToPlan;
// export const navigateToEngagement = Navigation.navigateToEngagement;
// export const navigateToMedicines = Navigation.navigateToMedicines;
// export const navigateToIncident = Navigation.navigateToIncident;
// export const navigateToShareKit = Navigation.navigateToShareKit;
// export const openUpdateReading = Navigation.openUpdateReading;
// export const navigateToExercise = Navigation.navigateToExercise;
// export const openUpdateGoal = Navigation.openUpdateGoal;
// export const openHealthKitSyncView = Navigation.openHealthKitSyncView;
// export const goBack = Navigation.goBack();

const Drawer = createDrawerNavigator<DrawerParamList>();
const DrawerScreen = () => {
  return (
    <Drawer.Navigator
      initialRouteName={'HomeScreen'}
      drawerContent={(props: DrawerContentComponentProps) => (
        <CustomDrawer {...props} />
      )}
      screenOptions={{
        drawerPosition: 'right',
        headerShown: false,
      }}>
      <Drawer.Screen name={'HomeScreen'} component={HomeScreen} />
      <Drawer.Screen name={'AboutUsScreen'} component={AboutUsScreen} />
    </Drawer.Navigator>
  );
};


const AuthStack = createStackNavigator<AuthStackParamList>();
const AuthStackScreen = () => {
  return (
    <AuthStack.Navigator initialRouteName='OnBoardingScreen' screenOptions={{
      // headerShown: false,
    }}>
      <AuthStack.Screen name='LoginScreen' component={LoginScreen} />
      <AuthStack.Screen name='OTPScreen' component={OTPScreen} />
      <AuthStack.Screen name='OnBoardingScreen' component={OnBoardingScreen} options={{
        headerShown: false
      }} />
    </AuthStack.Navigator>
  )
}

const AppStack = createStackNavigator<AppStackParamList>();
const Router = () => {
  return (
    <NavigationContainer>
      <AppStack.Navigator
        initialRouteName='AuthStackScreen'
        screenOptions={{
          headerShown: false,
        }}>
        <AppStack.Screen name={'AuthStackScreen'} component={AuthStackScreen} />
        <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
      </AppStack.Navigator>

      {/* <Stack.Navigator>
       
      </Stack.Navigator> */}
    </NavigationContainer>
  );
};

export default Router;
