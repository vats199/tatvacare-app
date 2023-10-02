import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {NavigationContainer} from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import {NativeModules} from 'react-native';

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
//to open health kit
export const openHealthKitSyncView = Navigation.openHealthKitSyncView;
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

const AppStack = createNativeStackNavigator<AppStackParamList>();
const Router = () => {
  return (
    <NavigationContainer>
      <AppStack.Navigator
        screenOptions={{
          headerShown: false,
        }}>
        <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
      </AppStack.Navigator>
    </NavigationContainer>
  );
};

export default Router;
