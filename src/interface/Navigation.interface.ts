export type AppStackParamList = {
  // BottomTabs: undefined;
  DrawerScreen: DrawerParamList;
  AuthStackScreen: AuthStackParamList;
};

export type DrawerParamList = {
  HomeScreen: undefined;
  AboutUsScreen: undefined;
};

export type BottomTabParamList = {
  HomeScreen: undefined;
  ProgramsScreen: undefined;
  LearnScreen: undefined;
  ExerciseScreen: undefined;
};

export type AuthStackParamList = {
  OnBoardingScreen: undefined;
  LoginScreen: undefined;
  OTPScreen: { contact_no: string, isLoginOTP?: boolean | false };
};