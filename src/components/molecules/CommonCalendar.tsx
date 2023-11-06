import {
  Animated,
  Dimensions,
  LayoutAnimation,
  Platform,
  StyleSheet,
  Text,
  TextStyle,
  TouchableOpacity,
  View,
  ViewStyle,
} from 'react-native';
import React, { memo, useMemo, useState } from 'react';
import {
  CalendarProvider,
  DateData,
  ExpandableCalendar,
  ExpandableCalendarProps,
  LocaleConfig,
  WeekCalendar,
  WeekCalendarProps,
} from 'react-native-calendars';
import moment from 'moment';
import { Constants, Fonts, Matrics } from '../../constants';
import { colors } from '../../constants/colors';
import { MarkedDates, Theme } from 'react-native-calendars/src/types';
import { Icons } from '../../constants/icons';
import { useIsFocused } from '@react-navigation/native';
import { trackEvent } from '../../helpers/TrackEvent';

type CommonCalendarProps = {
  selectedDate: Date;
  weekCalendarProps?: WeekCalendarProps;
  expandableCalendarProps?: ExpandableCalendarProps;
  calendarContainerStyle?: ViewStyle;
  onPressDay: (date: Date) => void;
  // setSelectedDate: React.Dispatch<React.SetStateAction<Date>>;
  containerStyle?: ViewStyle;
  headerTxtContainer?: ViewStyle;
  titleStyle?: TextStyle;
  iconContainerStyle?: ViewStyle;
};

const { width } = Dimensions.get('window');

