import {StyleSheet, ScrollView, View, Text} from 'react-native';
import React, {useEffect} from 'react';
import DietExactTime from '../molecules/DietExactTime';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {Matrics} from '../../constants';
type DietTimeProps = {
  onPressPlus: (optionFoodItems: Options, mealName: string) => void;
  dietOption: boolean;
  dietPlane: MealsData[];
  onpressOfEdit: (editeData: FoodItems, mealName: string) => void;
  onPressOfDelete: (
    deleteFoodItemId: string,
    is_food_item_added_by_patient: string,
  ) => void;
  onPressOfcomplete: (
    consumptionData: Consumption,
    optionId: string,
    mealId: string,
  ) => void;
  getCalories: (calories: Options) => void;
};

type MealsData = {
  diet_meal_type_rel_id: string;
  diet_plan_id: string;
  meal_types_id: string;
  meal_name: string;
  start_time: string;
  end_time: string;
  order_no: number;
  is_hidden: string;
  patient_permission: string;
  is_active: string;
  is_deleted: string;
  updated_by: string;
  created_at: string;
  updated_at: string;
  options: Options[];
};

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
};

type Consumption = {
  consumed_qty: number;
  diet_plan_id: string;
  diet_plan_food_item_id: string;
  date: string;
  diet_plan_food_consumption_id: null;
};
const DietTime: React.FC<DietTimeProps> = ({
  onPressPlus,
  dietOption,
  dietPlane,
  onpressOfEdit,
  onPressOfDelete,
  onPressOfcomplete,
  getCalories,
}) => {
  const insets = useSafeAreaInsets();
  const handaleEdit = (data: FoodItems, mealName: string) => {
    onpressOfEdit(data, mealName);
  };
  const handaleDelete = (Id: string, is_food_item_added_by_patient: string) => {
    onPressOfDelete(Id, is_food_item_added_by_patient);
  };
  const handlePulsIconPress = (optionFoodItems: Options, mealName: string) => {
    onPressPlus(optionFoodItems, mealName);
  };
  const handalecompletion = (
    item: Consumption,
    optionId: string,
    dietPlanId: string,
  ) => {
    onPressOfcomplete(item, optionId, dietPlanId);
  };
  const handalTotleCalories = (calories: string) => {
    getCalories(calories);
  };
  const renderDietTimeItem = (item: MealsData, index: number) => {
    return (
      <DietExactTime
        key={index}
        onPressPlus={handlePulsIconPress}
        dietOption={dietOption}
        cardData={item}
        onpressOfEdit={handaleEdit}
        onPressOfDelete={handaleDelete}
        onPressOfcomplete={(consumptionData, optionId) =>
          handalecompletion(consumptionData, optionId, item.meal_types_id)
        }
        getCalories={handalTotleCalories}
      />
    );
  };

  return (
    <ScrollView
      style={[styles.container, {marginBottom: insets.bottom}]}
      showsVerticalScrollIndicator={false}>
      {dietPlane?.map(renderDietTimeItem)}
    </ScrollView>
  );
};

export default DietTime;

const styles = StyleSheet.create({
  container: {
    marginTop: 5,
    flex: 1,
  },
  noDataFound: {
    fontSize: 20,
    textAlign: 'center',
    marginVertical: '20%',
  },
});
