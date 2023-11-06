import {Platform, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import Button from '../atoms/Button';
import DropdownComponent from '../atoms/Dropdown';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import {Fonts, Matrics} from '../../constants';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {globalStyles} from '../../constants/globalStyles';

type AddDietProps = {
  onPressAdd: () => void;
  buttonText: string;
  onSeleteQty: (qty: string) => void;
  Data: FoodItems;
  mealName: string;
  isDisable: boolean;
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
};

const AddDiet: React.FC<AddDietProps> = ({
  onPressAdd,
  buttonText,
  onSeleteQty,
  Data,
  mealName,
  isDisable,
}) => {
  const insets = useSafeAreaInsets();

  const data = [
    {label: '1', value: '1'},
    {label: '2', value: '2'},
    {label: '3', value: '3'},
    {label: '4', value: '4'},
    {label: '5', value: '5'},
  ];
  const handleSelectedQty = (ietm: string) => {
    onSeleteQty(ietm);
  };
  const handleSelectedMeasures = (ietm: string) => {};

  return (
    <View
      style={[
        styles.container,
        globalStyles.shadowContainer,
        {paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(16)},
      ]}>
      <Text numberOfLines={2} style={styles.title}>
        {'Add ' + Data?.food_item_name + ' as ' + mealName}
      </Text>
      <View style={styles.borderline} />
      <View style={styles.belowBox}>
        <View style={styles.belowBoxContent}>
          {/* add bottom to upper view */}
          <View
            style={[
              styles.dropdownContainer,
              {
                paddingBottom: 0,
              },
            ]}>
            <DropdownComponent
              data={data}
              defaultValues={Math.round(Number(Data?.quantity)).toString()}
              dropdownStyle={{
                width: '48%',
                ...globalStyles.shadowContainer,
                borderRadius: Matrics.s(12),
                shadowOpacity: 0.08,
                height: Matrics.vs(44),
              }}
              placeholder="Quantity"
              placeholderStyle={styles.dropdownTitleText}
              selectedItem={handleSelectedQty}
              isDisable={false}
              containerStyle={styles.conatiner}
              selectedTextStyle={{
                fontFamily: Fonts.REGULAR,
                fontSize: Matrics.mvs(13),
                color: colors.subTitleLightGray,
              }}
            />
            <View
              style={[globalStyles.shadowContainer, styles.measureContainer]}>
              <Text
                style={[
                  styles.dropdownTitleText,
                  {color: colors.subTitleLightGray},
                ]}>
                {Data?.measure_name}
              </Text>
              {/* <Icons.DropdownIcon /> */}
            </View>
          </View>
          <Button
            title={buttonText}
            titleStyle={styles.outlinedButtonText}
            buttonStyle={styles.outlinedButton}
            onPress={onPressAdd}
            disabled={isDisable}
          />
        </View>
      </View>
    </View>
  );
};

export default AddDiet;

const styles = StyleSheet.create({
  container: {
    borderTopRightRadius: 20,
    borderTopLeftRadius: 20,
    elevation: 3,
    shadowColor: colors.shadow,
    shadowRadius: 5,
    shadowOpacity: 1,
    shadowOffset: {height: 0, width: 0},
    backgroundColor: 'white',
  },
  title: {
    marginVertical: Matrics.vs(15),
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.BOLD,
    color: colors.labelDarkGray,
    paddingHorizontal: Matrics.s(15),
    lineHeight: 26,
  },
  borderline: {
    height: Matrics.mvs(1),
    backgroundColor: colors.seprator,
  },
  belowBox: {
    paddingHorizontal: Matrics.s(15),
  },
  belowBoxContent: {
    width: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  dropdownContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: Matrics.vs(20),
    width: '100%',
    justifyContent: 'space-between',
  },
  dropdownTitleText: {
    fontSize: Matrics.mvs(13),
    fontFamily: Fonts.REGULAR,
    color: colors.subTitleLightGray,
    textTransform: 'capitalize',
  },
  conatiner: {
    bottom: 5,
  },
  outlinedButtonText: {
    fontSize: Matrics.mvs(15),
    fontFamily: Fonts.BOLD,
    color: colors.white,
    lineHeight: 20,
  },
  outlinedButton: {
    width: '100%',
  },
  measureContainer: {
    width: '48%',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    shadowOpacity: 0.08,
    height: Matrics.vs(44),
    borderColor: colors.inputBoxLightBorder,
    borderWidth: Matrics.s(1),
    borderRadius: Matrics.mvs(12),
    paddingHorizontal: Matrics.s(12),
    backgroundColor: colors.white,
  },
});
