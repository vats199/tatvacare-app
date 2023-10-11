import carePlanScreen from '../screens/CarePlan/CarePlanScreen';
export type AppStackParamList = {
  // BottomTabs: undefined;
  DrawerScreen: DrawerParamList;
  AuthStackScreen: AuthStackParamList;
  TabScreen: TabParamList;
};

export type DrawerParamList = {
  Home: BottomTabParamList;
  AboutUsScreen: undefined;
  ExerciseDetailScreen: {Data: any};
  ExplorScreen: undefined;
};
export type TabParamList = {
  RoutineScreen: undefined;
  ExplorScreen: undefined;
};
export type ExerciesStackParamList = {
  ExplorScreen: TabParamList;
  ExerciseDetailScreen: {Data: any};
};

export type BottomTabParamList = {
  HomeScreen: HomeStackParamList;
  Exercies: ExerciesStackParamList;
  EngageScreen: undefined;
  CarePlanScreen:undefined
  // ProgramsScreen: undefined;
  // LearnScreen: undefined;
  // ExerciseScreen: undefined;
};

export type AuthStackParamList = {
  OnBoardingScreen: undefined;
  LoginScreen: undefined;
  OTPScreen: { contact_no: string, isLoginOTP?: boolean | false };
};

export type HomeStackParamList={
  HomeScreen:undefined;
  DietScreen:undefined;
  AddDiet:undefined;
  DietDetail:undefined;
}
