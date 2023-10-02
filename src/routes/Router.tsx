import HomeScreen from "../screens/HomeScreen";
import ExerciseScreen from "../screens/ExerciseScreen";
import LearnScreen from "../screens/LearnScreen";
import ProgramsScreen from "../screens/ProgramsScreen";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { AppStackParamList, BottomTabParamList, DrawerParamList } from "../interface/Navigation.interface";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { NavigationContainer } from "@react-navigation/native";
import { colors } from "../constants/colors";
import { Icons } from "../constants/icons";
import { DrawerContentComponentProps, createDrawerNavigator } from "@react-navigation/drawer";
import CustomDrawer from "../components/organisms/CustomDrawer";
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
export const openUpdateGoal = Navigation.openUpdateGoal;
//to open health kit
export const openHealthKitSyncView = Navigation.openHealthKitSyncView;

export const goBack = Navigation.goBack();
// const BottomTab = createBottomTabNavigator<BottomTabParamList>();
// const BottomTabs = () => {
//     return (
//         <BottomTab.Navigator
//             initialRouteName="HomeScreen"
//             screenOptions={({ route, navigation }) => ({
//                 headerShown: false,
//                 tabBarActiveTintColor: colors.themePurple,
//                 tabBarInactiveTintColor: colors.inactiveGray,
//                 tabBarIcon: ({ color, focused }) => {
//                     switch (route.name) {
//                         case 'HomeScreen':
//                             if (focused) {
//                                 return (<Icons.HomeActive height={24} width={24} />)
//                             } else {
//                                 return (<Icons.HomeInactive height={24} width={24} />)
//                             }

//                         case 'LearnScreen':

//                             if (focused) {
//                                 return (<Icons.LearnActive height={24} width={24} />)
//                             } else {
//                                 return (<Icons.LearnInactive height={24} width={24} />)
//                             }

//                         case 'ProgramsScreen':

//                             if (focused) {
//                                 return (<Icons.ProgramActive height={24} width={24} />)
//                             } else {
//                                 return (<Icons.ProgramInactive height={24} width={24} />)
//                             }

//                         case 'ExerciseScreen':

//                             if (focused) {
//                                 return (<Icons.ExerciseActive height={24} width={24} />)
//                             } else {
//                                 return (<Icons.ExerciseInactive height={24} width={24} />)
//                             }

//                         default:
//                             return (<></>)
//                     }
//                 }
//             })}
//         >
//             <BottomTab.Screen name="HomeScreen" component={HomeScreen} options={{ tabBarLabel: 'Home' }} />
//             <BottomTab.Screen name="ProgramsScreen" component={ProgramsScreen} options={{ tabBarLabel: 'Programs' }} />
//             <BottomTab.Screen name="LearnScreen" component={LearnScreen} options={{ tabBarLabel: 'Learn' }} />
//             <BottomTab.Screen name="ExerciseScreen" component={ExerciseScreen} options={{ tabBarLabel: 'Exercise' }} />
//         </BottomTab.Navigator>
//     )
// }

const Drawer = createDrawerNavigator<DrawerParamList>()
const DrawerScreen = () => {
    return (
        <Drawer.Navigator
            initialRouteName={'HomeScreen'}
            drawerContent={(props: DrawerContentComponentProps) => <CustomDrawer {...props} />}
            screenOptions={{
                drawerPosition: 'right',
                headerShown: false
            }}
        >
            <Drawer.Screen name={'HomeScreen'} component={HomeScreen} />
        </Drawer.Navigator>
    )
}

const AppStack = createNativeStackNavigator<AppStackParamList>();
const Router = () => {
    return (
        <NavigationContainer>
            <AppStack.Navigator screenOptions={{
                headerShown: false
            }}>
                <AppStack.Screen name={'DrawerScreen'} component={DrawerScreen} />
                {/* <AppStack.Screen name="BottomTabs" component={BottomTabs} /> */}
            </AppStack.Navigator>
        </NavigationContainer>
    )
}

export default Router