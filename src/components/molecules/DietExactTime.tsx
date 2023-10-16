import { DrawerItemList } from '@react-navigation/drawer';
import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import DietOption from './DietOption';
import { Fonts, Matrics } from '../../constants';
import fonts from '../../constants/fonts';

interface ExactTimeProps {
  onPressPlus: (optionId: string) => void;
  dietOption: boolean;
  cardData: MealsData;
  onpressOfEdit: (editeData: FoodItems) => void;
  onPressOfDelete: (deleteFoodItemId: string) => void;
}


type MealsData = {
  diet_meal_type_rel_id: string,
  diet_plan_id: string,
  meal_types_id: string
  meal_name: string,
  start_time: string,
  end_time: string,
  order_no: number,
  is_hidden: string,
  patient_permission: string,
  is_active: string,
  is_deleted: string,
  updated_by: string,
  created_at: string,
  updated_at: string,
  options: Options[]
}

type Options = {
  diet_meal_options_id: string,
  diet_meal_type_rel_id: string,
  options_name: string,
  tips: string
  total_calories: string,
  total_carbs: string,
  total_proteins: string,
  total_fats: string,
  total_fibers: string,
  total_sodium: string,
  total_potassium: string,
  total_sugar: string,
  total_saturated_fatty_acids: null,
  total_monounsaturated_fatty_acids: null,
  total_polyunsaturated_fatty_acids: string,
  total_fatty_acids: null,
  order_no: number,
  is_active: string,
  is_deleted: string,
  updated_by: string,
  created_at: string,
  updated_at: string,
  food_items: FoodItems[]
}
type FoodItems = {
  diet_plan_food_item_id: string,
  diet_meal_options_id: string,
  food_item_id: number,
  food_item_name: string,
  quantity: number,
  measure_id: null,
  measure_name: string,
  protein: string,
  carbs: string,
  fats: string,
  fibers: string,
  calories: string,
  sodium: string,
  potassium: string,
  sugar: string,
  saturated_fatty_acids: null,
  monounsaturated_fatty_acids: null,
  polyunsaturated_fatty_acids: null,
  fatty_acids: string,
  is_active: string,
  is_deleted: string,
  updated_by: string,
  created_at: string,
  updated_at: string,
  consumption: Consumption,
  is_consumed: boolean,
  consumed_calories: number
}

type Consumption = {
  consumed_qty: number,
  diet_plan_id: string,
  diet_plan_food_item_id: string,
  date: string,
  diet_plan_food_consumption_id: null
}
const DietExactTime: React.FC<ExactTimeProps> = ({
  cardData,
  onPressPlus,
  dietOption, onpressOfEdit, onPressOfDelete
}) => {
  const [foodItmeData, setFoodItemData] = React.useState<Options | null>(cardData?.options[0])

  const handaleEdit = (data: FoodItems) => {

    onpressOfEdit(data);
  };
  const handaleDelete = (Id: string) => {
    onPressOfDelete(Id);
  };
  const handlePulsIconPress = () => {
    onPressPlus(foodItmeData?.diet_meal_options_id)
  }
  // const sum = cardData?.reduce((accumulator : any, currentValue:any) => accumulator + currentValue, 0);
  // console.log("sum", sum);

  return (
    <View style={styles.container}>
      <View style={styles.innerContainer}>
        <View style={styles.topRow}>
          <View style={styles.leftContent}>
            <View style={styles.circle} />
            <View style={styles.textContainer}>
              <Text style={styles.title}>{cardData?.meal_name}</Text>
              <Text style={styles.textBelowTitle}>
                Ideal Time | 0 of 600 cal
              </Text>
            </View>
          </View>
          {cardData.patient_permission === "W" ?
            <TouchableOpacity onPress={handlePulsIconPress} style={styles.iconContainer}>
              <Icons.AddCircle height={25} width={25} />
            </TouchableOpacity>
            : null}
        </View>
        <View style={styles.line} />
        <View style={styles.belowRow}>

          {cardData?.options?.length > 0 ? (
            <>
              <View style={{ flexDirection: 'row' }}>
                {cardData?.options?.map((item: Options, index: number) => {
                  const isOptionSelected = foodItmeData?.diet_meal_options_id === item?.diet_meal_options_id
                  return (
                    <TouchableOpacity style={[styles.optionContainer, { backgroundColor: isOptionSelected ? colors.optionbackground : colors.white, borderColor: isOptionSelected ? colors.themePurple : colors.inputBoxLightBorder }]} onPress={() => setFoodItemData(item)}>
                      <Text >Option {index + 1}</Text>
                    </TouchableOpacity>
                  )
                })}
              </View>
              <DietOption foodItmeData={foodItmeData} patient_permission={cardData.patient_permission} onpressOfEdit={handaleEdit} onPressOfDelete={handaleDelete} />
            </>
          ) : (
            <View style={styles.messageContainer}>
              <Text>{"Breakfast is a passport to morning"}</Text>
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

  },
  innerContainer: {
    backgroundColor: 'white',
  },
  topRow: {
    paddingHorizontal: 18,
    paddingVertical: 8,
    flexDirection: 'row',
    alignItems: 'center',
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
    fontSize: 13,
    color: '#444444',
  },
  line: {
    borderBottomWidth: 0.2,
    borderColor: '#808080',
  },
  belowRow: {
    padding: 15,
  },
  messageContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  message: {
    fontSize: 13,
    color: '#C5C5C5',
  },
  optionContainer: {
    height: Matrics.vs(30),
    width: Matrics.s(60),
    borderRadius: Matrics.mvs(8),
    justifyContent: 'center',
    alignItems: "center",
    marginLeft: Matrics.s(10),
    borderWidth: 1
  },
  optionText: {
    fontFamily: Fonts.REGULAR,
    fontWeight: "500",
    color: colors.labelDarkGray,

  },
  iconContainer: { height: 30, width: 30, justifyContent: 'center', alignItems: 'center' }
});

export default DietExactTime;


