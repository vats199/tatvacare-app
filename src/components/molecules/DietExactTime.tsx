import { DrawerItemList } from '@react-navigation/drawer';
import React, { useEffect, useState, useRef } from 'react';
import {
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import DietOption from './DietOption';
import { Constants, Fonts, Matrics } from '../../constants';
import fonts from '../../constants/fonts';
import moment from 'moment';
import { useFocusEffect } from '@react-navigation/native';
import { globalStyles } from '../../constants/globalStyles';
import { trackEvent } from '../../helpers/TrackEvent';
import { OptionType, useDiet } from '../../context/diet.context';
interface ExactTimeProps {
  onPressPlus: (optionFoodItems: Options, mealName: string) => void;
  cardData: MealsData;
  onpressOfEdit: (editeData: FoodItems, mealName: string) => void;
  onPressOfDelete: (
    deleteFoodItemId: string,
    is_food_item_added_by_patient: string,
    optionId: string,
    data: FoodItems,
  ) => void;
  onPressOfcomplete: (consumptionData: Consumption, optionId: string) => void;
  optionId: string;
  totalPreCalories: number;
  totalPreConsumedCalories: number;
  setTotalPreCalories: React.Dispatch<React.SetStateAction<number>>;
  setTotalPreConsumedCalories: React.Dispatch<React.SetStateAction<number>>;
  options?: OptionType[];
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
  onpressOfEdit,
  onPressOfDelete,
  onPressOfcomplete,
  optionId,
  options,
}) => {
  const { updateOptionsId, selectedOptionsId, dietPlanData } = useDiet();
  const [foodItmeData, setFoodItemData] = React.useState<Options | null>(null);
  const _selectedOptionId = useRef<string>(optionId);

  useEffect(() => {
    if (Array.isArray(options) && options.length !== 0) {
      const tempOption = cardData.options.find(item =>
        options?.find(
          q =>
            q.mealId == item?.diet_meal_type_rel_id &&
            q.optionId == item?.diet_meal_options_id,
        ),
      );
      if (tempOption?.diet_meal_options_id) {
        _selectedOptionId.current = tempOption?.diet_meal_options_id;
      }
    } else {
      const mealFound = selectedOptionsId?.current?.find(
        item =>
          item.mealId == cardData?.diet_meal_type_rel_id &&
          item.optionId == optionId,
      );
      let selectedOption;
      if (mealFound?.mealId && mealFound?.optionId) {
        selectedOption = mealFound?.optionId;
      } else {
        selectedOption = optionId;
      }
      _selectedOptionId.current = selectedOption;
    }
  }, [optionId]);

  useEffect(() => {
    const param = {
      mealId: cardData?.diet_meal_type_rel_id,
      optionId: _selectedOptionId.current,
    };
    updateOptionsId(param);
  }, [_selectedOptionId?.current]);

  useEffect(() => {
    const tempArray = selectedOptionsId?.current?.length > 0 ? [...selectedOptionsId?.current] : [];
    if (tempArray?.length !== 0) {
      dietPlanData?.meals?.map((item: any) =>
        tempArray?.map(q => {
          if (q?.mealId == item?.diet_meal_type_rel_id) {
            const optionData = item?.options.filter(
              (op: any) => op?.diet_meal_options_id == _selectedOptionId?.current,
            );
            if (optionData?.length !== 0) {
              setFoodItemData(optionData[0]);
            }
          }
        }),
      );
    }
  }, [dietPlanData, _selectedOptionId?.current]);

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
        _selectedOptionId.current == item?.diet_meal_options_id,
    );
    trackEvent(Constants?.EVENT_NAME?.FOOD_DIARY?.USER_CLICKED_ON_EDIT_MEAL, {
      meal_types: cardData?.meal_name ?? '',
      option_number: `Option ${index + 1}`,
      manual_tag: is_food_item_added_by_patient == 'N' ? 'no' : 'yes',
    });
    onPressOfDelete(
      Id,
      is_food_item_added_by_patient,
      _selectedOptionId?.current,
      data,
    );
  };

  const handlePulsIconPress = () => {
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKED_ADD_FOOD_DISH, {
      meal_types: cardData?.meal_name,
      date: moment().format(Constants?.DATE_FORMAT),
    });

    if (_selectedOptionId.current !== null) {
      let data = cardData?.options.filter(
        item => item?.diet_meal_options_id == _selectedOptionId?.current,
      )[0];
      onPressPlus(data, cardData.meal_name);
    } else {
      let data = cardData?.options[0];
      onPressPlus(data, cardData.meal_name);
    }
  };
  const handalecompletion = (item: Consumption) => {
    onPressOfcomplete(item, _selectedOptionId?.current);
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
    _selectedOptionId.current = item?.diet_meal_options_id;

    const tempOption = {
      mealId: item?.diet_meal_type_rel_id,
      optionId: item?.diet_meal_options_id,
    };

    updateOptionsId(tempOption);
  };

  return (
    <View style={[styles.container, globalStyles.shadowContainer]}>
      <View style={styles.topRow}>
        <View style={styles.leftContent}>
          <View style={styles.circle}>{mealIcons(cardData?.meal_name)}</View>
          <View style={styles.textContainer}>
            <Text style={styles.title}>{cardData?.meal_name}</Text>
            <Text style={styles.textBelowTitle}>
              {cardData?.start_time && cardData?.end_time
                ? moment(cardData?.start_time, 'HH:mm:ss').format('h:mm A') +
                ' - ' +
                moment(cardData?.end_time, 'HH:mm:ss').format('h:mm A') +
                ' | '
                : 'Ideal Time' + ' | '}
              <Text style={styles?.caloriesTxt}>
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
        <TouchableOpacity
          onPress={handlePulsIconPress}
          style={styles.iconContainer}>
          <Icons.AddCircle height={20} width={20} />
        </TouchableOpacity>
      </View>
      <View style={styles.line} />
      <View>
        {cardData.options.length > 0 ? (
          <>
            <FlatList
              showsHorizontalScrollIndicator={false}
              horizontal
              bounces={false}
              style={{ flexDirection: 'row' }}
              data={cardData?.options}
              keyExtractor={(item, index) => index.toString()}
              renderItem={({ item, index }) => {
                const isOptionSelected =
                  _selectedOptionId.current === item?.diet_meal_options_id;
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
              }}
            />
            <DietOption
              foodItmeData={
                _selectedOptionId.current !== null
                  ? cardData?.options.filter(
                    item =>
                      item.diet_meal_options_id == _selectedOptionId.current,
                  )[0]
                  : cardData?.options[0]
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
