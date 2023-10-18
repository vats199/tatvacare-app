import { View, Text, StyleSheet } from 'react-native'
import React, { useEffect, useState } from 'react'
import { DietStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import DietHeader from '../../components/molecules/DietHeader';
import { colors } from '../../constants/colors';
import fonts from '../../constants/fonts';
import Matrics from '../../constants/Matrics';
import CircularProgress from 'react-native-circular-progress-indicator';

type ProgressBarInsightsScreenProps = StackScreenProps<DietStackParamList, 'ProgressBarInsightsScreen'>

const ProgressBarInsightsScreen: React.FC<ProgressBarInsightsScreenProps> = ({ navigation, route }) => {
  const [selectedDate, setSelectedDate] = React.useState(new Date());
  const { calories } = route.params
  const [dailyCalories, setDailyCalories] = useState([])
  console.log("dailyCalories", dailyCalories);

  const onPressBack = () => {
    navigation.goBack();
  };
  const handleDate = (date: any) => {
    setSelectedDate(date);
  };

  useEffect(() => {
    const data = calories.map((item: any) => {
      // let color:'green'
      // switch (key) {
      //   case value:
          
      //     break;
      
      //   default:
      //     break;
      // }
      return {
        title: item?.meal_name,
        totalCalories: Math.round(Number(item.total_calories)),
        consumedClories: Math.round(Number(item.consumed_calories)),
        progressBarVale: Math.round((Math.round(Number(item.consumed_calories)) / Math.round(Number(item.total_calories))) * 100),
        // progresBarColor: 
      }
    })
    setDailyCalories(data)
  }, [calories])

  const renderItem = (item: any) => {
    return (
      <View style={style.calorieMainContainer}>
        <CircularProgress
          value={item?.progressBarVale}
          inActiveStrokeColor={'#2ecc71'}
          inActiveStrokeOpacity={0.2}
          progressValueColor={'green'}
          valueSuffix={'%'}
          radius={Matrics.mvs(22)}
          activeStrokeWidth={3}
          inActiveStrokeWidth={3}
        />
        <View style={{ marginLeft: Matrics.s(10) }}>
          <Text style={style.subtitle}>{item?.title}</Text>
          <View style={style.caloriesContainer}>
            <Text style={style.consumedCalries}>{item?.consumedClories}</Text>
            <Text> or </Text>
            <Text style={[style.consumedCalries, { fontWeight: '400' }]}>{item?.totalCalories}</Text>
          </View>
        </View>
      </View>
    )
  }

  return (
    <View >
      <DietHeader
        onPressBack={onPressBack}
        onPressOfNextAndPerviousDate={handleDate}
        title={'Insights'}
      />
      <Text style={style.title}>Daily Macronutrients Analysis</Text>
      <View style={{backgroundColor:colors.white, marginHorizontal:Matrics.s(15), paddingVertical:Matrics.vs(5) , borderRadius:Matrics.mvs(12)}}>
      {dailyCalories?.map((item) => { return (renderItem(item)) })}
      </View>
    </View>
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
    paddingVertical: Matrics.vs(5),
  }
})