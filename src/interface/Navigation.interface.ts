import carePlanScreen from '../screens/CarePlan/CarePlanScreen';
import Diet from '../api/diet';
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
  healthCoachId:string
};

type Consumption = {
  consumed_qty: number;
  diet_plan_id: string;
  diet_plan_food_item_id: string;
  date: string;
  diet_plan_food_consumption_id: null;
};

export type AppStackParamList = {
  // BottomTabs: undefined;
  DrawerScreen: DrawerParamList;
  AuthStackScreen: AuthStackParamList;
  TabScreen: TabParamList;
  DietStackScreen: DietStackParamList;
};

export type DrawerParamList = {
  Home: BottomTabParamList;
  AboutUsScreen: undefined;
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

export type BottomTabParamList = {
  HomeScreen: undefined;
  Exercies: ExerciesStackParamList;
  EngageScreen: EngageStackParamList;
  CarePlanScreen: undefined;
  // ProgramsScreen: undefined;
  // LearnScreen: undefined;
  // ExerciseScreen: undefined;
};

export type AuthStackParamList = {
  OnBoardingScreen: undefined;
  LoginScreen: undefined;
  OTPScreen: {contact_no: string; isLoginOTP?: boolean | false};
};

export type DietStackParamList = {
  HomeScreen: undefined;
  DietScreen: undefined;
  AddDiet: {optionId: string; healthCoachId: string};
  DietDetail: { foodItem: FoodItems;  buttonText: string; healthCoachId: string; };
};
