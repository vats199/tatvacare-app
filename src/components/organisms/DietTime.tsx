import { StyleSheet, ScrollView, View, Text, FlatList } from 'react-native';
import React, { useEffect, useState } from 'react';
import DietExactTime from '../molecules/DietExactTime';
import { Matrics } from '../../constants';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { OptionType } from '../../context/diet.context';

type DietTimeProps = {
  onPressPlus: (optionFoodItems: Options, mealName: string) => void;
  dietPlane: MealsData[];
  onpressOfEdit: (editeData: FoodItems, mealName: string) => void;
  onPressOfDelete: (
    deleteFoodItemId: string,
    is_food_item_added_by_patient: string,
    optionId: string,
    data: FoodItems,
    mealId: string,
  ) => void;
  onPressOfcomplete: (
    consumptionData: Consumption,
    optionId: string,
    mealId: string,
  ) => void;
  options?: OptionType[];
};

export type MealsData = {
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
export type FoodItems = {
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
  dietPlane,
  onpressOfEdit,
  onPressOfDelete,
  onPressOfcomplete,
  options,
}) => {
  const insets = useSafeAreaInsets();

  const handaleEdit = (data: FoodItems, mealName: string) => {
    onpressOfEdit(data, mealName);
  };
  const handaleDelete = (
    Id: string,
    is_food_item_added_by_patient: string,
    optionId: string,
    data: FoodItems,
    mealId: string,
  ) => {
    onPressOfDelete(Id, is_food_item_added_by_patient, optionId, data, mealId);
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
  const renderDietTimeItem = ({
    item,
    index,
  }: {
    item: MealsData;
    index: number;
  }) => {
    return (
      <DietExactTime
        key={index}
        onPressPlus={handlePulsIconPress}
        cardData={item}
        onpressOfEdit={handaleEdit}
        optionId={item.options[0].diet_meal_options_id}
        onPressOfDelete={(
          deleteFoodItemId,
          is_food_item_added_by_patient,
          optionId,
          data,
        ) =>
          handaleDelete(
            deleteFoodItemId,
            is_food_item_added_by_patient,
            optionId,
            data,
            item.meal_types_id,
          )
        }
        onPressOfcomplete={(consumptionData, optionId) =>
          handalecompletion(consumptionData, optionId, item.meal_types_id)
        }
        options={options}
      />
    );
  };

  return (
    <View
      style={{
        paddingBottom: insets.bottom,
        flex: 1,

      }}>
      <FlatList
        style={styles.innercontainer}
        showsVerticalScrollIndicator={false}
        data={dietPlane}
        renderItem={renderDietTimeItem}
        keyExtractor={(item, index) => index.toString()}
      />
    </View>
  );
};

export default DietTime;

const styles = StyleSheet.create({
  innercontainer: {
    flex: 1,
    paddingHorizontal: Matrics.s(15),
    marginTop: Matrics.vs(5),
  },
  noDataFound: {
    fontSize: 20,
    textAlign: 'center',
    marginVertical: '20%',
  },
});
