import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Matrics } from '../../constants';
import {
  Menu,
  MenuOptions,
  MenuOption,
  MenuTrigger,
} from 'react-native-popup-menu';

type DietOptionItem = {
  foodItmeData: Options;
  patient_permission: string;
  onpressOfEdit: (editeData: FoodItems) => void;
  onPressOfDelete: (deleteFoodItemId: string) => void;
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
const DietOption: React.FC<DietOptionItem> = ({
  foodItmeData,
  patient_permission,
  onpressOfEdit,
  onPressOfDelete, 
}) => {
  const renderDietOptionItem = (item: FoodItems, index: number) => {

    const handaleEdit = (data: FoodItems) => {
      onpressOfEdit(data);
    };
    const handaleDelete = (Id: string) => {
      onPressOfDelete(Id);
    };

    return (
      <View style={styles.OptionitemContainer} key={index}>
        <View style={styles.leftContainer}>
          <Icons.Ellipse height={28} width={28} />
          <View style={styles.titleDescription}>
            <Text style={styles.title}>{item.food_item_name}</Text>
            <Text style={styles.description}>
              {'Quantity | Micronutrients'}
            </Text>
          </View>
        </View>
        <View style={{ flexDirection: 'row' }}>
          <Text style={styles.value}>{item.calories}cal</Text>
          {patient_permission === 'W' ? (
            <View>
              <Menu>
                <MenuTrigger>
                  <Icons.ThreeDot />
                </MenuTrigger>
                <MenuOptions
                  customStyles={{
                    optionsContainer: styles.menuOptionsContainer,
                  }}>
                  <MenuOption onSelect={() => handaleEdit(item)}>
                    <View style={styles.optionContainer}>
                      <Icons.Edit />
                      <Text style={styles.optionText}>Edit</Text>
                    </View>
                  </MenuOption>
                  <View style={styles.line}></View>
                  <MenuOption onSelect={() => handaleDelete(item?.diet_plan_food_item_id)}>
                    <View style={styles.optionContainer}>
                      <Icons.Delete />
                      <Text style={styles.optionText}>Delete</Text>
                    </View>
                  </MenuOption>
                </MenuOptions>
              </Menu>
            </View>
          ) : (
            <View style={styles.threeDot}></View>
          )}
        </View>
      </View>
    );
  };

  return (
    <View>
      {foodItmeData?.food_items?.map(renderDietOptionItem)}
      <View style={styles.belowContainer}>
        {foodItmeData?.tips ? (
          <Text>{'1 ' + foodItmeData?.tips}</Text>
        ) : (
          <Text>{'no tips yet!'}</Text>
        )}
      </View>
    </View>
  );
};

export default DietOption;

const styles = StyleSheet.create({
  OptionitemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 10,
    marginHorizontal: 5,
  },
  leftContainer: {
    flexDirection: 'row',
  },
  titleDescription: {
    marginLeft: 10,
  },
  title: {
    fontSize: 15,
    color: colors.black,
  },
  description: {
    fontSize: 14,
    color: '#444444',
  },
  value: {
    fontSize: 15,
    color: colors.black,
    marginTop: 5,
  },
  belowContainer: {
    borderWidth: 0.5,
    borderColor: colors.darkGray,
    borderRadius: 15,
    padding: 15,
    marginVertical: 6,
    marginHorizontal: 10,
  },
  threeDot: {
    width: Matrics.s(20),
  },
  menuOptionsContainer: {
    borderRadius: 10,
    width: Matrics.s(80),
    marginTop: Matrics.vs(22),
  },
  optionContainer: { flexDirection: 'row', paddingHorizontal: 5 },
  optionText: { paddingHorizontal: 10 },
  line: {
    backgroundColor: colors.inputBoxLightBorder,
    height: 1,
  },
});
