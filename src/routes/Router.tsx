import HomeScreen from '../screens/HomeScreen';
import ExerciseScreen from '../screens/ExerciseScreen';
import LearnScreen from '../screens/LearnScreen';
import ProgramsScreen from '../screens/ProgramsScreen';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {
  AppStackParamList,
  BottomTabParamList,
} from '../interface/Navigation.interface';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {NavigationContainer} from '@react-navigation/native';
import {colors} from '../constants/colors';
import {Icons} from '../constants/icons';
import DietScreen from '../screens/DietScreen';

const BottomTab = createBottomTabNavigator<BottomTabParamList>();

const BottomTabs = () => {
  return (
    <BottomTab.Navigator
      initialRouteName="HomeScreen"
      screenOptions={({route, navigation}) => ({
        headerShown: false,
        tabBarActiveTintColor: colors.themePurple,
        tabBarInactiveTintColor: colors.inactiveGray,
        tabBarIcon: ({color, focused}) => {
          switch (route.name) {
            case 'HomeScreen':
              if (focused) {
                return <Icons.HomeActive height={24} width={24} />;
              } else {
                return <Icons.HomeInactive height={24} width={24} />;
              }

            case 'LearnScreen':
              if (focused) {
                return <Icons.LearnActive height={24} width={24} />;
              } else {
                return <Icons.LearnInactive height={24} width={24} />;
              }

            case 'ProgramsScreen':
              if (focused) {
                return <Icons.ProgramActive height={24} width={24} />;
              } else {
                return <Icons.ProgramInactive height={24} width={24} />;
              }

            case 'ExerciseScreen':
              if (focused) {
                return <Icons.ExerciseActive height={24} width={24} />;
              } else {
                return <Icons.ExerciseInactive height={24} width={24} />;
              }

            default:
              return <></>;
          }
        },
      })}>
      <BottomTab.Screen
        name="HomeScreen"
        component={HomeScreen}
        options={{tabBarLabel: 'Home'}}
      />
      <BottomTab.Screen
        name="ProgramsScreen"
        component={ProgramsScreen}
        options={{tabBarLabel: 'Programs'}}
      />
      <BottomTab.Screen
        name="LearnScreen"
        component={LearnScreen}
        options={{tabBarLabel: 'Learn'}}
      />
      <BottomTab.Screen
        name="ExerciseScreen"
        component={ExerciseScreen}
        options={{tabBarLabel: 'Exercise'}}
      />
    </BottomTab.Navigator>
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
        <AppStack.Screen name="BottomTabs" component={BottomTabs} />
        <AppStack.Screen name="DietScreen" component={DietScreen} />
      </AppStack.Navigator>
    </NavigationContainer>
  );
};

export default Router;
