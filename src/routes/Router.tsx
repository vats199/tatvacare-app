import HomeScreen from '../screens/HomeScreen';
import AboutUsScreen from '../screens/AboutUsScreen';
import {
  AppStackParamList,
  DrawerParamList,
  DietStackParamList,
} from '../interface/Navigation.interface';
import {
  NavigationContainer,
  useNavigationContainerRef,
} from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import {NativeModules, Platform} from 'react-native';
import {createStackNavigator} from '@react-navigation/stack';
import DietScreen from '../screens/FoodDiary/DietScreen';
import AddDietScreen from '../screens/FoodDiary/AddDietScreen';
import DietDetailScreen from '../screens/FoodDiary/DietDetailScreen';
import ProgressBarInsightsScreen from '../screens/FoodDiary/ProgressBarInsightsScreen';
import {BottomSheetModalProvider} from '@gorhom/bottom-sheet';
import {useRef} from 'react';
import {useApp} from '../context/app.context';
import ChatScreen from '../screens/ChatScreen';
const Navigation = NativeModules.Navigation;
export const navigateTo = Platform.OS == 'ios' && Navigation.navigateTo;
export const navigateToHistory =
  Platform.OS == 'ios' && Navigation.navigateToHistory;
export const navigateToBookmark =
  Platform.OS == 'ios' && Navigation.navigateToBookmark;
export const navigateToPlan = Platform.OS == 'ios' && Navigation.navigateToPlan;
export const goBackFromChat = Platform.OS == 'ios' && Navigation.goBackFromChat;

export const navigateToEngagement =
  Platform.OS == 'ios' && Navigation.navigateToEngagement;
export const navigateToMedicines =
  Platform.OS == 'ios' && Navigation.navigateToMedicines;
export const navigateToIncident =
  Platform.OS == 'ios' && Navigation.navigateToIncident;
export const navigateToShareKit =
  Platform.OS == 'ios' && Navigation.navigateToShareKit;
export const openUpdateReading =
  Platform.OS == 'ios' && Navigation.openUpdateReading;
export const openPlanDetails =
  Platform.OS == 'ios' && Navigation.openPlanDetails;
export const onPressRenewPlan =
  Platform.OS == 'ios' && Navigation.onPressRenewPlan;
export const navigateToExercise =
  Platform.OS == 'ios' && Navigation.navigateToExercise;
export const navigateToDiscover =
  Platform.OS == 'ios' && Navigation.navigateToDiscover;
export const navigateToChronicCareProgram =
  Platform.OS == 'ios' && Navigation.navigateToChronicCareProgram;
export const openUpdateGoal = Platform.OS == 'ios' && Navigation.openUpdateGoal;
export const openMedicineExerciseDiet =
  Platform.OS == 'ios' && Navigation.openMedicineExerciseDiet;
export const openHealthKitSyncView =
  Platform.OS == 'ios' && Navigation.openHealthKitSyncView;
export const navigateToBookAppointment =
  Platform.OS == 'ios' && Navigation.navigateToBookAppointment;
export const openAddWeightHeight =
  Platform.OS == 'ios' && Navigation.openAddWeightHeight;

export const goBack = Platform.OS == 'ios' && Navigation.goBack();

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
    <DietStack.Navigator
      screenOptions={{headerShown: false}}
      initialRouteName="DietScreen">
      <DietStack.Screen name="HomeScreen" component={HomeScreen} />
      <DietStack.Screen name="DietScreen" component={DietScreen} />
      <DietStack.Screen name="AddDiet" component={AddDietScreen} />
      <DietStack.Screen name="DietDetail" component={DietDetailScreen} />
      <DietStack.Screen
        name="ProgressBarInsightsScreen"
        component={ProgressBarInsightsScreen}
      />
    </DietStack.Navigator>
  );
};

const AppStack = createStackNavigator<AppStackParamList>();
const Router = () => {
  const navigationRef = useNavigationContainerRef();
  const routeNameRef = useRef<string | undefined>(undefined);
  const {setCurrentScreenName} = useApp();

  return (
    <NavigationContainer
      ref={navigationRef}
      onReady={() => {
        routeNameRef.current = navigationRef.getCurrentRoute()?.name;
      }}
      onStateChange={async () => {
        const previousRouteName = routeNameRef.current;
        const currentRouteName = navigationRef.getCurrentRoute()?.name;
        if (previousRouteName !== currentRouteName) {
          // Save the current route name for later comparison
          routeNameRef.current = currentRouteName;
          setCurrentScreenName(routeNameRef.current);
          // Replace the line below to add the tracker from a mobile analytics SDK
        }
      }}>
      <BottomSheetModalProvider>
        <AppStack.Navigator
          screenOptions={{
            headerShown: false,
            gestureEnabled: false,
          }}>
          <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
          <AppStack.Screen
            name={'DietStackScreen'}
            component={DietStackScreen}
          />
          <AppStack.Screen name={'ChatScreen'} component={ChatScreen} />
        </AppStack.Navigator>
      </BottomSheetModalProvider>
    </NavigationContainer>
  );
};

export default Router;
