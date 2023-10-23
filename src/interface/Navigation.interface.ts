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
export type AppStackParamList = {
  // BottomTabs: undefined;
  DrawerScreen: DrawerParamList;
  DietStackScreen: DietStackParamList;
};

export type DrawerParamList = {
  HomeScreen: undefined;
  AboutUsScreen: undefined;
};
export type DietStackParamList = {
  HomeScreen: undefined;
  DietScreen: undefined;
  AddDiet: {
    optionId: string;
    healthCoachId: string;
    mealName: string;
    patient_id: string;
  };
  DietDetail: {
    foodItem: FoodItems;
    buttonText: string;
    healthCoachId: string;
    mealName: string;
    patient_id: string;
  };
  ProgressBarInsightsScreen: {calories: Options[]};
};

export type BottomTabParamList = {
  HomeScreen: undefined;
  ProgramsScreen: undefined;
  LearnScreen: undefined;
  ExerciseScreen: undefined;
};
