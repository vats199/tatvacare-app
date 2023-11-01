import { DrawerItemList } from '@react-navigation/drawer';
import React, { useEffect, useState } from 'react';
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import DietOption from './DietOption';
import { Fonts, Matrics } from '../../constants';
import fonts from '../../constants/fonts';
import moment from 'moment';
import { useFocusEffect } from '@react-navigation/native';

interface ExactTimeProps {
  onPressPlus: (optionFoodItems: Options, mealName: string) => void;
  dietOption: boolean;
  cardData: MealsData;
  onpressOfEdit: (editeData: FoodItems, mealName: string) => void;
  onPressOfDelete: (deleteFoodItemId: string, is_food_item_added_by_patient: string) => void;
  onPressOfcomplete: (consumptionData: Consumption, optionId: string) => void;
  getCalories: (calories: Options) => void;
}

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
  consumed_calories: number;
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
const DietExactTime: React.FC<ExactTimeProps> = ({
  cardData,
  onPressPlus,
  dietOption,
  onpressOfEdit,
  onPressOfDelete,
  onPressOfcomplete,
  getCalories,
}) => {
  const [foodItmeData, setFoodItemData] = React.useState<Options | null>(
    cardData?.options[0],
  );
  const [selectedOptionId, setSelectedOptionId] = useState<string>(
    cardData?.options[0].diet_meal_options_id,
  );

  const filterMealData = () => {
    const itemFound = cardData?.options.filter(
      item => item.diet_meal_options_id == selectedOptionId,
    );
    return itemFound.length !== 0 ? itemFound : cardData.options;
  };

  const countCalories = (itemFound: Options) => {
    const data = itemFound;
    data.meal_name = cardData.meal_name;
    getCalories(data);
  };

  useEffect(() => {
    const itemFound = filterMealData();
    if (itemFound.length !== 0) {
      countCalories(itemFound[0]);
      setFoodItemData(itemFound[0]);
    }
  }, [selectedOptionId]);

  useEffect(() => {
    const itemFound = filterMealData();
    setFoodItemData(itemFound[0]);
  }, [cardData?.options[0]]);

  const handaleEdit = (data: FoodItems) => {
    onpressOfEdit(data, cardData.meal_name);
  };
  const handaleDelete = (Id: string, is_food_item_added_by_patient: string) => {
    onPressOfDelete(Id, is_food_item_added_by_patient);
  };
  const handlePulsIconPress = () => {
    if (selectedOptionId !== null) {
      let data = cardData.options.filter(
        item => item.diet_meal_options_id == selectedOptionId,
      )[0];
      onPressPlus(data, cardData.meal_name);
    } else {
      let data = cardData.options[0];
      onPressPlus(data, cardData.meal_name);
    }
  };
  const handalecompletion = (item: Consumption) => {
    console.log({ item: item, selectedOptionId });

    onPressOfcomplete(item, selectedOptionId);
  };

  const mealMessage = (name: string) => {
    switch (name) {
      case 'Breakfast':
        return 'Breakfast is a passport to morning.';
      case 'Dinner':
        return 'Dinner is a passport to better sleep.';
      case 'Lunch':
        return 'Lunch is a passport to noon.';
      default:
        return 'Snacks is a passport to evening.';
    }
  };
  const mealIcons = (name: string) => {
    switch (name) {
      case 'Breakfast':
        return <Icons.Breakfast />;
      case 'Dinner':
        return <Icons.Dinner />;
      case 'Lunch':
        return <Icons.Lunch />;
      default:
        return <Icons.Snacks />;
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.innerContainer}>
        <View style={styles.topRow}>
          <View style={styles.leftContent}>
            <View style={styles.circle}>{mealIcons(cardData.meal_name)}</View>
            <View style={styles.textContainer}>
              <Text style={styles.title}>{cardData?.meal_name}</Text>
              <Text style={styles.textBelowTitle}>
                {moment(cardData?.start_time, 'HH:mm:ss').format('h:mm A') +
                  ' - ' +
                  moment(cardData?.end_time, 'HH:mm:ss').format('h:mm A') +
                  ' | ' +
                  (isNaN(Math.round(Number(foodItmeData?.consumed_calories)))
                    ? 0
                    : Number(foodItmeData?.consumed_calories)
                  ).toFixed(0) +
                  ' of ' +
                  Number(foodItmeData?.total_calories).toFixed(0) +
                  'cal'}{' '}
              </Text>
            </View>
          </View>
          {/* {cardData.patient_permission === 'W' ? ( */}
          <TouchableOpacity
            onPress={handlePulsIconPress}
            style={styles.iconContainer}>
            <Icons.AddCircle height={25} width={25} />
          </TouchableOpacity>
          {/* // ) : null} */}
        </View>
        <View style={styles.line} />
        <View style={styles.belowRow}>
          {cardData?.options?.length > 0 ? (
            <>
              <ScrollView
                showsHorizontalScrollIndicator={false}
                horizontal
                bounces={false}
                style={{ flexDirection: 'row' }}>
                {cardData?.options?.map((item: Options, index: number) => {
                  const isOptionSelected =
                    selectedOptionId === item?.diet_meal_options_id;
                  return (
                    <TouchableOpacity
                      style={[
                        styles.optionContainer,
                        {
                          backgroundColor: isOptionSelected
                            ? colors.optionbackground
                            : colors.white,
                          borderColor: isOptionSelected
                            ? colors.themePurple
                            : colors.inputBoxLightBorder,
                          marginLeft: index == 0 ? Matrics.s(16) : 0,
                          marginRight: Matrics.s(13),
                        },
                      ]}
                      onPress={() =>
                        setSelectedOptionId(item.diet_meal_options_id)
                      }>
                      <Text style={styles.optionText}>Option {index + 1}</Text>
                    </TouchableOpacity>
                  );
                })}
              </ScrollView>
              <DietOption
                foodItmeData={
                  selectedOptionId !== null
                    ? cardData.options.filter(
                      item => item.diet_meal_options_id == selectedOptionId,
                    )[0]
                    : cardData.options[0]
                }
                patient_permission={cardData.patient_permission}
                onpressOfEdit={handaleEdit}
                onPressOfDelete={handaleDelete}
                onPressOfcomplete={handalecompletion}
              />
            </>
          ) : (
            <View style={styles.messageContainer}>
              <Text style={styles.message}>
                {mealMessage(cardData.meal_name)}
              </Text>
            </View>
          )}
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    borderColor: 'white',
    borderRadius: 12,
    marginVertical: 8,
    overflow: 'hidden',
    // shadowOffset: { width: 0, height: 0 },
    // shadowColor: '#171717',
    // shadowOpacity: 0.1,
    // shadowRadius: 3,
    // elevation: 2,
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  topRow: {
    paddingHorizontal: Matrics.s(14),
    paddingVertical: 8,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  leftContent: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  circle: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#F3F3F3',
    marginRight: 10,
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'center',
    alignContent: 'center',
  },
  textContainer: {
    flex: 1,
  },
  title: {
    fontSize: 16,
    fontWeight: 'bold',
    color: colors.labelDarkGray,
  },
  textBelowTitle: {
    fontSize: Matrics.mvs(13),
    color: '#444444',
  },
  line: {
    borderBottomWidth: Matrics.mvs(0.5),
    borderColor: '#808080',
    opacity: 0.5,
  },
  belowRow: {
    paddingVertical: Matrics.vs(15),
  },
  messageContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  message: {
    fontSize: Matrics.mvs(12),
    color: '#919191',
    fontWeight: '400',
    fontFamily: Fonts.REGULAR,
  },
  optionContainer: {
    height: Matrics.vs(28),
    width: Matrics.s(60),
    borderRadius: Matrics.mvs(8),
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
  },
  optionText: {
    fontFamily: Fonts.REGULAR,
    fontWeight: '500',
    color: colors.labelDarkGray,
    fontSize: Matrics.mvs(12),
  },
  iconContainer: {
    height: 30,
    width: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default DietExactTime;