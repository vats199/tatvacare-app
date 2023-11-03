import React, { useState, useEffect, useRef } from 'react';
import { useFocusEffect } from '@react-navigation/native';
import { Platform, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import CalorieConsumer from '../../components/molecules/CalorieConsumer';
import DietHeader from '../../components/molecules/DietHeader';
import DietTime from '../../components/organisms/DietTime';
import { colors } from '../../constants/colors';
import { DietStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Diet from '../../api/diet';
import { useApp } from '../../context/app.context';
import moment from 'moment';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { Constants, Matrics, Fonts } from '../../constants';
import Loader from '../../components/atoms/Loader';
import BasicModal from '../../components/atoms/BasicModal';
// import MyStatusbar from '../../components/atoms/MyStatusBar';
import { useToast } from 'react-native-toast-notifications';
import { globalStyles } from '../../constants/globalStyles';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import AlertBottomSheet from '../../components/organisms/AlertBottomSheet';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import { trackEvent } from '../../helpers/TrackEvent'
type DietScreenProps = StackScreenProps<DietStackParamList, 'DietScreen'>;

const DietScreen: React.FC<DietScreenProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets();

  const toast = useToast();
  const title = route.params?.dietData;
  const [dietOption, setDietOption] = useState<boolean>(false);
  const [loader, setLoader] = useState<boolean>(false);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [dietPlane, setDiePlane] = useState<any>([]);
  const { userData } = useApp();
  const [deletpayload, setDeletpayload] = useState<string | null>(null);
  const [modalVisible, setModalVisible] = React.useState<boolean>(false);
  const [stateOfAPIcall, setStateOfAPIcall] = React.useState<boolean>(false);
  const [caloriesArray, setCaloriesArray] = React.useState<any[]>([]);
  const [totalcalorie, setTotalcalories] = useState<number | null>(null);
  const [totalConsumedcalorie, setTotalConsumedcalories] = useState<
    number | null
  >(null);
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);

  useEffect(() => {
    getData();
    return () => setDiePlane([]);
  }, [selectedDate, stateOfAPIcall]);

  useEffect(() => {
    if (title) {
      setDietOption(true);
    } else {
      setDietOption(false);
    }
  }, [title]);

  useEffect(() => {
    return () => setDiePlane([]);
  }, []);

  useEffect(() => {
    const totalcalories = caloriesArray?.reduce((accumulator, currentValue) => {
      return accumulator + Number(currentValue?.total_calories ?? 0);
    }, 0);
    setTotalcalories(totalcalories);
    const totalConsumedcalories = caloriesArray?.reduce(
      (accumulator, currentValue) => {
        return accumulator + Number(currentValue?.consumed_calories ?? 0);
      },
      0,
    );
    setTotalConsumedcalories(totalConsumedcalories);
  }, [caloriesArray]);

  useFocusEffect(
    React.useCallback(() => {
      getData();
      // empty list while leave screen
      // return () => setDiePlane([]);
    }, []),
  );

  const getData = async (optionId?: string, dietPlanId?: string) => {
    setLoader(true);
    const date = moment(selectedDate).format('YYYY/MM/DD');
    const diet = await Diet.getDietPlan({ date: date }, {});
    // console.log('diet', diet);
    if (Object.keys(diet).length > 0) {
      setTimeout(() => {
        setLoader(false);
      }, 500);
      setDiePlane(diet?.data?.[0]);
      if (optionId && dietPlanId)
        countCalories(optionId, dietPlanId, diet?.data?.[0]);
    } else {
      setDiePlane([]);
      setLoader(false);
      setTotalConsumedcalories(0);
      setTotalcalories(0);
    }
  };

  const onPressBack = () => {
    navigation.goBack();
  };

  const handleDate = (date: any) => {
    setSelectedDate(date);
  };

  const handaleEdit = (data: any, mealName: string) => {
    navigation.navigate('DietDetail', {
      foodItem: data,
      buttonText: 'Update',
      healthCoachId: dietPlane?.health_coach_id,
      mealName: mealName,
      patient_id: dietPlane?.patient_id,
    });
  };

  const handaleDelete = (id: string, is_food_item_added_by_patient: string) => {
    if (is_food_item_added_by_patient === 'Y') {
      setDeletpayload(id);
      // setModalVisible(!modalVisible);
      bottomSheetModalRef.current?.present();
    } else {
      toast.show(
        'Unfortunately, you can not delete this food item since it was recommended by your nutritionist.',
        {
          type: 'normal',
          placement: 'bottom',
          duration: 2500,
          animationType: 'slide-in',
          style: {
            borderRadius: Matrics.mvs(12),
            width: Matrics.screenWidth - 20,
          },
          textStyle: {
            fontSize: Matrics.mvs(13),
            fontFamily: Fonts.REGULAR,
            color: colors.white,
            lineHeight: 18,
          },
        },
      );
    }
  };

  const deleteFoodItem = async () => {
    // setModalVisible(false);
    bottomSheetModalRef.current?.close();
    const deleteFoodItem = await Diet.deleteFoodItem(
      {
        patient_id: dietPlane?.patient_id,
        health_coach_id: dietPlane?.health_coach_id,
        diet_plan_food_item_id: deletpayload,
      },
      {},
    );
    if (deleteFoodItem) {
      setStateOfAPIcall(false);
      getData();
      setTimeout(() => {
        bottomSheetModalRef.current?.close();
        // setModalVisible(false);
      }, 1000);
    }
  };
  const handlePulsIconPress = async (
    optionFoodItems: any,
    mealName: string,
  ) => {
    navigation.navigate('AddDiet', {
      optionFoodItems: optionFoodItems,
      healthCoachId: dietPlane?.health_coach_id,
      mealName: mealName,
      patient_id: dietPlane?.patient_id,
    });
  };

  const handalecompletion = async (
    item: any,
    optionId: string,
    dietPlanId: string,
  ) => {
    const UpadteFoodItem = await Diet.updateFoodConsumption(item, {});
    getData(optionId, dietPlanId);
    if (UpadteFoodItem) {
    }
  };

  const countCalories = (optionId: string, mealId: string, data: any) => {
    const dietPlanFound = data.meals.filter(
      (item: any) => item.meal_types_id == mealId,
    );
    if (dietPlanFound.length !== 0) {
      const itemOptionFound = dietPlanFound[0]?.options?.filter(
        (q: any) => q.diet_meal_options_id == optionId,
      );

      if (itemOptionFound.length > 0) {
        const mealName = dietPlanFound[0].meal_name;
        itemOptionFound[0].meal_name = mealName;
      }

      handalTotalCalories(itemOptionFound[0]);
    }
  };

  const handalTotalCalories = async (caloriesValue: any) => {
    setCaloriesArray(prevCalories => {
      const indexToUpdate = prevCalories.findIndex(
        item =>
          item.diet_meal_type_rel_id === caloriesValue.diet_meal_type_rel_id,
      );
      if (indexToUpdate !== -1) {
        const updatedCaloriesArray = [...prevCalories];
        updatedCaloriesArray[indexToUpdate] = caloriesValue;
        return updatedCaloriesArray;
      } else {
        return [...prevCalories, caloriesValue];
      }
    });
  };

  const handelOnpressOfprogressBar = () => {
    let vale = Math.round((totalConsumedcalorie / totalcalorie) * 100);
    if (isNaN(vale)) {
      vale = 0
    }
    console.log(caloriesArray, "caloriesArraycaloriesArray", JSON.stringify(userData))
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKS_ON_INSIGHT, {
      "date_of_insight": moment(selectedDate).format(Constants.DATE_FORMAT),
      "goal_value": totalcalorie,
      "actual_value": totalConsumedcalorie,
      "percentage_completion": vale,
      "goal_unit": "cal",
    })
    navigation.navigate('ProgressBarInsightsScreen', { calories: caloriesArray });
  };

  return (
    <SafeAreaView
      edges={['top']}
      style={[
        styles.mainContienr,
        {
          paddingTop:
            Platform.OS == 'android' ? insets.top + Matrics.vs(20) : 0,
        },
      ]}>
      {/* <MyStatusbar backgroundColor={colors.lightGreyishBlue} /> */}
      <DietHeader
        onPressBack={onPressBack}
        onPressOfNextAndPerviousDate={handleDate}
        title="Diet"
      />
      <View style={styles.belowContainer}>
        <TouchableOpacity
          activeOpacity={0.5}
          style={[styles.caloriesContainer, globalStyles.shadowContainer]}
          onPress={handelOnpressOfprogressBar}>
          <CalorieConsumer
            totalConsumedcalories={totalConsumedcalorie}
            totalcalories={totalcalorie}
          />
        </TouchableOpacity>
        {Object.keys(dietPlane ?? {}).length > 0 ? (
          <DietTime
            onPressPlus={handlePulsIconPress}
            dietOption={dietOption}
            dietPlane={JSON.parse(JSON.stringify(dietPlane?.meals))}
            onpressOfEdit={handaleEdit}
            onPressOfDelete={handaleDelete}
            onPressOfcomplete={handalecompletion}
            getCalories={handalTotalCalories}
          />
        ) : loader ? null : (
          <View style={styles.messageContainer}>
            <Text style={{ fontSize: 15 }}>{'No diet plan available'}</Text>
          </View>
        )}
      </View>
      <CommonBottomSheetModal snapPoints={['35%']} ref={bottomSheetModalRef}>
        <AlertBottomSheet
          onPressAccept={deleteFoodItem}
          onPressCancel={() => {
            bottomSheetModalRef.current?.dismiss();
          }}
          insets={insets}
          title={
            'Are you sure you want to delete this food item from your meal?'
          }
        />
      </CommonBottomSheetModal>
      <Loader visible={loader} />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  mainContienr: { flex: 1, backgroundColor: colors.lightGreyishBlue },
  belowContainer: {
    flex: 1,
    backgroundColor: colors.lightGreyishBlue,
  },
  messageContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: Matrics.vs(100),
  },
  button: {
    borderRadius: Matrics.mvs(20),
    padding: Matrics.mvs(10),
    elevation: 2,
  },
  buttonClose: {
    backgroundColor: colors.darkGray,
    height: Matrics.vs(18),
    width: Matrics.s(18),
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: Matrics.mvs(-7),
    position: 'absolute',
    right: Matrics.s(-7),
    top: Matrics.vs(-7),
  },
  caloriesContainer: {
    borderRadius: Matrics.mvs(12),
    marginTop: Matrics.vs(5),
    marginBottom: Matrics.vs(5),
    marginHorizontal: Matrics.s(15),
  },
});

export default DietScreen;
