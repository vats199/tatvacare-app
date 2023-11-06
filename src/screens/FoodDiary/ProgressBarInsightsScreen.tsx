import {View, Text, StyleSheet, ScrollView, Platform} from 'react-native';
import React, {useEffect, useState} from 'react';
import {DietStackParamList} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import DietHeader from '../../components/molecules/DietHeader';
import {colors} from '../../constants/colors';
import fonts from '../../constants/fonts';
import Matrics from '../../constants/Matrics';
import CircularProgress from 'react-native-circular-progress-indicator';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
// import MyStatusbar from '../../components/atoms/MyStatusBar';
import {Fonts} from '../../constants';
import {globalStyles} from '../../constants/globalStyles';

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
  const {calories} = route.params;
  const [dailyCalories, setDailyCalories] = useState([]);
  const [macroNuitrientes, setMacroNuitrientes] = useState([]);

  const onPressBack = () => {
    navigation.goBack();
  };
  const handleDate = (date: any) => {
    setSelectedDate(date);
  };

  const colorsOfprogressBar = (values: number) => {
    if (values === 0) {
      return colors.inactiveGray;
    } else if (values > 0 && values < 25) {
      return colors.progressBarRed;
    } else if (values >= 25 && values < 75) {
      return colors.progressBarYellow;
    } else {
      return colors.progressBarGreen;
    }
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
        <CircularProgress
          value={isNaN(item?.progressBarVale) ? 0 : item?.progressBarVale}
          inActiveStrokeColor={
            item.progresBarColor ? item.progresBarColor : '#2ecc71'
          }
          inActiveStrokeOpacity={0.2}
          progressValueColor={'green'}
          // valueSuffix={'%'}
          maxValue={100}
          radius={Matrics.mvs(22)}
          activeStrokeWidth={3}
          activeStrokeColor={
            item.progresBarColor ? item.progresBarColor : '#2ecc71'
          }
          inActiveStrokeWidth={3}
          duration={500}
          allowFontScaling={false}
          showProgressValue={false}
          title={`${isNaN(item?.progressBarVale) ? 0 : item?.progressBarVale}%`}
          titleStyle={{
            fontSize: Matrics.mvs(11),
            fontFamily: Fonts.BOLD,
          }}
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

  return (
    <SafeAreaView
      edges={['top']}
      style={{
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(15),
        paddingTop: Platform.OS == 'android' ? Matrics.vs(20) : 0,
      }}>
      {/* <MyStatusbar backgroundColor={colors.lightGreyishBlue} /> */}
      <DietHeader
        onPressBack={onPressBack}
        onPressOfNextAndPerviousDate={handleDate}
        title={'Insights'}
        getCurrentSeletedDate={handleDate}
      />
      <ScrollView style={{paddingBottom: 14}}>
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
            <View
              style={[
                globalStyles.shadowContainer,
                style.boxContainer,
                {
                  marginBottom: Matrics.vs(20),
                },
              ]}>
              {dailyCalories?.map((item, index) => {
                return renderItem(item, index, 'cal');
              })}
            </View>
          </View>
        ) : null}
      </ScrollView>
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
