import {StyleSheet, Text, View, TextInput, Platform} from 'react-native';
import React, {useEffect} from 'react';
import {DietStackParamList} from '../../interface/Navigation.interface';
import RecentSearchDiet from '../../components/organisms/RecentSearchFood';
import DietSearchHeader from '../../components/molecules/DietSearchHeader';
import {colors} from '../../constants/colors';
import {StackScreenProps} from '@react-navigation/stack';
import Diet from '../../api/diet';
import {useApp} from '../../context/app.context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {Container, Screen} from '../../components/styled/Views';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
import Matrics from '../../constants/Matrics';
import {useFocusEffect} from '@react-navigation/native';
import {trackEvent} from '../../helpers/TrackEvent';
import {Constants} from '../../constants';
import moment = require('moment');
// import MyStatusbar from '../../components/atoms/MyStatusBar';

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
  const {
    optionFoodItems,
    healthCoachId,
    patient_id,
    mealName,
    mealData,
    selectedDate,
  } = route.params;
  const [recentSerach, setRecentSerach] = React.useState([]);
  const [searchResult, setSearchResult] = React.useState([]);
  const [message, setMessage] = React.useState('');
  const [result, setResult] = React.useState([]);
  const [title, setTitle] = React.useState<string>('');
  const [searchQuery, setSearchQuery] = React.useState('');
  const [timeoutId, setTimeoutId] = React.useState<number | undefined>(
    undefined,
  );
  const debouncingDelay = 500;

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

  useFocusEffect(
    React.useCallback(() => {
      if (recentSerach.length > 0) {
        setTitle('Recent Search');
      }
    }, [recentSerach]),
  );

  const onPressBack = () => {
    navigation.goBack();
  };
  const handlePressPlus = async (data: SearcheFood) => {
    const isFoodItemInList = optionFoodItems?.food_items.find(
      item => item.food_item_id === data?.food_item_id,
    );

    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_SEARCHED_FOOD_DISH, {
      meal_types: route?.params?.mealName,
      date: moment().format(Constants.DATE_FORMAT),
      food_item_name: isFoodItemInList?.food_item_name ?? '',
    });
    if (isFoodItemInList) {
      navigation.navigate('DietDetail', {
        foodItem: isFoodItemInList,
        buttonText: 'Update',
        healthCoachId: healthCoachId,
        mealName: mealName,
        patient_id: patient_id,
      });
    } else {
      const FoodItems = {
        diet_plan_food_item_id: 'null',
        diet_meal_options_id: optionFoodItems?.diet_meal_options_id,
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
        is_food_item_added_by_patient: 'Y',
      };

      if (mealData) {
        navigation.navigate('DietDetail', {
          foodItem: FoodItems,
          buttonText: 'Add',
          healthCoachId: healthCoachId,
          mealName: mealName,
          mealData: mealData,
          selectedDate: selectedDate,
        });
      } else {
        navigation.navigate('DietDetail', {
          foodItem: FoodItems,
          buttonText: 'Add',
          healthCoachId: healthCoachId,
          mealName: mealName,
          mealData: null,
          patient_id: patient_id,
        });
      }
    }

    const seletedItem = recentSerach;
    seletedItem.unshift(data);
    setRecentSerach(seletedItem);
    await AsyncStorage.setItem(
      'recentSearchResults',
      JSON.stringify(recentSerach),
    );
  };

  const handleSearch = (text: string) => {
    setSearchQuery(text);

    if (timeoutId) {
      clearTimeout(timeoutId);
    }

    const newTimeoutId = setTimeout(() => {
      const performSearch = async () => {
        trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_SEARCHED_FOOD_DISH, {
          meal_types: route?.params?.mealName,
          date: moment().format(Constants.DATE_FORMAT),
          food_item_name: text,
        });
        const result = await Diet.searchFoodItem(
          {food_name: text},
          {},
          {token: userData.token},
        );
        setResult(result);
        setSearchResult(result?.data);
        if (result?.data?.length > 0) {
          setSearchResult(result?.data);
          setTitle('Search Result');
          setMessage('');
        } else {
          if (text.length === 0) {
            setSearchResult(recentSerach);
            setTitle(recentSerach.length > 0 ? 'Recent Search' : '');
            setMessage('');
          } else {
            setTitle('Search Result');
            setSearchResult([]);
            setMessage('Searched meal not found!');
          }
        }
      };

      performSearch();
    }, debouncingDelay);

    setTimeoutId(newTimeoutId);
  };

  return (
    <SafeAreaView
      edges={['top']}
      style={[
        styles.container,
        {
          paddingTop:
            Platform.OS == 'android' ? insets.top + Matrics.vs(10) : 0,
          paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(15),
        },
      ]}>
      {/* <MyStatusbar backgroundColor={colors.lightGreyishBlue} /> */}
      <DietSearchHeader onPressBack={onPressBack} onSearch={handleSearch} />
      <RecentSearchDiet
        onPressPlus={handlePressPlus}
        searchData={searchResult}
        title={title}
        message={message}
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
