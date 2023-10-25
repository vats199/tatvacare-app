import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import Button from '../atoms/Button';
import DropdownComponent from '../atoms/Dropdown';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import Matrics from '../../constants/Matrics';

type AddDietProps = {
  onPressAdd: () => void;
  buttonText: string;
  onSeleteQty: (qty: string) => void;
  Data: FoodItems;
  mealName: string
};
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
  consumption: any,
  is_consumed: boolean,
  consumed_calories: number
}
type NutritionData = {
  name: string;
  value: string;
};
const AddDiet: React.FC<AddDietProps> = ({
  onPressAdd,
  buttonText,
  onSeleteQty, Data, mealName
}) => {
  const data = [
    { label: '1', value: '1' },
    { label: '2', value: '2' },
    { label: '3', value: '3' },
    { label: '4', value: '4' },
    { label: '5', value: '5' },
  ];
  const handleSelectedQty = (ietm: string) => {
    onSeleteQty(ietm);
  };
  const handleSelectedMeasures = (ietm: string) => { };


  return (
    <View style={styles.container}>
      <View style={styles.innerContainer}>
        <Text style={styles.title}>{"Add " + Data?.food_item_name + " as " + mealName}</Text>
        <View style={styles.borderline} />
        <View style={styles.belowBox}>
          <View style={styles.belowBoxContent}>
            <View style={styles.dropdownContainer}>
              <DropdownComponent
                data={data}
                defaultValues={Math.round(Number(Data?.quantity)).toString()}
                dropdownStyle={{ width: '48%' }}
                placeholder="Quantity"
                placeholderStyle={styles.dropdownTitleText}
                selectedItem={handleSelectedQty}
                isDisable={false}
                containerStyle={styles.conatiner}
              />
              <View style={styles.measureContainer}>
                <Text style={styles.dropdownTitleText}>{Data?.measure_name}</Text>
                <Icons.DropdownIcon />
              </View>
            </View>
            <Button
              title={buttonText}
              titleStyle={styles.outlinedButtonText}
              buttonStyle={styles.outlinedButton}
              onPress={onPressAdd}
            />
          </View>
        </View>
      </View>
    </View>
  );
};

export default AddDiet;


const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    borderColor: '#808080',
    overflow: 'hidden',
    borderTopRightRadius: 20,
    borderTopLeftRadius: 20,
    elevation: 8,
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  title: {
    marginLeft: 14,
    marginVertical: 20,
    fontSize: Matrics.mvs(16),
    fontWeight: 'bold',
    color: colors.black,
  },
  borderline: {
    borderBottomWidth: Matrics.mvs(0.5),
    borederColor: colors.inputBoxLightBorder,
    opacity: 0.3
  },
  belowBox: {
    paddingHorizontal: 16,
    paddingBottom: 20,
  },
  belowBoxContent: {
    width: '100%',
    justifyContent: 'center', alignItems: 'center'
  },
  dropdownContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 25,
  },
  dropdownTitleText: {
    fontSize: 17,
    paddingLeft: 7,
    color: colors.black,
    textTransform: 'capitalize'
  },
  conatiner: {
    bottom: 5
  },
  outlinedButtonText: {
    fontSize: Matrics.mvs(16),
    fontWeight: 'bold',
  },
  outlinedButton: {
    borderRadius: Matrics.mvs(16),
    width: '100%',
    // height: Matrics.vs(40)
  },
  measureContainer: {
    borderRadius: 10,
    borderWidth: 0.4,
    width: '50%',
    height: '98%',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 8,
  },
});
