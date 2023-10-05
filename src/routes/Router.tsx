import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';
import RoutineScreen from '../screens/Exercise/RoutineScreen';
import ExplorScreen from '../screens/Exercise/ExplorScreen';
 import {
  AppStackParamList,
  DrawerParamList,
  TabParamList,
} from '../interface/Navigation.interface';
import {NavigationContainer} from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import {NativeModules} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import {createMaterialTopTabNavigator} from '@react-navigation/material-top-tabs';
import {colors} from '../constants/colors';

const Navigation = NativeModules.Navigation;
export const navigateTo = Navigation.navigateTo;
export const navigateToHistory = Navigation.navigateToHistory;
export const navigateToBookmark = Navigation.navigateToBookmark;
export const navigateToPlan = Navigation.navigateToPlan;
export const navigateToEngagement = Navigation.navigateToEngagement;
export const navigateToMedicines = Navigation.navigateToMedicines;
export const navigateToIncident = Navigation.navigateToIncident;
export const navigateToShareKit = Navigation.navigateToShareKit;
export const openUpdateReading = Navigation.openUpdateReading;
export const navigateToExercise = Navigation.navigateToExercise;
export const openUpdateGoal = Navigation.openUpdateGoal;
export const openHealthKitSyncView = Navigation.openHealthKitSyncView;
export const getHomeScreenDataStatus = Navigation.getHomeScreenDataStatus;

export const goBack = Navigation.goBack();

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
          marginHorizontal: 10,
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

const AppStack = createStackNavigator<AppStackParamList>();
const Router = () => {
  return (
    <NavigationContainer>
      <AppStack.Navigator
        screenOptions={{
          headerShown: false,
        }}>
        <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
        <AppStack.Screen name={'TabScreen'} component={TabScreen} />
      </AppStack.Navigator>
    </NavigationContainer>
  );
};

export default Router;
