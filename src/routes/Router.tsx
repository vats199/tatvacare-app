import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import { NavigationContainer } from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import { NativeModules, Platform } from 'react-native';
import { createStackNavigator } from '@react-navigation/stack';

const Navigation = NativeModules.Navigation;
export const navigateTo = Platform.OS == "ios" && Navigation.navigateTo;
export const navigateToHistory = Platform.OS == "ios" && Navigation.navigateToHistory;
export const navigateToBookmark = Platform.OS == "ios" && Navigation.navigateToBookmark;
export const navigateToPlan = Platform.OS == "ios" && Navigation.navigateToPlan;
export const navigateToEngagement = Platform.OS == "ios" && Navigation.navigateToEngagement;
export const navigateToMedicines = Platform.OS == "ios" && Navigation.navigateToMedicines;
export const navigateToIncident = Platform.OS == "ios" && Navigation.navigateToIncident;
export const navigateToShareKit = Platform.OS == "ios" && Navigation.navigateToShareKit;
export const openUpdateReading = Platform.OS == "ios" && Navigation.openUpdateReading;
export const openPlanDetails = Platform.OS == "ios" && Navigation.openPlanDetails;
export const onPressRenewPlan = Platform.OS == "ios" && Navigation.onPressRenewPlan;
export const navigateToExercise = Platform.OS == "ios" && Navigation.navigateToExercise;
export const navigateToDiscover = Platform.OS == "ios" && Navigation.navigateToDiscover;
export const navigateToChronicCareProgram =
  Platform.OS == "ios" && Navigation.navigateToChronicCareProgram;
export const openUpdateGoal = Platform.OS == "ios" && Navigation.openUpdateGoal;
export const openMedicineExerciseDiet = Platform.OS == "ios" && Navigation.openMedicineExerciseDiet;
export const openHealthKitSyncView = Platform.OS == "ios" && Navigation.openHealthKitSyncView;
export const navigateToBookAppointment = Platform.OS == "ios" && Navigation.navigateToBookAppointment;
export const openAddWeightHeight = Platform.OS == "ios" && Navigation.openAddWeightHeight;

export const goBack = Platform.OS == "ios" && Navigation.goBack();

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
