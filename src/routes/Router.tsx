import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';
import {
  AppStackParamList,
  DrawerParamList,
  DietStackParamList
} from '../interface/Navigation.interface';
import { NavigationContainer } from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import { NativeModules } from 'react-native';
import { createStackNavigator } from '@react-navigation/stack';
import DietScreen from '../screens/FoodDiary/DietScreen';
import AddDietScreen from '../screens/FoodDiary/AddDietScreen';
import DietDetailScreen from '../screens/FoodDiary/DietDetailScreen';
import ProgressBarInsightsScreen from '../screens/FoodDiary/ProgressBarInsightsScreen';

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
export const openPlanDetails = Navigation.openPlanDetails;
export const onPressRenewPlan = Navigation.onPressRenewPlan;
export const navigateToExercise = Navigation.navigateToExercise;
export const navigateToDiscover = Navigation.navigateToDiscover;
export const navigateToChronicCareProgram =
  Navigation.navigateToChronicCareProgram;
export const openUpdateGoal = Navigation.openUpdateGoal;
export const openMedicineExerciseDiet = Navigation.openMedicineExerciseDiet;
export const openHealthKitSyncView = Navigation.openHealthKitSyncView;
export const navigateToBookAppointment = Navigation.navigateToBookAppointment;
export const openAddWeightHeight = Navigation.openAddWeightHeight;

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

const DietStack = createStackNavigator<DietStackParamList>();
const DietStackScreen = () => {
  return (
    <DietStack.Navigator screenOptions={{ headerShown: false, }} initialRouteName="DietScreen" >
      <DietStack.Screen name="HomeScreen" component={HomeScreen} />
      <DietStack.Screen name="DietScreen" component={DietScreen} />
      <DietStack.Screen name="AddDiet" component={AddDietScreen} />
      <DietStack.Screen name="DietDetail" component={DietDetailScreen} />
      <DietStack.Screen name="ProgressBarInsightsScreen" component={ProgressBarInsightsScreen} />
    </DietStack.Navigator>
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
        <AppStack.Screen name={'DietStackScreen'} component={DietStackScreen} />
      </AppStack.Navigator>
    </NavigationContainer>
  );
};

export default Router;