const CommonCalendar: React.FC<CommonCalendarProps> = ({
  selectedDate,
  weekCalendarProps,
  expandableCalendarProps,
  containerStyle,
  onPressDay,
  // setSelectedDate,
  calendarContainerStyle,
  headerTxtContainer,
  titleStyle,
  iconContainerStyle,
}) => {
  const focus = useIsFocused();
  const [seletedDay, setSeletedDay] = useState(
    moment(selectedDate).format('YYYY-MM-DD'),
  );
  const [calendarKey, setCalendarKey] = useState(0);
  const [showMore, setShowMore] = useState<boolean>(false);

  LocaleConfig.locales['en'] = {
    monthNames: [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    monthNamesShort: [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ],
    dayNames: [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ],
    dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    today: 'Today',
  };

  LocaleConfig.defaultLocale = 'en';

  const markedDateStyle: MarkedDates | undefined = useMemo(() => {
    return {
      [moment(seletedDay).format('YYYY-MM-DD')]: {
        customStyles: {
          container: {
            backgroundColor: colors.themePurple,
            borderRadius: Matrics.mvs(11),
            justifyContent: 'center',
            alignItems: 'center',
            height: Matrics.vs(26),
            width: Matrics.s(35),
          },
          text: {
            color: 'white',
            fontFamily: Fonts.REGULAR,
            fontSize: Matrics.mvs(13),
            lineHeight: 18,
          },
        },
      },
    };
  }, [seletedDay]);

  const themeStyle: Theme | undefined = {
    backgroundColor: colors.lightGreyishBlue,
    calendarBackground: colors.lightGreyishBlue,
    textSectionTitleColor: colors.subTitleLightGray,
    textSectionTitleDisabledColor: colors.black,
    dayTextColor: colors.subTitleLightGray,
    textDisabledColor: '#d9e1e8',
    todayTextColor: colors.subTitleLightGray,
    disabledArrowColor: '#d9e1e8',
    textMonthFontFamily: Fonts.BOLD,
    textDayFontWeight: '400',
    textDayHeaderFontWeight: '400',
    textDayFontSize: Matrics.mvs(13),
    textMonthFontSize: Matrics.mvs(13),
    textDayHeaderFontSize: Matrics.mvs(12),
    monthTextColor: colors.black,
  };

  const onDayPress = (date: DateData) => {
    let tempDate = new Date(date?.dateString);
    onPressDay(tempDate);
    // selectedDate(tempDate);
    setSeletedDay(moment(date?.dateString).format("YYYY-MM-DD"));
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_DATE, {
      current_date: moment().format(Constants.DATE_FORMAT),
      date_selected: moment(date?.dateString).format(Constants.DATE_FORMAT),
      day_selected: moment(date?.dateString).format('dddd'),
    });
  };

  const onChangeMonth = (date: DateData) => {
    let tempDate = new Date(date?.dateString);
    setSeletedDay(moment(tempDate).format('YYYY-MM-DD'));
  };

  const handleNextWeek = () => {
    const nextWeek = new Date(seletedDay);
    nextWeek.setDate(nextWeek.getDate() + 7);
    // setSelectedDate(nextWeek);
    setSeletedDay(moment(nextWeek).format('YYYY-MM-DD'));
    setCalendarKey(calendarKey + 1);
  };

  const handlePreviousWeek = () => {
    const previousWeek = new Date(seletedDay);
    previousWeek.setDate(previousWeek.getDate() - 7);
    setSeletedDay(moment(previousWeek).format('YYYY-MM-DD'));
    setCalendarKey(calendarKey - 1);
  };

  const handleNextMonth = () => {
    const currentMonnth = new Date(seletedDay);
    var nextMonth = moment(currentMonnth).add(1, 'months');
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_MONTH, {
      current_month: moment(currentMonnth).format('MM'),
      new_month: nextMonth,
    });
    setSeletedDay(moment(new Date(nextMonth.toString())).format('YYYY-MM-DD'));
    console.log("previousMonth", currentMonnth);

    // setSelectedDate(new Date(nextMonth.toString()));
    setCalendarKey(calendarKey + 1);
  };

  const handlePreviousMonth = () => {
    const currentMonnth = new Date(seletedDay);
    var previousMonth = moment(currentMonnth).subtract(1, 'months');
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_MONTH, {
      current_month: moment(currentMonnth).format('MM'),
      new_month: previousMonth,
    });
    console.log("previousMonth", previousMonth);

    setSeletedDay(moment(new Date(previousMonth.toString())).format('YYYY-MM-DD'));
    // setSelectedDate(new Date(previousMonth.toString()));
    setCalendarKey(calendarKey + 1);
  };

  const getMonthRangeText = (date: Date) => {
    const weekStartDate = new Date(date);
    const weekEndDate = new Date(weekStartDate);

    while (weekStartDate.getDay() !== 1) {
      weekStartDate.setDate(weekStartDate.getDate() - 1);
    }
    while (weekEndDate.getDay() !== 0) {
      weekEndDate.setDate(weekEndDate.getDate() + 1);
    }
    const startMonth = weekStartDate.toLocaleString('default', { month: 'long' });
    const endMonth = weekEndDate.toLocaleString('default', { month: 'long' });

    const year = weekStartDate.getFullYear();

    if (
      startMonth !== endMonth ||
      weekEndDate.getDate() >
      new Date(year, weekStartDate.getMonth() + 1, 0).getDate()
    ) {
      return `${startMonth} - ${endMonth} ${year}`;
    } else {
      return `${startMonth} ${year}`;
    }
  };

  const getMonthText = (date: Date) => {
    return moment(date).format('MMMM  YYYY');
  };

  const renderDays = date => {
    const isCurrentDate =
      moment(selectedDate).format('MM') ==
      moment(date.date?.dateString).format('MM');
    if (date.state == 'disabled' || !isCurrentDate) return null;
    return (
      <TouchableOpacity
        onPress={() => onDayPress(date.date)}
        style={{
          backgroundColor:
            date.state == 'selected' ? colors.themePurple : colors.transparent,
          height: Matrics.vs(26),
          width: Matrics.s(35),
          borderRadius: Matrics.s(10),
          alignItems: 'center',
          justifyContent: 'center',
        }}>
        <Text
          style={{
            fontFamily: Fonts.REGULAR,
            fontSize: Matrics.mvs(13),
            lineHeight: 18,
            color:
              date.state == 'selected'
                ? colors.white
                : colors.subTitleLightGray,
          }}>
          {date.date?.day}
        </Text>
      </TouchableOpacity>
    );
  };

  const onExpandCalendar = () => {
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_DATE, {
      current_date: moment().format(Constants.DATE_FORMAT),
      date_selected: moment(selectedDate).format(Constants.DATE_FORMAT),
      day_selected: moment(selectedDate).format('dddd'),
    });
    focus
      ? LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut)
      : null;
    setShowMore(!showMore);
  };

  // console.log("seletedDay", seletedDay);
  // console.log("seletedtDate", selectedDate);

  return (
    <>
      <View style={[styles.container, containerStyle]}>
        <View style={[styles.leftRightContent, headerTxtContainer]}>
          <Text style={[styles.monthYearStyle, titleStyle]}>
            {!showMore
              ? getMonthRangeText(new Date(seletedDay))
              : getMonthText(new Date(seletedDay))}
          </Text>
        </View>
        <View style={[styles.leftRightContent, iconContainerStyle]}>
          <TouchableOpacity
            onPress={!showMore ? handlePreviousWeek : handlePreviousMonth}
            hitSlop={8}>
            <Icons.backArrow
              height={11}
              width={11}
              style={{
                marginHorizontal: Matrics.s(12),
              }}
            />
          </TouchableOpacity>
          <TouchableOpacity
            onPress={!showMore ? handleNextWeek : handleNextMonth}
            hitSlop={8}>
            <Icons.RightArrow height={22} width={22} />
          </TouchableOpacity>
        </View>
      </View>
      <View
        style={[
          styles.calendarContainer,
          {
            height: showMore
              ? Matrics.vs(Platform.OS == 'android' ? 275 : 270)
              : Matrics.vs(65),
          },
          calendarContainerStyle,
        ]}>
        <CalendarProvider
          date={moment(seletedDay).format('YYYY-MM-DD')}
          disabledOpacity={0.6}>
          {!showMore ? (
            <Animated.View style={{ overflow: 'hidden' }}>
              <WeekCalendar
                firstDay={1}
                current={moment(seletedDay).format('YYYY-MM-DD')}
                onDayPress={onDayPress}
                markingType="custom"
                markedDates={markedDateStyle}
                allowShadow={false}
                scrollEnabled={true}
                theme={{
                  ...themeStyle,
                  selectedDayBackgroundColor: undefined,
                  selectedDayTextColor: colors.subTitleLightGray,
                  textDisabledColor: colors.inactiveGray,
                }}
                style={[
                  styles.removePaddingHorizontal,
                  {
                    marginTop: Matrics.vs(8),
                    paddingLeft: Matrics.s(3),
                    paddingRight: Matrics.s(3),
                  },
                ]}
                {...weekCalendarProps}
              />
            </Animated.View>
          ) : (
            <ExpandableCalendar
              horizontal
              hideKnob
              firstDay={1}
              initialPosition={ExpandableCalendar.positions.OPEN}
              current={moment(seletedDay).format('YYYY-MM-DD')}
              disableAllTouchEventsForDisabledDays={true}
              hideExtraDays={true}
              onMonthChange={onChangeMonth}
              markingType="custom"
              pagingEnabled={true}
              scrollEnabled={false}
              calendarStyle={{
                paddingLeft: Matrics.s(4),
                paddingRight: Matrics.s(4),
              }}
              headerStyle={{
                paddingLeft: Matrics.s(4),
                paddingRight: Matrics.s(4),
              }}
              disablePan={true}
              collapsable={false}
              allowShadow={false}
              dayComponent={memo(renderDays)}
              theme={{
                ...themeStyle,
                selectedDayBackgroundColor: undefined,
                selectedDayTextColor: colors.subTitleLightGray,
                stylesheet: {
                  calendar: {
                    header: {
                      height: 0,
                      opacity: 0,
                    },
                  },
                },
              }}
              hideArrows
              renderHeader={() => null}
              markedDates={markedDateStyle}
              {...expandableCalendarProps}
            />
          )}
        </CalendarProvider>
      </View>
      <TouchableOpacity
        style={styles.dropDwonIcon}
        hitSlop={8}
        onPress={() => {
          onExpandCalendar();
        }}>
        {showMore ? <Icons.ShowMore /> : <Icons.ShowLess />}
      </TouchableOpacity>
    </>
  );
};

