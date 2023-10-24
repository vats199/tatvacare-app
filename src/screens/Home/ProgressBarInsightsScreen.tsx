import { View, Text, StyleSheet, ScrollView } from 'react-native'
import React, { useEffect, useState } from 'react'
import { DietStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import DietHeader from '../../components/molecules/DietHeader';
import { colors } from '../../constants/colors';
import fonts from '../../constants/fonts';
import Matrics from '../../constants/Matrics';
import CircularProgress from 'react-native-circular-progress-indicator';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';

type ProgressBarInsightsScreenProps = StackScreenProps<DietStackParamList, 'ProgressBarInsightsScreen'>

const ProgressBarInsightsScreen: React.FC<ProgressBarInsightsScreenProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets();
  const [selectedDate, setSelectedDate] = React.useState(new Date());
  const { calories } = route.params
  const [dailyCalories, setDailyCalories] = useState([])
  const [macroNuitrientes, setMacroNuitrientes] = useState([])

  const onPressBack = () => {
    navigation.goBack();
  };
  const handleDate = (date: any) => {
    setSelectedDate(date);
  };


  useEffect(() => {
    const data = calories.map((item: any) => {
      let color = colors.progressBarGreen;

      switch (item?.meal_name) {
        case 'Breakfast':
          color = colors.progressBarGreen;
          break;
        case 'Dinner':
          color = colors.progressBarRed;
          break;
        case 'Snacks':
          color = colors.progressBarYellow;
          break;
        default:
          color = colors.progressBarGreen;
          break;
      }

      return {
        title: item?.meal_name,
        totalCalories: Math.round(Number(item.total_calories)),
        consumedClories: Math.round(Number(item.consumed_calories)),
        progressBarVale: Math.round((Math.round(Number(item.consumed_calories)) / Math.round(Number(item.total_calories))) * 100),
        progresBarColor: color
      };
    });
    setDailyCalories(data);
    const sum = calories.reduce((accumulator, currentItem) => {
      accumulator.consumed_protine += currentItem.consumed_protein;
      accumulator.total_proteins += Number(currentItem.total_proteins);
      accumulator.consumed_fiber += currentItem.consumed_fiber;
      accumulator.total_fibers += Number(currentItem.total_fibers);
      accumulator.consumed_carbs += currentItem.consumed_carbs;
      accumulator.total_carbs += Number(currentItem.total_carbs);
      accumulator.consumed_fat += currentItem.consumed_fat;
      accumulator.total_fats += Number(currentItem.total_fats);
      return accumulator;
    }, {
      consumed_protine: 0,
      total_proteins: 0,
      consumed_fiber: 0,
      total_fibers: 0,
      consumed_carbs: 0,
      total_carbs: 0,
      consumed_fat: 0,
      total_fats: 0,
    });

    const arry = [
      {
        title: 'protein',
        totalCalories: Math.round(Number(sum.total_proteins)),
        consumedClories: Math.round(Number(sum.consumed_protine)),
        progressBarVale: Math.round((Number(sum.consumed_protine) / Number(sum.total_proteins) * 100)),
        progresBarColor: '#2ecc71'
      },
      {
        title: 'Carbs',
        totalCalories: Math.round(Number(sum.total_carbs)),
        consumedClories: Math.round(Number(sum.consumed_carbs)),
        progressBarVale: Math.round((Number(sum.consumed_carbs) / Number(sum.total_carbs) * 100)),
        progresBarColor: '#2ecc71'
      },
      {
        title: 'Fiber',
        totalCalories: Math.round(Number(sum.total_fibers)),
        consumedClories: Math.round(Number(sum.consumed_fiber)),
        progressBarVale: Math.round((Number(sum.consumed_fiber) / Number(sum.total_fibers) * 100)),
        progresBarColor: '#FAB000'
      },
      {
        title: 'Fats',
        totalCalories: Math.round(Number(sum.total_fats)),
        consumedClories: Math.round(Number(sum.consumed_fat)),
        progressBarVale: Math.round((Number(sum.consumed_fat) / Number(sum.total_fats) * 100)),
        progresBarColor: '#FF3333'
      },
    ]
    setMacroNuitrientes(arry)
  }, [calories]);


  const renderItem = (item: any, index: number) => {
    return (
      <View style={[style.calorieMainContainer, { paddingVertical: Matrics.vs(5) }]} key={index?.toString()}>
        <CircularProgress
          value={isNaN(item?.progressBarVale) ? 0 : item?.progressBarVale}
          inActiveStrokeColor={item.progresBarColor ? item.progresBarColor : '#2ecc71'}
          inActiveStrokeOpacity={0.2}
          progressValueColor={'green'}
          valueSuffix={'%'}
          radius={Matrics.mvs(22)}
          activeStrokeWidth={3}
          activeStrokeColor={item.progresBarColor ? item.progresBarColor : '#2ecc71'}
          inActiveStrokeWidth={3}
        />
        <View style={{ marginLeft: Matrics.s(10), justifyContent: "center", alignItems: 'center', marginTop: item?.consumedClories === 0 && item?.totalCalories === 0 ? 10 : 0 }}>
          <Text style={style.subtitle}>{item?.title}</Text>
          {item?.consumedClories === 0 && item?.totalCalories === 0 ? null : <View style={style.caloriesContainer}>
            <Text style={style.consumedCalries}>{item?.consumedClories}</Text>
            <Text> or </Text>
            <Text style={[style.consumedCalries, { fontWeight: '400' }]}>{item?.totalCalories}</Text>
          </View>}
        </View>
      </View>
    )
  }

  return (
    <SafeAreaView edges={['top']} style={{ flex: 1, backgroundColor: colors.lightGreyishBlue, paddingVertical: insets.top !== 0 ? 0 : Matrics.vs(15) }}>
      <DietHeader
        onPressBack={onPressBack}
        onPressOfNextAndPerviousDate={handleDate}
        title={'Insights'}
      />
      <ScrollView >
        <Text style={style.title}>Daily Macronutrients Analysis</Text>
        <View style={{ backgroundColor: colors.white, marginHorizontal: Matrics.s(15), paddingVertical: Matrics.vs(5), borderRadius: Matrics.mvs(12) }}>
          {macroNuitrientes?.map((item, index) => { return (renderItem(item, index)) })}
        </View>
        {dailyCalories.length > 0 ?
          <View style={{ flex: 1 }}>
            <Text style={style.title}>Meal Energy Distribution</Text>
            <View style={{ backgroundColor: colors.white, marginHorizontal: Matrics.s(15), paddingVertical: Matrics.vs(5), borderRadius: Matrics.mvs(12) }}>
              {dailyCalories?.map((item, index) => { return (renderItem(item, index)) })}
            </View>
          </View>
          : null}
      </ScrollView>
    </SafeAreaView>
  )
}

export default ProgressBarInsightsScreen
const style = StyleSheet.create({
  container: {
    backgroundColor: "#F9F9FF"
  },
  title: {
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    color: colors.labelDarkGray,
    marginLeft: Matrics.s(10),
    fontFamily: fonts.BOLD,
    paddingVertical: Matrics.vs(15)
  },
  subtitle: {
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
    color: colors.labelDarkGray,
    fontFamily: fonts.BOLD,
  },
  caloriesContainer: {
    flexDirection: 'row'
  },
  consumedCalries: {
    fontSize: Matrics.mvs(12),
    fontWeight: '700',
    color: colors.labelDarkGray,
    fontFamily: fonts.BOLD,
  },
  calorieMainContainer: {
    flexDirection: 'row',
    justifyContent: 'flex-start',
    alignItems: "flex-start",
    paddingHorizontal: Matrics.s(15),

  }
})