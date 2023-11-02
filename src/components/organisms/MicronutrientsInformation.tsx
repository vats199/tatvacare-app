import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import Matrics from '../../constants/Matrics';

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
  icon: any;
};
const MicronutrientsInformation: React.FC<MicronutrientsInformationProps> = ({
  foodItemDetails,
}) => {
  const options: NutritionData[] = [
    {
      name: 'Protein',
      value: foodItemDetails?.protein,
      icons: <Icons.Protein />,
    },
    {
      name: 'Fats',
      value: foodItemDetails?.fats,
      icons: <Icons.Fats />,
    },
    {
      name: 'Carbs',
      value: foodItemDetails?.carbs,
      icons: <Icons.Carbs />,
    },
    {
      name: 'Fibers',
      value: foodItemDetails?.fibers,
      icons: <Icons.Fiber />,
    },
  ];

  const renderNutritionDataItem = (item: NutritionData, index: number) => {
    return (
      <View style={styles.belowRow} key={index}>
        <View style={styles.topRow}>
          <View style={styles.square}>{item.icons}</View>
          <Text style={styles.name}>{item.name}</Text>
        </View>
        <Text style={styles.value}>
          {item.value.replace('g', '').replace('m', '') + " g"}
        </Text>
      </View>
    );
  };

  return (
    <View style={styles.outerContainer}>
      <Text style={styles.title}>Macronutrients Information</Text>
      <View style={styles.container}>
        <View style={styles.innerContainer}>
          <View style={styles.topRow}>
            <View>
              <Text style={styles.calorieValue}>
                {Math.round(Number(foodItemDetails?.calories))}
              </Text>
              <Text>Calories</Text>
            </View>
            <View style={styles.circle}>
              <Icons.Flame />
            </View>
          </View>
          <View style={styles.borderline} />
          <View>{options.map(renderNutritionDataItem)}</View>
        </View>
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
    fontSize: 16,
    fontWeight: '700',
    color: colors.labelDarkGray,
    fontFamily: Fonts.BOLD,
    marginVertical: 8,
  },
  container: {
    borderWidth: 0.1,
    borderColor: '#808080',
    overflow: 'hidden',
    borderRadius: 12,
  },
  innerContainer: {
    backgroundColor: 'white',
    padding: 14,
  },
  topRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  calorieValue: {
    fontSize: 20,
    fontWeight: 'bold',
    color: colors.black,
  },
  borderline: {
    borderBottomWidth: 0.2,
    borederColor: colors.lightGrey,
    marginVertical: 10,
  },
  belowRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 6,
  },
  square: {
    width: 25,
    height: 25,
    backgroundColor: '#F3F3F3',
    marginRight: 10,
    justifyContent: 'center',
    alignItems: 'center',
  },
  name: {
    fontSize: 14,
    color: colors.subTitleLightGray,
  },
  value: {
    fontSize: 14,
    color: colors.subTitleLightGray,
  },
  circle: {
    width: Matrics.s(36),
    height: Matrics.vs(36),
    backgroundColor: '#F3F3F3',
    marginRight: 10,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 18,
  },
});
