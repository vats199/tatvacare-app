import {ScrollView, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import {TouchableOpacity} from 'react-native';
import Matrics from '../../constants/Matrics';

type RecentSerachDietProps = {
  onPressPlus: (data: SearcheFood) => void;
  searchData: SearcheFood[];
  title: string;
};
type SearcheFood = {
  FOOD_ID: number;
  ALIAS_NAME: string;
  CALORIES_CALCULATED_FOR: 100;
  food_name: string;
  Energy_kcal: number;
  food_item_id: number;
  unit_name: string;
  cal_unit_name: string;
  BASIC_UNIT_MEASURE: string;
  carbs: string;
  protein: string;
  fat: string;
  fiber: string;
  sodium: string;
  sugar: string;
  potassium: string;
  added_sugar: string;
  total_saturated_fatty_acids: string;
  total_monounsaturated_fatty_acids: string;
  total_polyunsaturated_fatty_acids: string;
  total_macronutrients: number;
  total_micronutrients: number;
};
const RecentSearchDiet: React.FC<RecentSerachDietProps> = ({
  onPressPlus,
  searchData,
  title,
}) => {
  const renderRecentSearchItem = (item: SearcheFood, index: number) => {
    return (
      <TouchableOpacity
        style={styles.container}
        onPress={() => onPressPlus(item)}>
        <View style={{flex: 0.78}}>
          <Text style={styles.titleText}>{item?.food_name}</Text>
          <Text style={styles.messageText}>
            {'  ' +
              (Math.round(Number(item.total_micronutrients))
                ? Math.round(Number(item.total_micronutrients))
                : 0) +
              ' g'}
          </Text>
        </View>
        <View style={styles.leftContainer}>
          <Text style={styles.calorieText}>
            {item?.CALORIES_CALCULATED_FOR}cal
          </Text>
          <Icons.AddCircle height={24} width={24} />
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <ScrollView showsVerticalScrollIndicator={false}>
      <Text style={styles.text}>{title}</Text>
      {searchData?.length > 0 ? (
        searchData?.map(renderRecentSearchItem)
      ) : (
        <View>
          <Text style={{textTransform: 'capitalize'}}>
            sorry but no such food item found in our database please try with
            some other keyword
          </Text>
        </View>
      )}
    </ScrollView>
  );
};

export default RecentSearchDiet;

const styles = StyleSheet.create({
  text: {
    fontSize: Matrics.mvs(14),
    fontWeight: 'bold',
    color: colors.black,
    marginBottom: 5,
  },
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 6,
  },
  titleText: {
    fontSize: Matrics.mvs(14),
    // fontWeight: 'bold',
    color: colors.labelDarkGray,
    padding: 5,
    textTransform: 'capitalize',
  },
  messageText: {
    fontSize: Matrics.mvs(13),
  },
  calorieText: {
    fontSize: Matrics.mvs(14),
    color: colors.labelDarkGray,
    marginRight: 10,
  },
  leftContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    flex: 0.22,
  },
});
