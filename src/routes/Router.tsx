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
import EngageDetailScreen from '../screens/Engage/EngageDetailScreen';
import {
  AppStackParamList,
  DrawerParamList,
  AuthStackParamList,
  TabParamList,
  BottomTabParamList,
  ExerciesStackParamList,
  AppointmentStackParamList,
  SetupProfileStackParamList,
  HomeStackParamList,
  DietStackParamList,
  EngageStackParamList,
  DiagnosticStackParamList,
  DevicePurchaseStackParamList,
  VitalDetailStackParamList,
  LabTestRefundStackParamList
} from '../interface/Navigation.interface';
import { NavigationContainer } from '@react-navigation/native';
import {
  DrawerContentComponentProps,
  createDrawerNavigator,
} from '@react-navigation/drawer';
import CustomDrawer from '../components/organisms/CustomDrawer';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import { createMaterialTopTabNavigator } from '@react-navigation/material-top-tabs';
import { colors } from '../constants/colors';
import { Image } from 'react-native';
import AppointmentScreen from '../screens/Appointment/AppointmentScreen';
import AppointmentWithScreen from '../screens/Appointment/AppointmentWithScreen';
import AppointmentDetailsScreen from '../screens/Appointment/AppointmentDetailsScreen';
import SpirometerScreen from '../screens/Spirometer/SpirometerScreen';
import { BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import DeviceConnectionScreen from '../screens/Spirometer/DeviceConnectionScreen';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Splash from '../screens/Auth/Splash';
import WelcomeScreen from '../screens/SetupProfile/WelcomeScreen';
import QuestionOneScreen from '../screens/SetupProfile/QuestionOneScreen';
import ScanCodeScreen from '../screens/SetupProfile/ScanCodeScreen';
import QuestionListScreen from '../screens/SetupProfile/QuestionListScreen';
import Ionicons from 'react-native-vector-icons/Ionicons';
import DietScreen from '../screens/FoodDiary/DietScreen';
import AddDietScreen from '../screens/FoodDiary/AddDietScreen';
import DietDetailScreen from '../screens/FoodDiary/DietDetailScreen';
import ProgressBarInsightsScreen from '../screens/FoodDiary/ProgressBarInsightsScreen';

import { SafeAreaView } from 'react-native-safe-area-context';
import ProgressReportScreen from '../screens/SetupProfile/ProgressReportScreen';
import AllLabTestScreen from '../screens/Diagnostic/AllLabTestScreen';
import LabTestCartScreen from '../screens/Diagnostic/LabTestCartScreen';
import ApplyCoupanScreen from '../screens/Diagnostic/ApplyCoupanScreen';
import ConfirmLocationScreen from '../screens/Diagnostic/ConfirmLocationScreen';
import SearchLabTestScreen from '../screens/Diagnostic/SearchLabTestScreen';
import AddPatientDetailsScreen from '../screens/Diagnostic/AddPatientDetailsScreen';
import ViewAllTestScreen from '../screens/Diagnostic/ViewAllTestScreen';
import MyPrescriptionScreen from '../screens/Diagnostic/MyPrescriptionScreen';
import TestDetailScreen from '../screens/Diagnostic/TestDeatilScreen';
import SelectTestSlotScreen from '../screens/Diagnostic/SelectTestSlotScreen';
import LabTestSummary from '../screens/Diagnostic/LabTestSummaryScreen';
import LabTestSummaryScreen from '../screens/Diagnostic/LabTestSummaryScreen';
import CongratulationScreen from '../screens/Diagnostic/CongratulationScreen';
import OrderDetailsScreen from '../screens/Diagnostic/OrderDetailsScreen';
import DeviceScreen from '../screens/DevicePurchase/DeviceScreen';
import DeviceDetailsScreen from '../screens/DevicePurchase/DeviceDetailsScreen';
import CartScreen from '../screens/DevicePurchase/CartScreen';
import ConfirmLocation from '../screens/DevicePurchase/ConfirmLocation';
import OrderSummaryScreen from '../screens/DevicePurchase/OrderSummaryScreen';
import PaymentDoneScreen from '../screens/DevicePurchase/PaymentDoneScreen';
import DevicesScreen from '../screens/DevicePurchase/DevicesScreen';
import StepsScreen from '../screens/VitalDetail/StepsScreen';
import LabTestScreen from '../screens/LabTestRefund/LabTestScreen';
import DetailsOrderScreen from '../screens/LabTestRefund/DetailsOrderScreen';
import TestSlotScreen from '../screens/LabTestRefund/TestSlotScreen';
import TestSummaryScreen from '../screens/LabTestRefund/TestSummaryScreen';
import CongratulationsScreen from '../screens/LabTestRefund/CongratulationsScreen';

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
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarIcon: ({ focused }) => {
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
        options={{ tabBarLabel: 'Home' }}
      />
      <BottomTab.Screen
        name={'CarePlanScreen'}
        component={CarePlanScreen}
        options={{ tabBarLabel: 'Care Plan' }}
      />
      <BottomTab.Screen
        name={'EngageScreen'}
        component={EngageStackScreen}
        options={{ tabBarLabel: 'Engage' }}
      />
      <BottomTab.Screen
        name={'Exercies'}
        component={ExerciesStackScreen}
        options={{ tabBarLabel: 'Exercies' }}
      />
    </BottomTab.Navigator>
  );
};

