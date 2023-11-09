import { Platform, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { DietStackParamList } from '../../interface/Navigation.interface';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import MicronutrientsInformation from '../../components/organisms/MicronutrientsInformation';
import AddDiet from '../../components/organisms/AddDiet';
import { StackScreenProps } from '@react-navigation/stack';
import Deit from '../../api/diet';
import { useApp } from '../../context/app.context';
import { Constants, Fonts, Matrics } from '../../constants';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { trackEvent } from '../../helpers/TrackEvent';
import mealTypes from '../../constants/data';
import moment from 'moment';
import { number } from 'yup';
import Diet from '../../api/diet';
import { useDiet } from '../../context/diet.context';
import MyStatusbar from '../../components/atoms/MyStatusBar';
// import MyStatusbar from '../../components/atoms/MyStatusBar';

type DietDetailProps = StackScreenProps<DietStackParamList, 'DietDetail'>;

const DietDetailScreen: React.FC<DietDetailProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets();
  const {
    foodItem,
    buttonText,
    healthCoachId,
    mealName,
    mealData,
    selectedDate,
    option,
  } = route.params;
  let quantity = Math.round(Number(foodItem?.quantity)).toString();
  const [qty, setQty] = React.useState<string>(quantity);
  const { userData } = useApp();

  const onPressBack = () => {
    if (Array.isArray(option) && option.length !== 0) {
      navigation.navigate('DietScreen', {
        option: option,
      });
    } else {
      navigation.goBack();
    }
  };

  const onPressAdd = async () => {
    if (mealData) {
      const filterData = mealTypes.map(item => {
        const fatyAcid =
          Number(foodItem?.monounsaturated_fatty_acids.replace('g', '')) +
          Number(foodItem?.polyunsaturated_fatty_acids.replace('g', '')) +
          Number(foodItem?.saturated_fatty_acids.replace('g', ''));
        const [hours, minutes, seconds] = item?.default_time
          .split(':')
          .map(Number);
        const date = new Date();
        date.setHours(hours + 1, minutes, seconds);
        const updatedHour = String(date?.getHours())?.padStart(2, '0');
        const updatedMinutes = String(date?.getMinutes())?.padStart(2, '0');
        const updatedSeconds = String(date?.getSeconds())?.padStart(2, '0');
        const updatedTime = `${updatedHour}:${updatedMinutes}:${updatedSeconds}`;

        if (item?.meal_types_id === mealData?.meal_types_id) {
          return {
            meal_types_id: mealData?.meal_types_id,
            meal_name: mealData?.label,
            order_no: mealData?.order_no,
            start_time: mealData?.default_time,
            end_time: updatedTime,
            patient_permission: 'R',
            options: [
              {
                options_name: 'Option 1',
                order_no: mealData?.order_no,
                food_items: [
                  {
                    measure_name: 'serving',
                    food_item_id: foodItem?.food_item_id,
                    food_item_name: foodItem?.food_item_name,
                    protein: foodItem?.protein,
                    carbs: foodItem?.carbs?.replace('g', ''),
                    fats: foodItem?.fats.replace('g', ''),
                    fibers: foodItem?.fibers?.replace('g', ''),
                    sodium: foodItem?.sodium
                      ?.replace('g', '')
                      ?.replace('m', ''),
                    quantity: qty,
                    fatty_acids: fatyAcid?.toFixed(2).toString(),
                    sugar: foodItem?.sugar?.replace('g', ''),
                    calories: foodItem?.calories?.replace('g', ''),
                    potassium: foodItem?.potassium
                      ?.replace('g', '')
                      ?.replace('m', ''),
                    is_food_item_added_by_patient: 'Y',
                  },
                ],
                total_carbs: (
                  Number(qty) * Number(foodItem?.carbs?.replace('g', ''))
                )?.toString(),
                total_calories: (
                  Number(qty) * Number(foodItem?.calories?.replace('g', ''))
                )?.toString(),
                total_proteins: (
                  Number(qty) * Number(foodItem?.protein?.replace('g', ''))
                )?.toString(),
                total_fats: (
                  Number(qty) * Number(foodItem?.fats?.replace('g', ''))
                )?.toString(),
                total_fibers: (
                  Number(qty) * Number(foodItem?.fibers?.replace('g', ''))
                )?.toString(),
                total_sodium: (
                  Number(qty) *
                  Number(foodItem?.sodium?.replace('g', '')?.replace('m', ''))
                )?.toString(),
                total_potassium: (
                  Number(qty) *
                  Number(foodItem?.potassium?.replace('g', '').replace('m', ''))
                )?.toString(),
                total_fatty_acids: (Number(qty) * fatyAcid)
                  ?.toFixed(2)
                  ?.toString(),
                total_sugar: (
                  Number(qty) * Number(foodItem?.sugar?.replace('g', ''))
                )?.toString(),
              },
            ],
            is_hidden: 'N',
          };
        } else {
          return {
            meal_types_id: item?.meal_types_id,
            meal_name: item?.label,
            order_no: item?.order_no,
            start_time: item?.default_time,
            end_time: updatedTime,
            patient_permission: 'R',
            options: [
              {
                options_name: 'Option 1',
                order_no: item?.order_no,
                food_items: [],
                total_carbs: '0',
                total_calories: '0',
                total_proteins: '0',
                total_fats: '0',
                total_fibers: '0',
                total_sodium: '0',
                total_potassium: '0',
                total_fatty_acids: '0',
                total_sugar: '0',
              },
            ],
            is_hidden: 'N',
          };
        }
      });
      const noPlanPayload = {
        start_date: moment(selectedDate).format('YYYY-MM-DD'),
        status: 'Published',
        health_coach_id: '',
        meals: filterData,
        end_date: moment(selectedDate).format('YYYY-MM-DD'),
      };
      const result = await Deit?.noDietPlanCreate(noPlanPayload, {}, { token: userData.token });

      if (Constants.IS_CHECK_API_CODE) {
        if (result?.code === '1') {
          navigation.navigate('DietScreen', {
            option: option,
          });
        }
      } else {
        if (result) {
          navigation.navigate('DietScreen', {
            option: option,
          });
        }
      }
    } else {
      const addPayload = {
        patient_id: userData?.patient_id,
        food_item_id: foodItem?.food_item_id,
        food_item_name: foodItem?.food_item_name,
        quantity: qty,
        measure_id: foodItem?.measure_id,
        measure_name: foodItem?.measure_name,
        protein: foodItem?.protein,
        carbs: foodItem?.carbs,
        calories: foodItem?.calories,
        fats: foodItem?.fats,
        fibers: foodItem?.fibers,
        sodium: foodItem?.sodium,
        potassium: foodItem?.potassium,
        sugar: foodItem?.sugar,
        fatty_acids: foodItem?.fatty_acids,
        saturated_fatty_acids: foodItem?.saturated_fatty_acids,
        monounsaturated_fatty_acids: foodItem?.monounsaturated_fatty_acids,
        polyunsaturated_fatty_acids: foodItem?.polyunsaturated_fatty_acids,
        diet_meal_options_id: foodItem?.diet_meal_options_id,
        health_coach_id: foodItem?.healthCoachId,
        is_food_item_added_by_patient: 'Y',
      };
      const updatePayload = {
        patient_id: userData?.patient_id,
        food_item_id: foodItem?.food_item_id,
        food_item_name: foodItem?.food_item_name,
        quantity: qty,
        measure_id: foodItem?.measure_id,
        measure_name: foodItem?.measure_name,
        protein: foodItem?.protein,
        carbs: foodItem?.carbs,
        calories: foodItem?.calories,
        fats: foodItem?.fats,
        fibers: foodItem?.fibers,
        sodium: foodItem?.sodium,
        potassium: foodItem?.potassium,
        sugar: foodItem?.sugar,
        fatty_acids: foodItem?.fatty_acids,
        saturated_fatty_acids: foodItem?.saturated_fatty_acids,
        monounsaturated_fatty_acids: foodItem?.monounsaturated_fatty_acids,
        polyunsaturated_fatty_acids: foodItem?.polyunsaturated_fatty_acids,
        diet_meal_options_id: foodItem?.diet_meal_options_id,
        health_coach_id: healthCoachId,
        diet_plan_food_item_id: foodItem?.diet_plan_food_item_id,
        is_food_item_added_by_patient: foodItem?.is_food_item_added_by_patient,
      };

      if (buttonText === 'Add') {
        const result = await Deit?.addFoodItem(addPayload, {}, { token: userData.token },);
        if (Constants.IS_CHECK_API_CODE) {
          if (result?.code === '1') {
            navigation.navigate('DietScreen', {
              option: option,
            });
          }
        } else {
          if (result) {
            navigation.navigate('DietScreen', {
              option: option,
            });
          }
        }
      } else {
        const result = await Deit?.updateFoodItem(updatePayload, {}, { token: userData.token },);
        if (Constants.IS_CHECK_API_CODE) {
          if (result?.code === '1') {
            if (result?.data) {
              if (foodItem?.is_consumed) {
                const payload = {
                  consumed_qty: qty,
                  diet_plan_id: foodItem?.consumption?.diet_plan_id,
                  diet_plan_food_item_id:
                    foodItem?.consumption?.diet_plan_food_item_id,
                  date: foodItem?.consumption?.date,
                  diet_plan_food_consumption_id:
                    foodItem?.consumption?.diet_plan_food_consumption_id,
                };

                const UpadteFoodItem = await Diet?.updateFoodConsumption(
                  payload,
                  {}, { token: userData.token },
                );
                if (Constants.IS_CHECK_API_CODE) {
                  if (UpadteFoodItem.code == '1') {
                    if (UpadteFoodItem) {
                      navigation.navigate('DietScreen', {
                        option: option,
                      });
                    }
                  }
                } else {
                  if (UpadteFoodItem) {
                    navigation.navigate('DietScreen', {
                      option: option,
                    });
                  }
                }
              } else {
                navigation.navigate('DietScreen', {
                  option: option,
                });
              }
            }
          }
        } else {
          if (result) {
            if (foodItem?.is_consumed) {
              const payload = {
                consumed_qty: qty,
                diet_plan_id: foodItem?.consumption?.diet_plan_id,
                diet_plan_food_item_id:
                  foodItem?.consumption?.diet_plan_food_item_id,
                date: foodItem?.consumption?.date,
                diet_plan_food_consumption_id:
                  foodItem?.consumption?.diet_plan_food_consumption_id,
              };

              const UpadteFoodItem = await Diet?.updateFoodConsumption(
                payload,
                {}, { token: userData.token },
              );

              if (Constants.IS_CHECK_API_CODE) {
                if (UpadteFoodItem.code == '1') {
                  if (UpadteFoodItem) {
                    navigation.navigate('DietScreen', {
                      option: option,
                    });
                  }
                }
              } else {
                if (UpadteFoodItem) {
                  navigation.navigate('DietScreen', {
                    option: option,
                  });
                }
              }
            } else {
              navigation.navigate('DietScreen', {
                option: option,
              });
            }
          }
        }
      }
    }
  };
  const handleSeletedQty = (item: string) => {
    setQty(item);
  };
  return (
    <SafeAreaView
      edges={['top']}
      style={{
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        paddingTop: Platform.OS == 'android' ? Matrics.vs(10) : 0,
        // paddingBottom:
        //   insets.bottom !== 0 && Platform.OS == 'android' ? insets.bottom : 0,
      }}>
      <MyStatusbar backgroundColor={colors.lightGreyishBlue} />
      <View style={styles.header}>
        <TouchableOpacity hitSlop={8} onPress={onPressBack}>
          <Icons.backArrow height={20} width={20} />
        </TouchableOpacity>
        <Text style={styles.dietTitle}>{foodItem?.food_item_name}</Text>
      </View>
      <View style={styles.belowContainer}>
        <MicronutrientsInformation foodItemDetails={foodItem} />
        <AddDiet
          onPressAdd={onPressAdd}
          buttonText={buttonText}
          onSeleteQty={handleSeletedQty}
          Data={foodItem}
          mealName={mealName}
          isDisable={qty === '0' ? true : false}
        />
      </View>
    </SafeAreaView>
  );
};

export default DietDetailScreen;

const styles = StyleSheet.create({
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: Matrics.vs(20),
    marginLeft: 15,
  },
  dietTitle: {
    fontSize: Matrics.mvs(16),
    color: colors.labelDarkGray,
    fontFamily: Fonts.MEDIUM,
    marginLeft: Matrics.s(12),
  },
  belowContainer: {
    flex: 1,
    justifyContent: 'space-between',
  },
});
