import { ScrollView, StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import RecentDietItem from '../molecules/RecentFoodItem';
import { Icons } from '../../constants/icons';
import { TouchableOpacity } from 'react-native';
import { Matrics } from '../../constants';
import { log } from 'console';

type RecentSerachDietProps = {
  onPressPlus: (data: SearcheFood) => void;
  searchData: SearcheFood[];
  title: string;
  message: string
};
// type data = {
//   code: string,
//   data: SearcheFood[];
// }
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
};
const RecentSearchDiet: React.FC<RecentSerachDietProps> = ({
  onPressPlus,
  searchData,
  title, message
}) => {
  const renderRecentSearchItem = (item: SearcheFood, index: number) => {


    return (
      <TouchableOpacity
        style={styles.container}
        onPress={() => onPressPlus(item)}>
        <View style={{ flex: 0.78 }}>
          <Text style={styles.titleText}>{item?.food_name}</Text>
          <Text style={styles.messageText}>{' Quantity| Micronutrients'}</Text>
        </View>
        <View style={styles.leftContainer}>
          <View style={{ flex: 0.7 }}>
            <Text style={styles.calorieText}>
              {item?.CALORIES_CALCULATED_FOR}cal
            </Text>
          </View>
          <View style={{ flex: 0.3, }}>
            <Icons.AddCircle height={25} width={25} />
          </View>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <ScrollView showsVerticalScrollIndicator={false}>
      <Text style={styles.text}>{title}</Text>
      {searchData?.length ? (
        searchData?.map(renderRecentSearchItem)
      ) : (
        <View>
          <Text style={{ textTransform: 'capitalize' }}>{message}</Text>
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
    marginHorizontal: 2,
  },
  titleText: {
    fontSize: 17,
    // fontWeight: 'bold',
    color: colors.labelDarkGray,
    padding: 5,
    textTransform: 'capitalize',
  },
  messageText: {
    fontSize: 13,
  },
  calorieText: {
    fontSize: 15,
    color: colors.labelDarkGray,
    marginRight: 10,
  },
  leftContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    flex: 0.22,

  },
});
