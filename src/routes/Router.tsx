import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {NavigationContainer} from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import {NativeModules} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import AllLearnItemsScreen from '../screens/AllLearnItemsScreen';

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
export const navigateToDiscover = Navigation.navigateToDiscover;
export const navigateToChronicCareProgram =
  Navigation.navigateToChronicCareProgram;
export const openUpdateGoal = Navigation.openUpdateGoal;
export const openMedicine = Navigation.openMedicine;
export const openHealthKitSyncView = Navigation.openHealthKitSyncView;
export const navigateToBookAppointment = Navigation.navigateToBookAppointment;

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
      <Drawer.Screen
        name={'AllLearnItemsScreen'}
        component={AllLearnItemsScreen}
      />
    </Drawer.Navigator>
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
      </AppStack.Navigator>
    </NavigationContainer>
  );
};

export default Router;
