import {ScrollView, StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import RecentDietItem from '../molecules/RecentFoodItem';
import {Icons} from '../../constants/icons';
import {TouchableOpacity} from 'react-native';
import {Fonts, Matrics} from '../../constants';
import {log} from 'console';

type RecentSerachDietProps = {
  onPressPlus: (data: SearcheFood) => void;
  searchData: SearcheFood[];
  title: string;
  message: string;
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
  total_macronutrients: number;
  total_micronutrients: number;
};
const RecentSearchDiet: React.FC<RecentSerachDietProps> = ({
  onPressPlus,
  searchData,
  title,
  message,
}) => {
  console.log('🚀 ~ file: RecentSearchFood.tsx:50 ~ message:', message);
  const renderRecentSearchItem = (item: SearcheFood, index: number) => {
    return (
      <TouchableOpacity
        style={styles.container}
        onPress={() => onPressPlus(item)}>
        <View
          style={{
            flex: 1,
          }}>
          <Text style={styles.titleText}>{item?.food_name}</Text>
          {/* <Text style={styles.messageText}>
            {'  ' +
              (Math.round(Number(item.total_micronutrients))
                ? Math.round(Number(item.total_micronutrients))
                : 0) +
              ' g'}
          </Text> */}
          <View style={{flexDirection: 'row', alignItems: 'center'}}>
            <Text style={[styles.messageText, {textTransform: 'capitalize'}]}>
              {'1' + ' ' + item.unit_name + '  | '}
            </Text>
            <Text style={[styles.messageText, {textTransform: 'lowercase'}]}>
              {Math.round(Number(item.total_micronutrients)) + ' g'}
            </Text>
          </View>
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
      {searchData?.length ? (
        searchData?.map(renderRecentSearchItem)
      ) : (
        <View>
          <Text
            style={{
              fontFamily: Fonts.REGULAR,
              color: colors.subTitleLightGray,
              marginHorizontal: Matrics.s(5),
            }}>
            Search meal not found!
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
    color: colors.labelDarkGray,
    fontFamily: Fonts.BOLD,
    marginBottom: 5,
    marginHorizontal: Matrics.s(5),
  },
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: Matrics.vs(5),
    marginHorizontal: Matrics.s(5),
  },
  titleText: {
    fontSize: Matrics.mvs(13),
    color: colors.labelDarkGray,
    textTransform: 'capitalize',
    fontFamily: Fonts.REGULAR,
    lineHeight: 18,
  },
  messageText: {
    fontSize: Matrics.mvs(12),
    color: colors.subTitleLightGray,
    fontFamily: Fonts.REGULAR,
    lineHeight: 16,
  },
  calorieText: {
    fontSize: Matrics.mvs(14),
    color: colors.subTitleLightGray,
    marginRight: Matrics.s(10),
    fontFamily: Fonts.REGULAR,
  },
  leftContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
});
