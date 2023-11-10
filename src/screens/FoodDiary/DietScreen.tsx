import React, {
  useState,
  useEffect,
  useRef,
  createContext,
  useCallback,
} from 'react';
import {useFocusEffect, useIsFocused} from '@react-navigation/native';
import {
  FlatList,
  LayoutAnimation,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import CalorieConsumer from '../../components/molecules/CalorieConsumer';
import DietHeader from '../../components/molecules/DietHeader';
import DietTime, {
  FoodItems,
  MealsData,
} from '../../components/organisms/DietTime';
import {colors} from '../../constants/colors';
import {DietStackParamList} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import Diet from '../../api/diet';
import {useApp} from '../../context/app.context';
import moment from 'moment';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
import {Constants, Matrics, Fonts} from '../../constants';
import Loader from '../../components/atoms/Loader';
import BasicModal from '../../components/atoms/BasicModal';
// import MyStatusbar from '../../components/atoms/MyStatusBar';
import {useToast} from 'react-native-toast-notifications';
import {globalStyles} from '../../constants/globalStyles';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import AlertBottomSheet from '../../components/organisms/AlertBottomSheet';
import {BottomSheetModal} from '@gorhom/bottom-sheet';
import {trackEvent} from '../../helpers/TrackEvent';
import mealTypes from '../../constants/data';
import MealCard from '../../components/molecules/MealCard';
import {useDiet} from '../../context/diet.context';
import {CalendarProvider, DateData} from 'react-native-calendars';
import MyStatusbar from '../../components/atoms/MyStatusBar';

type DietScreenProps = StackScreenProps<DietStackParamList, 'DietScreen'>;

type mealTYpe = {
  meal_types_id: string;
  value: string;
  meal_type: string;
  label: string;
  keys: string;
  default_time: string;
  order_no: number;
};

const DietScreen: React.FC<DietScreenProps> = ({navigation, route}) => {
  const insets = useSafeAreaInsets();
  const {
    resetData,
    selectedOptionsId,
    dietPlanDataAssign,
    resetCalories,
    totalCalories,
    totalConsumedCalories,
  } = useDiet();
  const toast = useToast();
  const [loader, setLoader] = useState<boolean>(false);
  const [dietPlane, setDiePlane] = useState<any>([]);
  const {userData} = useApp();
  const [deletpayload, setDeletpayload] = useState<string | null>(null);
  const [modalVisible, setModalVisible] = React.useState<boolean>(false);
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);
  const deleteItemRef = useRef<{
    deleteFoodItemId: string;
    is_food_item_added_by_patient: string;
    optionId: string;
    data: FoodItems;
    mealId: string;
  } | null>();
  const focus = useIsFocused();
  const _selectedDateRef = useRef<Date | null>(new Date());
  const options = route?.params?.option;

  // const [selectedDate, setSelectedDate] = useState<string | Date>(new Date());
  const [tempSelectedDate, setTempSelectedDate] = useState<string | Date>(
    new Date(),
  );
  // const [newMonth, setNewMonth] = useState<string | Date>(
  //   moment(tempSelectedDate).format('YYYY-MM-DD'),
  // );

  useEffect(() => {
    console.log('focus:', focus);
    if (focus) {
      getData();
    } else {
      selectedOptionsId.current = [];
      deleteItemRef.current = null;
      setDiePlane([]);
    }
  }, [focus]);

  const getData = async (optionId?: string, dietPlanId?: string) => {
    setLoader(true);
    const date = moment(_selectedDateRef?.current ?? new Date()).format(
      'YYYY-MM-DD',
    );
    const diet = await Diet.getDietPlan(
      {date: date},
      {},
      {token: userData.token},
    );
    if (Constants.IS_CHECK_API_CODE) {
      if (diet.code == '1') {
        setTimeout(() => {
          setLoader(false);
        }, 500);
        setDiePlane(diet?.data?.[0]);
        dietPlanDataAssign(diet?.data?.[0]);
      } else {
        setDiePlane([]);
        setLoader(false);
        resetCalories();
      }
    } else {
      if (Object.keys(diet).length > 0) {
        setTimeout(() => {
          setLoader(false);
        }, 500);
        setDiePlane(diet?.data?.[0]);
        dietPlanDataAssign(diet?.data?.[0]);
      } else {
        setDiePlane([]);
        setLoader(false);
        resetCalories();
      }
    }
  };

  const onPressBack = () => {
    navigation.goBack();
  };

  const handleDate = (date: any) => {
    navigation.setParams({option: undefined});
    // setSelectedDate(date);
    setTempSelectedDate(date);
    _selectedDateRef.current = date;
    getData();
  };

  const handaleEdit = (data: any, mealName: string) => {
    const tempOption = [...selectedOptionsId.current];
    navigation.navigate('DietDetail', {
      foodItem: data,
      buttonText: 'Update',
      healthCoachId: dietPlane?.health_coach_id,
      mealName: mealName,
      patient_id: dietPlane?.patient_id,
      option: tempOption,
      toDietScreen: true,
    });
  };

  const handaleDelete = (
    id: string,
    is_food_item_added_by_patient: string,
    optionId: string,
    data: FoodItems,
    mealId: string,
  ) => {
    if (is_food_item_added_by_patient === 'Y') {
      setDeletpayload(id);
      const param = {
        deleteFoodItemId: id,
        is_food_item_added_by_patient: is_food_item_added_by_patient,
        optionId: optionId,
        data: data,
        mealId: mealId,
      };
      deleteItemRef.current = param;
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
    console.log('yessss');
    // setModalVisible(false);
    bottomSheetModalRef.current?.close();
    const deleteFoodItem = await Diet.deleteFoodItem(
      {
        patient_id: dietPlane?.patient_id,
        health_coach_id: dietPlane?.health_coach_id,
        diet_plan_food_item_id: deletpayload,
      },
      {},
      {token: userData.token},
    );
    if (Constants.IS_CHECK_API_CODE) {
      if (deleteFoodItem?.code === '1') {
        getData();
        deleteItemRef.current = null;
        setTimeout(() => {
          bottomSheetModalRef.current?.close();
        }, 1000);
      }
    } else {
      if (deleteFoodItem?.data) {
        getData();
        deleteItemRef.current = null;
        setTimeout(() => {
          bottomSheetModalRef.current?.close();
        }, 1000);
      }
    }
  };

  const handlePulsIconPress = async (
    optionFoodItems: any,
    mealName: string,
  ) => {
    const tempOption = [...selectedOptionsId.current];
    navigation.navigate('AddDiet', {
      optionFoodItems: optionFoodItems,
      healthCoachId: dietPlane?.health_coach_id,
      mealName: mealName,
      patient_id: dietPlane?.patient_id,
      mealData: null,
      option: tempOption,
    });
  };

  const handalecompletion = async (
    item: any,
    optionId: string,
    dietPlanId: string,
  ) => {
    const UpadteFoodItem = await Diet.updateFoodConsumption(
      item,
      {},
      {token: userData.token},
    );
    getData(optionId, dietPlanId);
    if (UpadteFoodItem) {
    }
  };

  const handelOnpressOfprogressBar = () => {
    let vale = Math.round((totalConsumedCalories / totalCalories) * 100);
    if (isNaN(vale)) {
      vale = 0;
    }
    let tempCaloriesArray: any[] = [];
    dietPlane?.meals?.map((meal, index) => {
      meal.options.map(item => {
        item?.food_items?.length !== 0 &&
          selectedOptionsId.current.map(q => {
            if (
              q.mealId == item.diet_meal_type_rel_id &&
              q.optionId == item.diet_meal_options_id
            ) {
              const tempItem = {
                meal_name: meal?.meal_name,
                ...item,
              };
              tempCaloriesArray.push(tempItem);
            }
          });
      });
    });

    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CLICKS_ON_INSIGHT, {
      date_of_insight: moment(_selectedDateRef.current).format(
        Constants.DATE_FORMAT,
      ),
      goal_value: totalCalories,
      actual_value: totalConsumedCalories,
      percentage_completion: vale,
      goal_unit: 'cal',
    });
    const tempOption = [...selectedOptionsId.current];
    navigation.navigate('ProgressBarInsightsScreen', {
      calories: tempCaloriesArray,
      currentSelectedDate:
        _selectedDateRef.current != null
          ? new Date(_selectedDateRef.current)
          : new Date(),
      option: tempOption,
    });
  };

  const handlePressOfNoPlanePlusIcon = (mealData: mealTYpe) => {
    const today = new Date();
    if (
      moment(new Date(_selectedDateRef.current ?? new Date())).format(
        'YYYY-MM-DD',
      ) >= moment(today).format('YYYY-MM-DD')
    ) {
      const tempOption = [...selectedOptionsId.current];
      navigation.navigate('AddDiet', {
        healthCoachId: dietPlane?.health_coach_id,
        mealName: mealData?.label,
        mealData: mealData,
        selectedDate: _selectedDateRef.current,
        patient_id: dietPlane?.patient_id,
        option: tempOption,
      });
    } else {
      toast.show("Food item can't be added in past date meals", {
        type: 'normal',
        placement: 'bottom',
        duration: 2000,
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
      });
    }
  };

  // const onChangeMonth = (date: DateData) => {
  //   let tempDate = new Date(date?.dateString);
  //   setNewMonth(tempDate);
  // };

  // const onDateChanged = useCallback((date: any, updateSource: any) => {
  //   let tempDate = new Date(date);
  //   setNewMonth(tempDate);
  //   console.log('tempDate', tempDate);
  // }, []);

  return (
    <SafeAreaView
      edges={['top']}
      style={[
        styles.mainContienr,
        {
          paddingTop: Platform.OS == 'android' ? Matrics.vs(10) : 0,
        },
      ]}>
      <MyStatusbar backgroundColor={colors.lightGreyishBlue} />
      <CalendarProvider
        date={moment(tempSelectedDate).format('YYYY-MM-DD')}
        disabledOpacity={0.6}
        // onMonthChange={onChangeMonth}
        // onDateChanged={onDateChanged}
      >
        <DietHeader
          onPressBack={onPressBack}
          onPressOfNextAndPerviousDate={handleDate}
          title="Diet"
          selectedDate={tempSelectedDate}
          // newMonth={newMonth}
          onChangeDate={date => {
            setTempSelectedDate(date);
            // setNewMonth(date);
          }}
        />
        <View style={styles.belowContainer}>
          <TouchableOpacity
            activeOpacity={0.5}
            style={[styles.caloriesContainer, globalStyles.shadowContainer]}
            onPress={handelOnpressOfprogressBar}>
            <CalorieConsumer />
          </TouchableOpacity>
          {Object.keys(dietPlane).length > 0 ? (
            <DietTime
              onPressPlus={handlePulsIconPress}
              dietPlane={JSON.parse(JSON.stringify(dietPlane?.meals))}
              onpressOfEdit={handaleEdit}
              onPressOfDelete={handaleDelete}
              onPressOfcomplete={handalecompletion}
              options={options}
            />
          ) : loader ? null : (
            <FlatList
              style={[styles.innercontainer]}
              contentContainerStyle={{
                paddingBottom: insets.bottom + Matrics.vs(10),
              }}
              showsVerticalScrollIndicator={false}
              data={mealTypes}
              keyExtractor={(item, index) => index.toString()}
              renderItem={({item, index}: {item: mealTYpe; index: number}) => {
                return (
                  <MealCard
                    cardData={item}
                    onPressPlus={handlePressOfNoPlanePlusIcon}
                  />
                );
              }}
            />
          )}
        </View>
      </CalendarProvider>
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
  mainContienr: {flex: 1, backgroundColor: colors.lightGreyishBlue},
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
  innercontainer: {
    flex: 1,
    paddingHorizontal: Matrics.s(15),
    marginTop: Matrics.vs(5),
  },
});

export default DietScreen;
