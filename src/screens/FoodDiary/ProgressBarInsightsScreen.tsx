import {View, Text, StyleSheet, ScrollView, Platform} from 'react-native';
import React, {useCallback, useEffect, useState} from 'react';
import {DietStackParamList} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import DietHeader from '../../components/molecules/DietHeader';
import {colors} from '../../constants/colors';
import fonts from '../../constants/fonts';
import Matrics from '../../constants/Matrics';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
// import MyStatusbar from '../../components/atoms/MyStatusBar';
import {Fonts} from '../../constants';
import {globalStyles} from '../../constants/globalStyles';
import {CalendarProvider, DateData} from 'react-native-calendars';
import moment from 'moment';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import AnimatedRoundProgressBar from '../../components/atoms/AnimatedRoundProgressBar';
import {colorsOfprogressBar} from '../../helpers/ColorsOfProgressBar';

type ProgressBarInsightsScreenProps = StackScreenProps<
  DietStackParamList,
  'ProgressBarInsightsScreen'
>;

const ProgressBarInsightsScreen: React.FC<ProgressBarInsightsScreenProps> = ({
  navigation,
  route,
}) => {
  const insets = useSafeAreaInsets();
  const [selectedDate, setSelectedDate] = React.useState(new Date());
  const {calories, currentSelectedDate, option} = route.params;
  const [dailyCalories, setDailyCalories] = useState([]);
  const [macroNuitrientes, setMacroNuitrientes] = useState([]);
  const [tempSelectedDate, setTempSelectedDate] = useState<string | Date>(
    new Date(),
  );
  const [newMonth, setNewMonth] = useState<string | Date>(
    moment(tempSelectedDate).format('YYYY-MM-DD'),
  );

  useEffect(() => {
    navigation.addListener('beforeRemove', e => {
      if (e.data.action.type === 'NAVIGATE') {
        return;
      }
      e.preventDefault();
      navigation.navigate('DietScreen', {
        option: option,
      });
    });
  }, [navigation]);

  const onPressBack = () => {
    if (Array.isArray(option) && option.length !== 0) {
      navigation.navigate('DietScreen', {
        option: option,
      });
    } else {
      navigation.goBack();
    }
  };
  const handleDate = (date: any) => {
    setSelectedDate(date);
  };

  useEffect(() => {
    const data = calories.map((item: any) => {
      return {
        title: item?.meal_name,
        totalCalories: Math.round(Number(item.total_calories)),
        consumedClories: Math.round(Number(item.consumed_calories)),
        progressBarVale: Math.round(
          (Math.round(Number(item.consumed_calories)) /
            Math.round(Number(item.total_calories))) *
            100,
        ),
        progresBarColor: colorsOfprogressBar(
          (Math.round(Number(item.consumed_calories)) /
            Math.round(Number(item.total_calories))) *
            100,
        ),
      };
    });
    setDailyCalories(data);

    const sum = calories.reduce(
      (accumulator, currentItem) => {
        accumulator.consumed_protine += currentItem.consumed_protein;
        accumulator.total_proteins += Number(currentItem.total_proteins);
        accumulator.consumed_fiber += currentItem.consumed_fiber;
        accumulator.total_fibers += Number(currentItem.total_fibers);
        accumulator.consumed_carbs += currentItem.consumed_carbs;
        accumulator.total_carbs += Number(currentItem.total_carbs);
        accumulator.consumed_fat += currentItem.consumed_fat;
        accumulator.total_fats += Number(currentItem.total_fats);
        return accumulator;
      },
      {
        consumed_protine: 0,
        total_proteins: 0,
        consumed_fiber: 0,
        total_fibers: 0,
        consumed_carbs: 0,
        total_carbs: 0,
        consumed_fat: 0,
        total_fats: 0,
      },
    );

    const arry = [
      {
        title: 'Protein',
        totalCalories: Math.round(Number(sum.total_proteins)),
        consumedClories: Math.round(Number(sum.consumed_protine)),
        progressBarVale: Math.round(
          (Number(sum.consumed_protine) / Number(sum.total_proteins)) * 100,
        ),
        progresBarColor: colorsOfprogressBar(
          (Number(sum.consumed_protine) / Number(sum.total_proteins)) * 100,
        ),
      },
      {
        title: 'Carbs',
        totalCalories: Math.round(Number(sum.total_carbs)),
        consumedClories: Math.round(Number(sum.consumed_carbs)),
        progressBarVale: Math.round(
          (Number(sum.consumed_carbs) / Number(sum.total_carbs)) * 100,
        ),
        progresBarColor: colorsOfprogressBar(
          (Number(sum.consumed_carbs) / Number(sum.total_carbs)) * 100,
        ),
      },
      {
        title: 'Fiber',
        totalCalories: Math.round(Number(sum.total_fibers)),
        consumedClories: Math.round(Number(sum.consumed_fiber)),
        progressBarVale: Math.round(
          (Number(sum.consumed_fiber) / Number(sum.total_fibers)) * 100,
        ),
        progresBarColor: colorsOfprogressBar(
          (Number(sum.consumed_fiber) / Number(sum.total_fibers)) * 100,
        ),
      },
      {
        title: 'Fats',
        totalCalories: Math.round(Number(sum.total_fats)),
        consumedClories: Math.round(Number(sum.consumed_fat)),
        progressBarVale: Math.round(
          (Number(sum.consumed_fat) / Number(sum.total_fats)) * 100,
        ),
        progresBarColor: colorsOfprogressBar(
          (Number(sum.consumed_fat) / Number(sum.total_fats)) * 100,
        ),
      },
    ];
    setMacroNuitrientes(arry);
  }, [calories]);

  const renderItem = (item: any, index: number, type: string) => {
    return (
      <View
        style={[style.calorieMainContainer, {paddingVertical: Matrics.vs(5)}]}
        key={index?.toString()}>
        <AnimatedRoundProgressBar
          values={isNaN(item?.progressBarVale) ? 0 : item?.progressBarVale}
        />

        <View
          style={[
            style.textContainer,
            {
              justifyContent: 'space-between',
            },
          ]}>
          <Text style={style.subtitle}>{item?.title}</Text>
          <View
            style={{
              flexDirection: 'row',
              alignItems: 'center',
            }}>
            <Text style={style.consumedCalries}>
              {isNaN(item?.consumedClories) ? 0 : item?.consumedClories}
            </Text>
            <Text style={[style.consumedCalries, {fontFamily: Fonts.REGULAR}]}>
              {' '}
              of{' '}
            </Text>
            <Text
              style={[
                style.consumedCalries,
                {fontFamily: Fonts.REGULAR, color: colors.subTitleLightGray},
              ]}>
              {item?.totalCalories}
              {type}
            </Text>
          </View>
        </View>
      </View>
    );
  };

  const onChangeMonth = (date: DateData) => {
    let tempDate = new Date(date?.dateString);
    setNewMonth(tempDate);
  };

  const onDateChanged = useCallback((date: any, updateSource: any) => {
    let tempDate = new Date(date);
    setNewMonth(tempDate);
    console.log('tempDate', tempDate);
  }, []);

  return (
    <SafeAreaView
      edges={['top']}
      style={{
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        // paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(15),
        paddingTop: Platform.OS == 'android' ? Matrics.vs(20) : 0,
      }}>
      <MyStatusbar backgroundColor={colors.lightGreyishBlue} />
      <CalendarProvider
        date={moment(tempSelectedDate).format('YYYY-MM-DD')}
        disabledOpacity={0.6}
        onMonthChange={onChangeMonth}
        onDateChanged={onDateChanged}>
        <DietHeader
          onPressBack={onPressBack}
          onPressOfNextAndPerviousDate={handleDate}
          title="Insights"
          selectedDate={tempSelectedDate}
          newMonth={newMonth}
          onChangeDate={date => {
            setTempSelectedDate(date);
            setNewMonth(date);
          }}
        />
        <ScrollView
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{
            paddingBottom:
              Platform.OS == 'ios'
                ? insets.bottom
                : insets.bottom + Matrics.s(16),
          }}>
          <Text style={style.title}>Daily Macronutrients Analysis</Text>
          <View
            style={[
              globalStyles.shadowContainer,
              style.boxContainer,
              {
                marginBottom: Matrics.vs(10),
              },
            ]}>
            {macroNuitrientes?.map((item, index) => {
              return renderItem(item, index, 'g');
            })}
          </View>
          {dailyCalories.length > 0 ? (
            <View style={{flex: 1}}>
              <Text style={style.title}>Meal Energy Distribution</Text>
              <View style={[globalStyles.shadowContainer, style.boxContainer]}>
                {dailyCalories?.map((item, index) => {
                  return renderItem(item, index, 'cal');
                })}
              </View>
            </View>
          ) : null}
        </ScrollView>
      </CalendarProvider>
    </SafeAreaView>
  );
};

