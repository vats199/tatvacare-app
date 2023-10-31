import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import styled from 'styled-components/native';
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
  onPressOfDelete: (deleteFoodItemId: string, is_food_item_added_by_patient: string) => void;
  onPressOfcomplete: (consumptionData: Consumption) => void;
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
  total_macronutrients: number;
  total_micronutrients: number;
  is_food_item_added_by_patient: string;
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
  onPressOfcomplete,
}) => {
  const renderDietOptionItem = (item: FoodItems, index: number) => {
    const handaleEdit = (data: FoodItems) => {
      onpressOfEdit(data);
    };
    const handaleDelete = (Id: string, is_food_item_added_by_patient: string) => {
      onPressOfDelete(Id, is_food_item_added_by_patient);
    };
    const handaleFoodConsumption = (item: FoodItems) => {
      const cunsumpotion = {
        consumed_qty: item?.is_consumed
          ? 0
          : Math.round(Number(item?.quantity)),
        diet_plan_id: item?.consumption?.diet_plan_id,
        diet_plan_food_item_id: item?.consumption?.diet_plan_food_item_id,
        date: item?.consumption?.date,
        diet_plan_food_consumption_id:
          item?.consumption?.diet_plan_food_consumption_id,
      };
      onPressOfcomplete(cunsumpotion);
    };

    return (
      <View style={styles.OptionitemContainer} key={index}>
        <View style={styles.leftContainer}>
          {item?.is_consumed ? (
            <TouchableOpacity
              onPress={() => handaleFoodConsumption(item)}
              style={{ height: 28, width: 28 }}>
              <Icons.Success height={28} width={28} />
            </TouchableOpacity>
          ) : (
            <TouchableOpacity
              onPress={() => handaleFoodConsumption(item)}
              style={{ height: 28, width: 28 }}>
              <Icons.Ellipse height={28} width={28} />
            </TouchableOpacity>
          )}
          <View style={styles.titleDescription}>
            <Text style={styles.title}>{item.food_item_name}</Text>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <Text style={styles.description}>
                {Math.round(Number(item?.quantity)) +
                  ' | ' +
                  Math.round(Number(item.total_micronutrients)) +
                  ' g'}
              </Text>
              {item.is_food_item_added_by_patient == 'Y' ? (
                <Text style={styles.manualBtnTxt}>Manual</Text>
              ) : null}
            </View>
          </View>
        </View>
        <View style={{ flexDirection: 'row' }}>
          <Text style={styles.value}>
            {Math.round(Number(item.calories)) *
              Math.round(Number(item?.quantity))}
            cal
          </Text>
          {/* {patient_permission === 'W' ? ( */}
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
                <MenuOption
                  onSelect={() => {
                    console.log("++++++++++++++++++>",)

                    handaleDelete(item?.diet_plan_food_item_id, item?.is_food_item_added_by_patient)
                  }
                  }>
                  <View style={styles.optionContainer}>
                    <Icons.remove />
                    <Text style={styles.optionText}>Delete</Text>
                  </View>
                </MenuOption>
              </MenuOptions>
            </Menu>
          </View>
          {/* ) : (
            <View style={styles.threeDot}></View>
          )} */}
        </View>
      </View>
    );
  };

  return (
    <View>
      {foodItmeData?.food_items?.map(renderDietOptionItem)}
      {foodItmeData?.tips ? (
        <View style={styles.belowContainer}>
          <Text>{'1.  ' + foodItmeData?.tips}</Text>
        </View>
      ) : null}
    </View>
  );
};

export default DietOption;

const styles = StyleSheet.create({
  OptionitemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginVertical: 10,
    alignItems: 'center',
    marginHorizontal: Matrics.s(15),
  },
  leftContainer: {
    flexDirection: 'row',
    flex: 1,
  },
  titleDescription: {
    marginLeft: 10,
    flex: 1,
  },
  title: {
    fontSize: Matrics.mvs(14),
    color: colors.black,
    textTransform: 'capitalize',
  },
  description: {
    fontSize: Matrics.mvs(14),
    color: '#444444',
  },
  value: {
    fontSize: Matrics.mvs(14),
    color: colors.black,
  },
  belowContainer: {
    borderWidth: 0.4,
    borderColor: colors.darkGray,
    borderRadius: 15,
    padding: 11,
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
  optionText: {
    paddingHorizontal: Matrics.s(10),
    lineHeight: 15,
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
  },
  line: {
    backgroundColor: colors.inputBoxLightBorder,
    height: 1,
  },
  manualBtnTxt: {
    marginHorizontal: Matrics.s(8),
    backgroundColor: '#E0E0E0',
    paddingHorizontal: Matrics.s(8),
    paddingVertical: Matrics.vs(3),
    borderRadius: Matrics.mvs(10),
    marginTop: Matrics.s(2),
    overflow: 'hidden',
    color: '#616161',
    fontSize: Matrics.mvs(11),
  },
});