const Tab = createMaterialTopTabNavigator<TabParamList>();
const TabScreen = () => {
  return (
    <SafeAreaView
      edges={['top']}
      style={{ flex: 1, backgroundColor: colors.white }}>
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
          options={{ tabBarLabel: 'My Routine' }}
        />
        <Tab.Screen
          name={'ExplorScreen'}
          component={ExplorScreen}
          options={{ tabBarLabel: 'Explore' }}
        />
      </Tab.Navigator>
    </SafeAreaView>
  );
};

const EngageStack = createStackNavigator<EngageStackParamList>();
const EngageStackScreen = () => {
  return (
    <EngageStack.Navigator
      initialRouteName="EngageScreen"
      screenOptions={{ headerShown: false }}>
      <EngageStack.Screen name="EngageScreen" component={EngageScreen} />
      <EngageStack.Screen
        name="EngageDetailScreen"
        component={EngageDetailScreen}
      />
    </EngageStack.Navigator>
  );
};
const ExerciesStack = createStackNavigator<ExerciesStackParamList>();
const ExerciesStackScreen = () => {
  return (
    <ExerciesStack.Navigator
      initialRouteName="ExplorScreen"
      screenOptions={{ headerShown: false }}>
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
      screenOptions={{ headerShown: false }}>
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

const DevicePurchaseStack = createStackNavigator<DevicePurchaseStackParamList>();
const DevicePurchaseStackScreen = () => {
  return (
    <DevicePurchaseStack.Navigator
      initialRouteName="DeviceScreen"
      screenOptions={{ headerShown: false }}>
      <DevicePurchaseStack.Screen
        name="DeviceScreen"
        component={DeviceScreen}
      />
      <DevicePurchaseStack.Screen
        name="DeviceDetail"
        component={DeviceDetailsScreen}
      />
      <DevicePurchaseStack.Screen
        name="CartScreen"
        component={CartScreen}
      />
      <DevicePurchaseStack.Screen
        name="ConfirmLocationScreen"
        component={ConfirmLocation}
      />
      <DevicePurchaseStack.Screen
        name="OrderSummary"
        component={OrderSummaryScreen}
      />
      <DevicePurchaseStack.Screen
        name="PaymentDone"
        component={PaymentDoneScreen}
      />
      <DevicePurchaseStack.Screen
        name="DevicesScreen"
        component={DevicesScreen}
      />
      <DevicePurchaseStack.Screen
        name="ApplyCoupan"
        component={ApplyCoupanScreen}
      />

    </DevicePurchaseStack.Navigator>
  );
};

// const VitaldetailStack = createStackNavigator<VitalDetailStackParamList>();
// const VitalDetailStackScreen = () => {
//   return (
//     <VitaldetailStack.Navigator
//       initialRouteName="StepsScreen"
//       screenOptions={{ headerShown: false }}>
//       <VitaldetailStack.Screen
//         name="LabTestScreen"
//         component={LabTestScreen}
//       />
//     </VitaldetailStack.Navigator>
//   );
// }

const LabTestRefundStack = createStackNavigator<LabTestRefundStackParamList>();
const LabTestRefundStackScreen = () => {
  return (
    <LabTestRefundStack.Navigator
      initialRouteName="LabTestScreen"
      screenOptions={{ headerShown: false }}>
      <LabTestRefundStack.Screen
        name="LabTestScreen"
        component={LabTestScreen}
      />
      <LabTestRefundStack.Screen
        name="OrderDetails"
        component={DetailsOrderScreen}
      />
      <LabTestRefundStack.Screen
        name="SelectTestSlot"
        component={TestSlotScreen}
      />
      <LabTestRefundStack.Screen
        name="TestSummaryScreen"
        component={TestSummaryScreen}
      />
      <LabTestRefundStack.Screen
        name="CongratulationsScreen"
        component={CongratulationsScreen}
      />
    </LabTestRefundStack.Navigator>
  );
}

const DiagnosticStack = createStackNavigator<DiagnosticStackParamList>();
const DiagnosticStackScreen = () => {
  return (
    <DiagnosticStack.Navigator
      initialRouteName="AllLabTestScreen"
      screenOptions={{ headerShown: false }}>
      <DiagnosticStack.Screen
        name="AllLabTestScreen"
        component={AllLabTestScreen}
      />
      <DiagnosticStack.Screen
        name={'LabTestCart'}
        component={LabTestCartScreen}
      />
      <DiagnosticStack.Screen
        name={'ApplyCoupan'}
        component={ApplyCoupanScreen}
      />
      <DiagnosticStack.Screen
        name={'ConfirmLocation'}
        component={ConfirmLocationScreen}
      />
      <DiagnosticStack.Screen
        name={'SearchLabTest'}
        component={SearchLabTestScreen}
      />
      <DiagnosticStack.Screen
        name={'AddPatientDetails'}
        component={AddPatientDetailsScreen}
      />
      <DiagnosticStack.Screen
        name={'ViewAllTest'}
        component={ViewAllTestScreen}
      />
      <DiagnosticStack.Screen
        name={'MyPerscription'}
        component={MyPrescriptionScreen}
      />
      <DiagnosticStack.Screen
        name={'TestDetail'}
        component={TestDetailScreen}
      />
      <DiagnosticStack.Screen
        name={'SelectTestSlot'}
        component={SelectTestSlotScreen}
      />
      <DiagnosticStack.Screen
        name={'LabTestSummary'}
        component={LabTestSummaryScreen}
      />
      <DiagnosticStack.Screen
        name={'CongratulationScreen'}
        component={CongratulationScreen}
      />
      <DiagnosticStack.Screen
        name={'OrderDetails'}
        component={OrderDetailsScreen}
      />


    </DiagnosticStack.Navigator>
  );
};

const AuthStack = createStackNavigator<AuthStackParamList>();
const AuthStackScreen = () => {
  return (
    <AuthStack.Navigator
      initialRouteName="Splash"
      screenOptions={{
        headerShown: false,
      }}>
      <AuthStack.Screen name="Splash" component={Splash} />
      <AuthStack.Screen name="LoginScreen" component={LoginScreen} />
      <AuthStack.Screen name="OTPScreen" component={OTPScreen} />
      <AuthStack.Screen name="OnBoardingScreen" component={OnBoardingScreen} />
    </AuthStack.Navigator>
  );
};

const SetupProfileStack = createStackNavigator<SetupProfileStackParamList>();
const SetupProfileScreen = () => {
  return (
    <SetupProfileStack.Navigator
      initialRouteName="WelcomeScreen"
      screenOptions={{
        headerShown: false,
      }}>
      <SetupProfileStack.Screen
        name="WelcomeScreen"
        component={WelcomeScreen}
      />
      <SetupProfileStack.Screen
        name="QuestionOneScreen"
        component={QuestionOneScreen}
      />

      <SetupProfileStack.Screen
        name="ScanCodeScreen"
        component={ScanCodeScreen}
      />

      <SetupProfileStack.Screen
        name="QuestionListScreen"
        component={QuestionListScreen}
      />

      <SetupProfileStack.Screen
        name="ProgressReportScreen"
        component={ProgressReportScreen}
      />
    </SetupProfileStack.Navigator>
  );
};

const HomeStack = createStackNavigator<HomeStackParamList>();
const HomeStackScreen = () => {
  return (
    <HomeStack.Navigator
      screenOptions={{
        headerShown: false,
      }}>
      <HomeStack.Screen name="HomeScreen" component={HomeScreen} />
      <HomeStack.Screen name="SpirometerScreen" component={SpirometerScreen} />
    </HomeStack.Navigator>
  );
};
const DietStack = createStackNavigator<DietStackParamList>();
const DietStackScreen = () => {
  return (
    <DietStack.Navigator
      screenOptions={{ headerShown: false }}
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
  return (
    <NavigationContainer>
      <BottomSheetModalProvider>
        <AppStack.Navigator
          initialRouteName="AuthStackScreen"
          screenOptions={{
            headerShown: false,
          }}>
          <AppStack.Screen
            name={'SetupProfileScreen'}
            component={SetupProfileScreen}
          />
          <AppStack.Screen name={'TabScreen'} component={TabScreen} />
          <AppStack.Screen
            name={'AuthStackScreen'}
            component={AuthStackScreen}
          />
          <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
          <AppStack.Screen
            name={'AppointmentStackScreen'}
            component={AppointmentStackScreen}
          />
          <AppStack.Screen
            name={'DiagnosticStackScreen'}
            component={DiagnosticStackScreen}
          />
          <AppStack.Screen
            name={'DevicePurchaseStackScreen'}
            component={DevicePurchaseStackScreen}
          />
          <AppStack.Screen
            name={'LabTestRefundStackScreen'}
            component={LabTestRefundStackScreen}
          />

          <AppStack.Screen
            name={'DeviceConnectionScreen'}
            component={DeviceConnectionScreen}
          />
          <AppStack.Screen
            name={'DietStackScreen'}
            component={DietStackScreen}
          />
          <AppStack.Screen
            name={'SpirometerScreen'}
            component={SpirometerScreen}
          />
        </AppStack.Navigator>
      </BottomSheetModalProvider>
    </NavigationContainer>
  );
};

export default Router;