export default ProgressBarInsightsScreen;
const style = StyleSheet.create({
  container: {
    backgroundColor: '#F9F9FF',
  },
  title: {
    fontSize: Matrics.mvs(15),
    color: colors.labelDarkGray,
    marginLeft: Matrics.s(10),
    fontFamily: fonts.BOLD,
    paddingTop: Matrics.vs(7),
    paddingBottom: Matrics.vs(10),
    paddingLeft: Matrics.s(5),
    lineHeight: 20,
  },
  subtitle: {
    fontSize: Matrics.mvs(15),
    color: colors.labelDarkGray,
    fontFamily: fonts.MEDIUM,
    lineHeight: 22,
    textTransform: 'capitalize',
  },
  caloriesContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  consumedCalries: {
    fontSize: Matrics.mvs(12),
    color: colors.labelDarkGray,
    fontFamily: fonts.MEDIUM,
    lineHeight: 20,
  },
  calorieMainContainer: {
    flexDirection: 'row',
    paddingHorizontal: Matrics.s(15),
    alignItems: 'center',
  },
  textContainer: {
    marginLeft: Matrics.s(10),
    justifyContent: 'space-around',
  },
  boxContainer: {
    backgroundColor: colors.white,
    marginHorizontal: Matrics.s(15),
    paddingVertical: Matrics.vs(5),
    borderRadius: Matrics.mvs(12),
    shadowRadius: 8,
    shadowOpacity: 0.15,
  },
});
