import { AppointmentDetailsScreenProps } from "../screens/Appointment/AppointmentDetailsScreen";

export type AppStackParamList = {
  DrawerScreen: DrawerParamList;
  AuthStackScreen: AuthStackParamList;
  TabScreen: TabParamList;
  AppointmentStackScreen:AppointmentStackParamList;
  DeviceConnectionScreen:undefined
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

export type HomeStackParamList = {
  HomeScreen: undefined;
  SpirometerScreen:undefined,
}
export type ExerciesStackParamList = {
  ExplorScreen: TabParamList;
  ExerciseDetailScreen: {Data: any};
};

export type AppointmentStackParamList = {
  AppointmentScreen:{appointmentDetails?:AppointmentDetailsScreenProps};
  AppointmentWithScreen:{type:string}
  AppointmentDetailsScreen:{appointmentDetails:AppointmentDetailsScreenProps}
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
