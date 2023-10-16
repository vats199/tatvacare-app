import { StyleSheet, Text, View, TextInput } from 'react-native';
import React, { useEffect } from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { DietStackParamList } from '../../interface/Navigation.interface';
import RecentSearchDiet from '../../components/organisms/RecentSearchFood';
import DietSearchHeader from '../../components/molecules/DietSearchHeader';
import { colors } from '../../constants/colors';
import { StackScreenProps } from '@react-navigation/stack';
import Diet from '../../api/diet';
import { useApp } from '../../context/app.context';
import AsyncStorage from '@react-native-async-storage/async-storage';


type AddDietScreenProps = StackScreenProps<DietStackParamList, 'AddDiet'>
type SearcheFood = {
  FOOD_ID: number,
  ALIAS_NAME: string,
  CALORIES_CALCULATED_FOR: 100,
  food_name: string,
  Energy_kcal: number,
  food_item_id: number,
  unit_name: string,
  cal_unit_name: string,
  BASIC_UNIT_MEASURE: string,
  carbs: string,
  protein: string,
  fat: string,
  fiber: string,
  sodium: string,
  sugar: string,
  potassium: string,
  added_sugar: string,
  total_saturated_fatty_acids: string,
  total_monounsaturated_fatty_acids: string,
  total_polyunsaturated_fatty_acids: string
}
const AddDietScreen: React.FC<AddDietScreenProps> = ({ navigation, route }) => {
  const { userData } = useApp();
  const { optionId, healthCoachId } = route.params
  const [searchResult, setSearchResult] = React.useState([])
  const [recentSerach, setRecentSerach] = React.useState([])
  const [title, setTitle] = React.useState<string>('Search Result')


  useEffect(() => {
    const getRecentSerache = async () => {
      const recentSearchResults = await AsyncStorage.getItem('recentSearchResults');
      let updatedResults = recentSearchResults ? JSON.parse(recentSearchResults) : [];
      setRecentSerach(updatedResults)
      // console.log("updatedResults", updatedResults);
      // if (!searchResult) {
      //   setSearchResult(updatedResults)
      // }
    }
    getRecentSerache()
  }, [])

  const onPressBack = () => {
    navigation.goBack();
  };
  const handlePressPlus = async (data: SearcheFood) => {
    // setSelectedFoodItem(data)
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
      healthCoachId: healthCoachId
    }
    navigation.navigate('DietDetail', { foodItem: FoodItems, buttonText: 'Add' })
    // const seletedItem = recentSerach
    // seletedItem.unshift(data);
    // setRecentSerach(seletedItem)
    // await AsyncStorage.setItem('recentSearchResults', JSON.stringify(recentSerach));
  };

  const handleSerach = async (text: string) => {
    const result = await Diet.searchFoodItem({ "food_name": text }, {}, { token: userData?.token },)
    setSearchResult(result?.data)
    console.log("result", result);

    // if (result.code === '0' || result.code === '2') {
    //   setSearchResult(recentSerach)
    //   setTitle('Recent Search')
    // } else {
    //   setSearchResult(result?.data)
    //   setTitle('Search Result')

    // }

  }

  return (
    <View style={styles.container}>
      <DietSearchHeader onPressBack={onPressBack} onSearch={handleSerach} />
      <RecentSearchDiet onPressPlus={handlePressPlus} searchData={searchResult} title={title} />
    </View>
  );
};

export default AddDietScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 15,
    backgroundColor: colors.lightGreyishBlue,
  },
});