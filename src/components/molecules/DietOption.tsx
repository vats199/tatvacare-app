import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Constants, Fonts, Matrics } from '../../constants';
import styled from 'styled-components/native';
import {
  Menu,
  MenuOptions,
  MenuOption,
  MenuTrigger,
} from 'react-native-popup-menu';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { trackEvent } from '../../helpers/TrackEvent';
import moment = require('moment');

type DietOptionItem = {
  foodItmeData: Options;
  patient_permission: string;
  onpressOfEdit: (editeData: FoodItems) => void;
  onPressOfDelete: (
    deleteFoodItemId: string,
    is_food_item_added_by_patient: string,
  ) => void;
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
  mealName
}) => {
  const insets = useSafeAreaInsets();

  const renderDietOptionItem = (item: FoodItems, index: number) => {
    const handaleEdit = (data: FoodItems) => {
      onpressOfEdit(data);
    };
    const handaleDelete = (
      Id: string,
      is_food_item_added_by_patient: string,
    ) => {
      onPressOfDelete(Id, is_food_item_added_by_patient);
    };
    const handaleFoodConsumption = (item: FoodItems) => {
      trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_LOGGED_MEAL, {
        meal_types: mealName,
        date: moment().format(Constants.DATE_FORMAT),
        food_item_name: item?.food_item_name,
        quantity: Number(item?.quantity),
        measure: item?.measure_name,
        flag: item?.is_consumed ? "off" : "on"
      })
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
              style={[styles.shadowContainer, { height: 28, width: 28 }]}>
              <Icons.Success height={28} width={28} />
            </TouchableOpacity>
          ) : (
            <TouchableOpacity
              onPress={() => handaleFoodConsumption(item)}
              style={[styles.shadowContainer, { height: 28, width: 28 }]}>
              <Icons.Ellipse height={28} width={28} />
            </TouchableOpacity>
          )}
          <View style={styles.titleDescription}>
            <View
              style={{
                flexDirection: 'row',
                flexWrap: 'wrap',
                alignItems: 'center',
              }}>
              <Text style={styles.title}>{item.food_item_name}</Text>
              {item.is_food_item_added_by_patient == 'Y' ? (
                <Text style={styles.manualBtnTxt}>Manual</Text>
              ) : null}
            </View>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <Text style={[styles.description, { textTransform: 'capitalize' }]}>
                {Math.round(Number(item?.quantity)) +
                  ' ' +
                  item?.measure_name +
                  '  | '}
              </Text>
              <Text style={[styles.description, { textTransform: 'lowercase' }]}>
                {Math.round(Number(item.total_micronutrients)) + ' g'}
              </Text>
            </View>
          </View>
        </View>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <Text style={styles.value}>
            {Math.round(Number(item.calories)) *
              Math.round(Number(item?.quantity))}
            cal
          </Text>
          {/* {patient_permission === 'W' ? ( */}
          <View>
            <Menu>
              <MenuTrigger
                customStyles={{
                  triggerTouchable: {
                    underlayColor: colors.transparent,
                  },
                }}>
                <Icons.ThreeDot
                  height={Matrics.mvs(16)}
                  width={Matrics.mvs(16)}
                />
              </MenuTrigger>
              <MenuOptions
                customStyles={{
                  optionsContainer: {
                    ...styles.menuOptionsContainer,
                    marginBottom:
                      index == foodItmeData?.food_items.length - 1
                        ? insets.bottom
                        : 0,
                    marginTop:
                      index !== foodItmeData?.food_items.length - 1
                        ? Matrics.vs(22)
                        : 0,
                  },
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
                    handaleDelete(
                      item?.diet_plan_food_item_id,
                      item?.is_food_item_added_by_patient,
                    );
                  }}>
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
          <Text style={styles.foodItemTipTxt}>
            {'1. ' + foodItmeData?.tips}
          </Text>
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
    marginVertical: Matrics.vs(8),
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
    fontSize: Matrics.mvs(13),
    color: colors.labelDarkGray,
    fontFamily: Fonts.REGULAR,
    textTransform: 'capitalize',
    lineHeight: 18,
    marginRight: Matrics.s(4),
  },
  description: {
    fontSize: Matrics.mvs(11),
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
    lineHeight: 16,
  },
  value: {
    fontSize: Matrics.mvs(13),
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
    lineHeight: 16,
    marginHorizontal: Matrics.s(3),
  },
  belowContainer: {
    borderWidth: Matrics.s(0.5),
    borderColor: colors.lightGrey,
    borderRadius: Matrics.s(16),
    padding: Matrics.mvs(10),
    paddingHorizontal: Matrics.s(15),
    marginVertical: Matrics.vs(6),
    marginHorizontal: Matrics.s(16),
    backgroundColor: colors.white,
  },
  threeDot: {
    width: Matrics.s(20),
  },
  menuOptionsContainer: {
    borderRadius: Matrics.mvs(12),
    width: Matrics.s(75),
    // marginTop: Matrics.vs(20),
    paddingVertical: Matrics.mvs(2),
  },
  optionContainer: {
    flexDirection: 'row',
    paddingHorizontal: Matrics.s(5),
    paddingVertical: Matrics.vs(2),
    alignItems: 'center',
  },
  optionText: {
    paddingHorizontal: Matrics.s(6),
    lineHeight: 15,
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
  },
  line: {
    backgroundColor: colors.inputBoxLightBorder,
    height: Matrics.vs(1),
  },
  manualBtnTxt: {
    backgroundColor: '#E0E0E0',
    paddingHorizontal: Matrics.s(10),
    paddingVertical: Matrics.vs(3),
    borderRadius: Matrics.mvs(10),
    overflow: 'hidden',
    color: '#616161',
    fontSize: Matrics.mvs(11),
    fontFamily: Fonts.REGULAR,
    lineHeight: 16,
  },
  shadowContainer: {
    shadowOffset: { width: 0, height: 0 },
    shadowColor: colors.shadow,
    shadowOpacity: 0.1,
    shadowRadius: 3,
    elevation: 3,
  },
  foodItemTipTxt: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(12),
    lineHeight: 20,
    color: colors.subTitleLightGray,
  },
});
