import { AppointmentDetailsScreenProps } from "../screens/Appointment/AppointmentDetailsScreen";

export type AppStackParamList = {
  DrawerScreen: DrawerParamList;
  AuthStackScreen: AuthStackParamList;
  TabScreen: TabParamList;
  AppointmentStackScreen:AppointmentStackParamList;
  DeviceConnectionScreen:undefined
  SetupProfileScreen: SetupProfileStackParamList;
  DiagnosticStackScreen:DiagnosticStackParamList;
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

export type AppointmentStackParamList = {
  AppointmentScreen:{appointmentDetails?:AppointmentDetailsScreenProps};
  AppointmentWithScreen:{type:string}
  AppointmentDetailsScreen:{appointmentDetails:AppointmentDetailsScreenProps}
};

export type DiagnosticStackParamList={
  AllLabTestScreen:undefined;
  LabTestCart:{item :TestItem [] | undefined } | { coupan :string  | undefined};
  ApplyCoupan:undefined;
  ConfirmLocation:undefined;
  SearchLabTest:undefined;
  AddPatientDetails:undefined;
  ViewAllTest:undefined;
  MyPerscription:{data:perscription[] };
}

export type BottomTabParamList = {
  HomeScreen: HomeStackParamList;
  Exercies: ExerciesStackParamList;
  EngageScreen: undefined;
  CarePlanScreen: undefined;
  // ProgramsScreen: undefined;
  // LearnScreen: undefined;
  // ExerciseScreen: undefined;
};

export type AuthStackParamList = {
  Splash: undefined;
  OnBoardingScreen: undefined;
  LoginScreen: undefined;
  OTPScreen: {contact_no: string; isLoginOTP?: boolean | false};
};

export type SetupProfileStackParamList = {
  WelcomeScreen: undefined;
  QuestionOneScreen: undefined;
  ScanCodeScreen: undefined;
  QuestionListScreen: undefined;
};

export type HomeStackParamList={
  HomeScreen:undefined;
  SpirometerScreen:undefined,
}
type TestItem = {
  id: number;
  title: string;
  description: string;
  newPrice: number;
  oldPrice: number;
  discount: number;
  isAdded: boolean;
};
type perscription = {
  id: number;
  date?: any;
  uri?: string;
}