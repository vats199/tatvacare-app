import React, { useState, useEffect } from 'react';
import { CompositeScreenProps, useFocusEffect } from '@react-navigation/native';
import { ActivityIndicator, Modal, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';

import CalorieConsumer from '../../components/molecules/CalorieConsumer';
import DietHeader from '../../components/molecules/DietHeader';
import DietTime from '../../components/organisms/DietTime';
import { colors } from '../../constants/colors';
import { DietStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Diet from '../../api/diet';
import { useApp } from '../../context/app.context';
import moment from 'moment';
import Loader from '../../components/atoms/Loader';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import Matrics from '../../constants/Matrics';
import BasicModal from '../../components/atoms/BasicModal';
 
type DietScreenProps = StackScreenProps<DietStackParamList, 'DietScreen'>

const DietScreen: React.FC<DietScreenProps> = ({ navigation, route }) => {
  const title = route.params?.dietData;
  const [dietOption, setDietOption] = useState<boolean>(false);
  const [loader, setLoader] = useState<boolean>(false);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [dietPlane, setDiePlane] = useState<any>([]);
  // const { userData } = useApp();
  const [deletpayload, setDeletpayload] = useState<string | null>(null)
  const [modalVisible, setModalVisible] = React.useState<boolean>(false);
  const [stateOfAPIcall, setStateOfAPIcall] = React.useState<boolean>(false);
  const [caloriesArray, setCaloriesArray] = React.useState<any[]>([]);
  const [totalcalorie, setTotalcalories] = useState<number | null>(null)
  const [totalConsumedcalorie, setTotalConsumedcalories] = useState<number | null>(null)
  const insets = useSafeAreaInsets()

  useEffect(() => {
    getData();
    return () => setDiePlane([])
  }, [selectedDate, stateOfAPIcall]);

  useEffect(() => {
    if (title) {
      setDietOption(true);
    } else {
      setDietOption(false);
    }
  }, [title]);

  useEffect(() => {
    const totalcalories = caloriesArray.reduce((accumulator, currentValue) => {
      return accumulator + Number(currentValue?.total_calories);
    }, 0);
    setTotalcalories(totalcalories)
    const totalConsumedcalories = caloriesArray.reduce((accumulator, currentValue) => {
      return accumulator + Number(currentValue?.consumed_calories);
    }, 0);
    setTotalConsumedcalories(totalConsumedcalories)

  }, [caloriesArray]);

  useFocusEffect(
    React.useCallback(() => {
      getData()
      return () => setDiePlane([])
    }, [])
  );

  const getData = async () => {
    setDiePlane([])
    setLoader(true)
    const date = moment(selectedDate).format('YYYY/MM/DD');
    const diet = await Diet.getDietPlan({ date: date }, {});

    if (diet) {
      setLoader(false)
      setDiePlane(diet?.data[0]);
    } else {

      setDiePlane([]);
    }
  };

  const onPressBack = () => {
    navigation.goBack();
  };

  const handleDate = (date: any) => {
    setSelectedDate(date);
  };

  const handaleEdit = (data: any, mealName: string) => {
    navigation.navigate('DietDetail', { foodItem: data, buttonText: 'Update', healthCoachId: dietPlane?.health_coach_id, mealName: mealName, patient_id: dietPlane?.patient_id })
  };

  const handaleDelete = (id: string) => {
    setDeletpayload(id)
    setModalVisible(!modalVisible)
  };

  const deleteFoodItem = async () => {
    setStateOfAPIcall(true)
    const deleteFoodItem = await Diet.deleteFoodItem({ patient_id: dietPlane?.patient_id, health_coach_id: dietPlane?.health_coach_id, diet_plan_food_item_id: deletpayload, }, {});
    getData()
    if (deleteFoodItem?.data === true) {
      setStateOfAPIcall(false)
      navigation.replace('DietScreen')
      setTimeout(() => { setModalVisible(false) }, 1000)
    }
  }
  const handlePulsIconPress = async (optionId: string, mealName: string) => {
    navigation.navigate('AddDiet', { optionId: optionId, healthCoachId: dietPlane?.health_coach_id, mealName: mealName, patient_id: dietPlane?.patient_id, });
  }

  const handalecompletion = async (item: any) => {
    const UpadteFoodItem = await Diet.updateFoodConsumption(item, {});
    getData()
    if (UpadteFoodItem?.code === '1') {

    }
  }

  const handalTotalCalories = async (caloriesValue: any) => {
    setCaloriesArray(prevCalories => {
      const indexToUpdate = prevCalories.findIndex(item => item.diet_meal_type_rel_id === caloriesValue.diet_meal_type_rel_id);
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
    navigation.navigate("ProgressBarInsightsScreen", { calories: caloriesArray })
  }

  return (

    <SafeAreaView edges={['top']} style={{
      flex: 1, backgroundColor: colors.lightGreyishBlue,
      paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(15),
    }}>
      <DietHeader
        onPressBack={onPressBack}
        onPressOfNextAndPerviousDate={handleDate}
        title='Diet'
      />
      <View style={styles.belowContainer}>
        <TouchableOpacity onPress={handelOnpressOfprogressBar}>
          <CalorieConsumer totalConsumedcalories={totalConsumedcalorie} totalcalories={totalcalorie} />
        </TouchableOpacity>
        {Object.keys(dietPlane).length > 0 ? (
          <DietTime
            onPressPlus={handlePulsIconPress}
            dietOption={dietOption}
            dietPlane={dietPlane?.meals}
            onpressOfEdit={handaleEdit}
            onPressOfDelete={handaleDelete}
            onPressOfcomplete={handalecompletion}
            getCalories={handalTotalCalories}
          />
        ) : (
          <View style={styles.messageContainer}>
            <Text style={{ fontSize: 15 }}>{"No diet plan available"}</Text>
          </View>)}
      </View>
      <BasicModal
        modalVisible={modalVisible}
        messgae={
          'Are you sure you want to delete this food item from your meal'
        }
        NegativeButtonsText="Cancel"
        positiveButtonText="Ok"
        onPressOK={deleteFoodItem}
        onPressCancle={() => setModalVisible(!modalVisible)} />
      <Loader visible={loader} />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  belowContainer: {
    flex: 1,
    paddingHorizontal: 15,
    backgroundColor:colors.lightGreyishBlue,
  },
  messageContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 100
  },

  button: {
    borderRadius: 20,
    padding: 10,
    elevation: 2,
  },
  buttonClose: {
    backgroundColor: colors.darkGray,
    height: 18,
    width: 18,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 8,
    position: 'absolute',
    right: -7,
    top: -7,
  },

});

export default DietScreen;
