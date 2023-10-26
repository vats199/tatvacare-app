import {StyleSheet, Text, View, TextInput} from 'react-native';
import React, {useEffect} from 'react';
import {DietStackParamList} from '../../interface/Navigation.interface';
import RecentSearchDiet from '../../components/organisms/RecentSearchFood';
import DietSearchHeader from '../../components/molecules/DietSearchHeader';
import {colors} from '../../constants/colors';
import {StackScreenProps} from '@react-navigation/stack';
import Diet from '../../api/diet';
import {useApp} from '../../context/app.context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
import {Matrics} from '../../constants';
import {log} from 'console';

type AddDietScreenProps = StackScreenProps<DietStackParamList, 'AddDiet'>;
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
const AddDietScreen: React.FC<AddDietScreenProps> = ({navigation, route}) => {
  const insets = useSafeAreaInsets();
  const {userData} = useApp();
  const {optionId, healthCoachId, mealName} = route.params;
  const [recentSerach, setRecentSerach] = React.useState([]);
  const [searchResult, setSearchResult] = React.useState([]);
  const [result, setResult] = React.useState([]);
  const [title, setTitle] = React.useState<string>('');

  useEffect(() => {
    const getRecentSerache = async () => {
      const recentSearchResults = await AsyncStorage.getItem(
        'recentSearchResults',
      );
      let results = recentSearchResults ? JSON.parse(recentSearchResults) : [];

      const unique = results.filter((obj: any, index: number) => {
        return (
          index === results.findIndex((o: any) => obj.food_name === o.food_name)
        );
      });

      if (unique.length > 3) {
        const updatedResult = unique.slice(0, 4);
        setRecentSerach(updatedResult);
        setSearchResult(updatedResult);
      } else {
        setRecentSerach(unique);
        setSearchResult(unique);
      }
    };
    getRecentSerache();
  }, []);

  const onPressBack = () => {
    navigation.goBack();
  };
  const handlePressPlus = async (data: SearcheFood) => {
    const FoodItems = {
      diet_plan_food_item_id: 'null',
      diet_meal_options_id: optionId,
      food_item_id: data?.food_item_id,
      food_item_name: data?.food_name,
      quantity: null,
      measure_id: null,
      measure_name: data?.unit_name,
      protein: data?.protein,
      carbs: data?.carbs,
      fats: data?.fat,
      fibers: data?.fiber,
      calories: data?.CALORIES_CALCULATED_FOR,
      sodium: data?.sodium,
      potassium: data?.potassium,
      sugar: data?.sugar,
      saturated_fatty_acids: data?.total_saturated_fatty_acids,
      monounsaturated_fatty_acids: data?.total_monounsaturated_fatty_acids,
      polyunsaturated_fatty_acids: data?.total_polyunsaturated_fatty_acids,
      fatty_acids: data?.total_saturated_fatty_acids,
      is_active: null,
      is_deleted: null,
      updated_by: null,
      created_at: null,
      updated_at: null,
      consumption: null,
      is_consumed: null,
      consumed_calories: null,
      healthCoachId: healthCoachId,
    };
    navigation.navigate('DietDetail', {
      foodItem: FoodItems,
      buttonText: 'Add',
      mealName: mealName,
    });
    const seletedItem = recentSerach;
    seletedItem.unshift(data);
    setRecentSerach(seletedItem);
    await AsyncStorage.setItem(
      'recentSearchResults',
      JSON.stringify(recentSerach),
    );
  };

  const handleSerach = async (text: string) => {
    const result = await Diet.searchFoodItem(
      {food_name: text},
      {},
      {token: userData?.token},
    );
    setResult(result);
    setSearchResult(result?.data);
    if (result.code === '0' || text.length === 0) {
      setSearchResult(recentSerach);
      setTitle('Recent Search');
    } else if (result.code === '2') {
      setTitle('Search Result');
      setSearchResult([]);
    } else {
      setSearchResult(result?.data);
      setTitle('Search Result');
    }
  };

  return (
    <SafeAreaView
      edges={['top']}
      style={[
        styles.container,
        {
          paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(15),
        },
      ]}>
      <DietSearchHeader onPressBack={onPressBack} onSearch={handleSerach} />
      <RecentSearchDiet
        onPressPlus={handlePressPlus}
        searchData={result}
        title={title}
      />
    </SafeAreaView>
  );
};

export default AddDietScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: Matrics.s(15),
    backgroundColor: colors.lightGreyishBlue,
  },
});
