import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import {Fonts} from '../../constants';
import Matrics from '../../constants/Matrics';
import {globalStyles} from '../../constants/globalStyles';

type MicronutrientsInformationProps = {
  foodItemDetails: FoodItems;
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
  consumption: any;
  is_consumed: boolean;
  consumed_calories: number;
};
type NutritionData = {
  name: string;
  value: string;
  icon: React.ReactNode;
};
const MicronutrientsInformation: React.FC<MicronutrientsInformationProps> = ({
  foodItemDetails,
}) => {
  const options: NutritionData[] = [
    {
      name: 'Protein',
      value: foodItemDetails?.protein,
      icon: <Icons.Protein />,
    },
    {
      name: 'Fats',
      value: foodItemDetails?.fats,
      icon: <Icons.Fats />,
    },
    {
      name: 'Carbs',
      value: foodItemDetails?.carbs,
      icon: <Icons.Carbs />,
    },
    {
      name: 'Fibers',
      value: foodItemDetails?.fibers,
      icon: <Icons.Fiber />,
    },
  ];

  const renderNutritionDataItem = (item: NutritionData, index: number) => {
    return (
      <View style={styles.belowRow} key={index}>
        <View style={styles.topRow}>
          <View style={styles.square}>{item.icon}</View>
          <Text style={styles.name}>{item.name}</Text>
        </View>
        <Text style={styles.value}>
          {item.value.replace('g', '').replace('m', '') + ' g'}
        </Text>
      </View>
    );
  };

  return (
    <View style={styles.outerContainer}>
      <Text style={styles.title}>Macronutrients Information</Text>
      <View style={[globalStyles.shadowContainer, styles.container]}>
        <View style={styles.topRow}>
          <View>
            <Text style={styles.calorieValue}>
              {Math.round(Number(foodItemDetails?.calories))}
            </Text>
            <Text
              style={{
                fontFamily: Fonts.REGULAR,
                fontSize: Matrics.mvs(11),
                color: colors.subTitleLightGray,
                lineHeight: 16,
                marginTop: Matrics.vs(2),
              }}>
              Calories
            </Text>
          </View>
          <View style={styles.circle}>
            <Icons.Flame />
          </View>
        </View>
        <View style={styles.borderline} />
        <View>{options.map(renderNutritionDataItem)}</View>
      </View>
    </View>
  );
};

export default MicronutrientsInformation;

const styles = StyleSheet.create({
  outerContainer: {
    marginHorizontal: Matrics.s(15),
  },
  title: {
    fontSize: Matrics.mvs(16),
    color: colors.labelDarkGray,
    fontFamily: Fonts.BOLD,
    marginVertical: Matrics.vs(5),
    marginBottom: Matrics.vs(10),
  },
  container: {
    borderRadius: Matrics.mvs(12),
    backgroundColor: colors.white,
    padding: Matrics.mvs(14),
    shadowOpacity: 0.1,
  },
  topRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  calorieValue: {
    fontSize: Matrics.mvs(19),
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
    lineHeight: 26,
  },
  borderline: {
    height: Matrics.s(1),
    backgroundColor: colors.seprator,
    marginVertical: Matrics.vs(12),
  },
  belowRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 6,
  },
  square: {
    width: Matrics.mvs(25),
    height: Matrics.mvs(25),
    marginRight: Matrics.s(10),
    justifyContent: 'center',
    alignItems: 'center',
  },
  name: {
    fontSize: Matrics.mvs(13),
    fontFamily: Fonts.REGULAR,
    lineHeight: 18,
    color: colors.subTitleLightGray,
  },
  value: {
    fontSize: Matrics.mvs(13),
    fontFamily: Fonts.REGULAR,
    lineHeight: 18,
    color: colors.subTitleLightGray,
  },
  circle: {
    width: Matrics.mvs(36),
    height: Matrics.mvs(36),
    backgroundColor: '#F3F3F3',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: Matrics.mvs(36),
  },
});
