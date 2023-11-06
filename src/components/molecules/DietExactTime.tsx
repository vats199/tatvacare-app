import {DrawerItemList} from '@react-navigation/drawer';
import React, {useEffect, useState} from 'react';
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import DietOption from './DietOption';
import {Constants, Fonts, Matrics} from '../../constants';
import fonts from '../../constants/fonts';
import moment from 'moment';
import {useFocusEffect} from '@react-navigation/native';
import {globalStyles} from '../../constants/globalStyles';
import {trackEvent} from '../../helpers/TrackEvent';

interface ExactTimeProps {
  onPressPlus: (optionFoodItems: Options, mealName: string) => void;
  dietOption: boolean;
  cardData: MealsData;
  onpressOfEdit: (editeData: FoodItems, mealName: string) => void;
  onPressOfDelete: (
    deleteFoodItemId: string,
    is_food_item_added_by_patient: string,
    optionId: string,
    data: FoodItems,
  ) => void;
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
    const index = cardData?.options?.findIndex(
      (item: Options, index: number) =>
        data.diet_meal_options_id == item?.diet_meal_options_id,
    );
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKED_ON_EDIT_MEAL, {
      meal_types: cardData?.meal_name ?? '',
      option_number: `Option ${index + 1}`,
      food_item_name: data?.food_item_name ?? '',
    });
    onpressOfEdit(data, cardData.meal_name);
  };
  const handaleDelete = (
    Id: string,
    is_food_item_added_by_patient: string,
    data: FoodItems,
  ) => {
    const index = cardData?.options?.findIndex(
      (item: Options, index: number) =>
        selectedOptionId == item?.diet_meal_options_id,
    );
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKED_ON_EDIT_MEAL, {
      meal_types: cardData?.meal_name ?? '',
      option_number: `Option ${index + 1}`,
      manual_tag: is_food_item_added_by_patient == 'N' ? 'no' : 'yes',
    });
    onPressOfDelete(Id, is_food_item_added_by_patient, selectedOptionId, data);
  };
  const handlePulsIconPress = () => {
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKED_ADD_FOOD_DISH, {
      meal_types: cardData?.meal_name,
      date: moment().format(Constants.DATE_FORMAT),
    });

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
    console.log({item: item, selectedOptionId});

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

  const onPressOption = (item: Options, index: number) => {
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKS_ON_OPTION, {
      meal_types: cardData?.meal_name ?? '',
      option_number: index + 1,
    });
    setSelectedOptionId(item.diet_meal_options_id);
  };

  return (
    <View style={[styles.container, globalStyles.shadowContainer]}>
      <View style={styles.topRow}>
        <View style={styles.leftContent}>
          <View style={styles.circle}>{mealIcons(cardData.meal_name)}</View>
          <View style={styles.textContainer}>
            <Text style={styles.title}>{cardData?.meal_name}</Text>
            <Text style={styles.textBelowTitle}>
              {cardData?.start_time && cardData?.end_time
                ? moment(cardData?.start_time, 'HH:mm:ss').format('h:mm A') +
                  ' - ' +
                  moment(cardData?.end_time, 'HH:mm:ss').format('h:mm A') +
                  ' | '
                : 'Ideal Time' + ' | '}
              <Text style={styles.caloriesTxt}>
                {(isNaN(Math.round(Number(foodItmeData?.consumed_calories)))
                  ? 0
                  : Number(foodItmeData?.consumed_calories)
                ).toFixed(0) +
                  ' of ' +
                  Number(foodItmeData?.total_calories).toFixed(0) +
                  'cal'}{' '}
              </Text>
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
      <View>
        {cardData.options.length > 0 ? (
          <>
            <ScrollView
              showsHorizontalScrollIndicator={false}
              horizontal
              bounces={false}
              style={{flexDirection: 'row'}}>
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
                          ? colors.labelDarkGray
                          : colors.inputBoxLightBorder,
                        marginLeft: index == 0 ? Matrics.s(16) : 0,
                        marginRight: Matrics.s(8),
                      },
                    ]}
                    onPress={() => {
                      onPressOption(item, index);
                    }}>
                    <Text
                      style={[
                        styles.optionText,
                        {
                          color: isOptionSelected
                            ? colors.labelDarkGray
                            : colors.subTitleLightGray,
                        },
                      ]}>
                      Option {index + 1}
                    </Text>
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
              mealName={cardData.meal_name}
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
  );
};

const styles = StyleSheet.create({
  container: {
    borderRadius: Matrics.mvs(12),
    marginVertical: Matrics.vs(8),
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(12),
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  topRow: {
    paddingHorizontal: Matrics.s(15),
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
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
  },
  textBelowTitle: {
    fontSize: Matrics.mvs(11),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
    lineHeight: 16,
  },
  line: {
    height: StyleSheet.hairlineWidth,
    backgroundColor: colors.seprator,
    marginTop: Matrics.vs(11),
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
    color: colors.darkGray,
    fontFamily: Fonts.REGULAR,
  },
  optionContainer: {
    height: Matrics.vs(28),
    width: Matrics.s(60),
    borderRadius: Matrics.mvs(8),
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    marginVertical: Matrics.vs(10),
    marginTop: Matrics.vs(15),
  },
  optionText: {
    fontFamily: Fonts.REGULAR,
    color: colors.labelDarkGray,
    fontSize: Matrics.mvs(12),
    lineHeight: 16,
  },
  iconContainer: {
    height: 30,
    width: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  caloriesTxt: {
    fontSize: Matrics.mvs(11),
    fontFamily: Fonts.REGULAR,
    color: colors.labelDarkGray,
  },
});

export default DietExactTime;
