import {AppointmentDetailsScreenProps} from '../screens/Appointment/AppointmentDetailsScreen';
import carePlanScreen from '../screens/CarePlan/CarePlanScreen';
import {OptionType} from '../context/diet.context';
type Options = {
  diet_meal_options_id: string;
  diet_meal_type_rel_id: string;
  options_name: string;
  tips: string;
  total_calories: string;
  total_carbs: string;
  total_proteins: string;
  total_fats: string;
  total_fibers: string;
  total_sodium: string;
  total_potassium: string;
  total_sugar: string;
  total_saturated_fatty_acids: null;
  total_monounsaturated_fatty_acids: null;
  total_polyunsaturated_fatty_acids: string;
  total_fatty_acids: null;
  order_no: number;
  is_active: string;
  is_deleted: string;
  updated_by: string;
  created_at: string;
  updated_at: string;
  consumed_calories: number;
  consumed_carbs: number;
  consumed_fat: number;
  consumed_fiber: number;
  consumed_protein: number;
  food_items: FoodItems[];
};
type FoodItems = {
  diet_plan_food_item_id: string;
  diet_meal_options_id: string;
  food_item_id: number;
  food_item_name: string;
  quantity: number;
  measure_id: null;
  measure_name: string;
  protein: string;
  carbs: string;
  fats: string;
  fibers: string;
  calories: string;
  sodium: string;
  potassium: string;
  sugar: string;
  saturated_fatty_acids: null;
  monounsaturated_fatty_acids: null;
  polyunsaturated_fatty_acids: null;
  fatty_acids: string;
  is_active: string;
  is_deleted: string;
  updated_by: string;
  created_at: string;
  updated_at: string;
  consumption: Consumption;
  is_consumed: boolean;
  consumed_calories: number;
  consumed_carbs: number;
  consumed_fat: number;
  consumed_fiber: number;
  consumed_protein: number;
  healthCoachId: string;
};

type Consumption = {
  consumed_qty: number;
  diet_plan_id: string;
  diet_plan_food_item_id: string;
  date: string;
  diet_plan_food_consumption_id: null;
};

type mealTYpe = {
  meal_types_id: string;
  value: string;
  meal_type: string;
  label: string;
  keys: string;
  default_time: string;
  order_no: number;
};

export type AppStackParamList = {
  DrawerScreen: DrawerParamList;
  AuthStackScreen: AuthStackParamList;
  TabScreen: TabParamList;
  AppointmentStackScreen: AppointmentStackParamList;
  DeviceConnectionScreen: undefined;
  SetupProfileScreen: SetupProfileStackParamList;
  DiagnosticStackScreen: DiagnosticStackParamList;
  DietStackScreen: DietStackParamList;
};

export type DrawerParamList = {
  HomeScreen: undefined;
  AboutUsScreen: undefined;
  AllLearnItemsScreen: undefined;
  // ExerciseDetailScreen: {Data: any};
  // ExplorScreen: undefined;
};
export type TabParamList = {
  RoutineScreen: undefined;
  ExplorScreen: undefined;
};

export type ExerciesStackParamList = {
  ExplorScreen: TabParamList;
  ExerciseDetailScreen: {Data: any};
};
export type EngageStackParamList = {
  EngageScreen: undefined;
  EngageDetailScreen: {Data: any};
};

export type AppointmentStackParamList = {
  AppointmentScreen: {appointmentDetails?: AppointmentDetailsScreenProps};
  AppointmentWithScreen: {type: string};
  AppointmentDetailsScreen: {appointmentDetails: AppointmentDetailsScreenProps};
};

export type DiagnosticStackParamList = {
  AllLabTestScreen: undefined;
  LabTestCart: {coupan: string};
  ApplyCoupan: undefined;
  ConfirmLocation: undefined;
  SearchLabTest: undefined;
  AddPatientDetails: undefined;
  ViewAllTest: undefined;
  MyPerscription: {data: perscription[]};
  TestDetail: undefined;
  SelectTestSlot: undefined;
  LabTestSummary: {time: any};
  CongratulationScreen: undefined;
  OrderDetails: undefined;
};

export type BottomTabParamList = {
  HomeScreen: HomeStackParamList;
  Exercies: ExerciesStackParamList;
  EngageScreen: EngageStackParamList;
  CarePlanScreen: undefined;
  ProgramsScreen: undefined;
  LearnScreen: undefined;
  ExerciseScreen: undefined;
};

export type AuthStackParamList = {
  Splash: undefined;
  OnBoardingScreen: undefined;
  LoginScreen: undefined;
  OTPScreen: {contact_no: string; isLoginOTP?: boolean | false};
};

export type DietStackParamList = {
  HomeScreen: undefined;
  DietScreen: {
    option?: OptionType[];
  };
  AddDiet: {
    optionFoodItems?: Options;
    healthCoachId: string;
    mealName: string;
    patient_id?: string;
    mealData?: mealTYpe | null;
    selectedDate?: any | null;
    option: OptionType[];
  };
  DietDetail: {
    foodItem: FoodItems;
    buttonText: string;
    healthCoachId: string;
    mealName: string;
    patient_id?: string;
    mealData?: mealTYpe | null;
    selectedDate?: any | null;
    option: OptionType[];
  };
  ProgressBarInsightsScreen: {
    calories: Options[];
    currentSelectedDate: Date;
    option: OptionType[];
  };
};

export type SetupProfileStackParamList = {
  WelcomeScreen: undefined;
  QuestionOneScreen: undefined;
  ScanCodeScreen: undefined;
  QuestionListScreen: undefined;
  ProgressReportScreen: undefined;
};

// export type HomeStackParamList = {
//   HomeScreen: undefined;
//   DietScreen: undefined;
//   AddDiet: undefined;
//   DietDetail: undefined;
// };

export type HomeStackParamList = {
  HomeScreen: undefined;
  SpirometerScreen: undefined;
};
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
};
