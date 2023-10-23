import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { DietStackParamList } from '../../interface/Navigation.interface';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import MicronutrientsInformation from '../../components/organisms/MicronutrientsInformation';
import AddDiet from '../../components/organisms/AddDiet';
import { StackScreenProps } from '@react-navigation/stack';
import Deit from '../../api/diet';
import { useApp } from '../../context/app.context';
import { Fonts, Matrics } from '../../constants';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';

type DietDetailProps = StackScreenProps<DietStackParamList, 'DietDetail'>;

const DietDetailScreen: React.FC<DietDetailProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets();
  const { foodItem, buttonText, healthCoachId, mealName } = route.params;

  const [qty, setQty] = React.useState<string>();
  const { userData } = useApp();

  const onPressBack = () => {
    navigation.goBack();
  };

  const onPressAdd = async () => {
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
    };

    if (buttonText === 'Add') {
      const result = await Deit?.addFoodItem(
        addPayload,
        {},
        { token: userData?.token },
      );

      if (result?.code === '1') {
        navigation.popToTop();
      }
    } else {
      const result = await Deit?.updateFoodItem(
        updatePayload,
        {},
        { token: userData?.token },
      );
      if (result?.code === '1') {
        navigation.popToTop();
      }
    }
  };

  const handleSeletedQty = (item: string) => {
    setQty(item);
  };
  return (
    <SafeAreaView edges={['top']} style={{ flex: 1, backgroundColor: colors.lightGreyishBlue, paddingTop: insets.top !== 0 ? 0 : Matrics.vs(15), paddingBottom: 0 !== 0 ? insets.bottom : Matrics.vs(15), }}>
      <View style={styles.header}>
        <Icons.backArrow onPress={onPressBack} height={23} width={23} />
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
    fontSize: 16,
    fontWeight: '700',
    color: colors.labelDarkGray,
    marginLeft: 10,
    fontFamily: Fonts.BOLD,
  },
  belowContainer: {
    flex: 1,
    justifyContent: 'space-between',
    marginBottom: 10,
  },
});