export default memo(CommonCalendar);

const styles = StyleSheet.create({
  removePaddingHorizontal: {
    paddingLeft: 0,
    paddingRight: 0,
  },
  calendarContainer: {
    width: width,
    overflow: 'hidden',
  },
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: Matrics.s(15),
    paddingTop: Matrics.vs(5),
    paddingBottom: Matrics.vs(3),
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  monthYearStyle: {
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.MEDIUM,
    color: colors.labelDarkGray,
    lineHeight: Matrics.vs(18),
  },
  dropDwonIcon: {
    opacity: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: Matrics.vs(4),
    alignSelf: 'center',
    paddingHorizontal: Matrics.s(10),
  },
  arrowContainer: {
    height: Matrics.mvs(20),
    width: Matrics.mvs(30),
    justifyContent: 'center',
    alignItems: 'center',
  },
  customHeaderText: {
    fontSize: 19,
    fontWeight: 'bold',
    color: colors.black,
    marginLeft: 6,
  },
  dateNumberStyle: {
    fontSize: Matrics.mvs(14),
    color: '#656566',
    height: Matrics.vs(26),
    width: Matrics.s(35),
    alignItems: 'center',
    paddingVertical: Platform.OS == 'ios' ? Matrics.vs(5) : 0,
    marginTop: Matrics.vs(10),
  },
  highlighetdDateNumberStyle: {
    fontSize: Matrics.mvs(14),
    backgroundColor: '#760FB1',
    borderRadius: Matrics.mvs(12),
    color: 'white',
    overflow: 'hidden',
    fontFamily: Fonts.REGULAR,
    fontWeight: '400',
  },
  leftRightContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
});
