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
import moment = require('moment');
// import MyStatusbar from '../../components/atoms/MyStatusBar';

type DietDetailProps = StackScreenProps<DietStackParamList, 'DietDetail'>;

const DietDetailScreen: React.FC<DietDetailProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets();
  const { foodItem, buttonText, healthCoachId, mealName } = route.params;
  let quantity = Math.round(Number(foodItem?.quantity)).toString();
  const [qty, setQty] = React.useState<string>(quantity);
  const { userData } = useApp();

  const onPressBack = () => {
    navigation.goBack();
  };

  const onPressAdd = async () => {
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_ADDED_QUANTITY, {
      meal_types: route?.params?.mealName,
      date: moment().format(Constants.DATE_FORMAT),
      food_item_name: foodItem?.food_item_name ?? ""
    })

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
      const result = await Deit?.addFoodItem(
        addPayload,
        {},
      );
      console.log(' added ', result);

      if (result) {
        navigation.popToTop();
      }
    } else {
      const result = await Deit?.updateFoodItem(
        updatePayload,
        {}
      );
      if (result) {
        navigation.popToTop();
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
        paddingTop: Platform.OS == 'android' ? insets.top + Matrics.vs(20) : 0,
        paddingBottom:
          insets.bottom !== 0 && Platform.OS == 'android' ? insets.bottom : 0,
      }}>
      {/* <MyStatusbar backgroundColor={colors.lightGreyishBlue} /> */}
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
