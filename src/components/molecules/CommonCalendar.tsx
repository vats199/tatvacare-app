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
import React, { memo, useEffect, useMemo, useState, useCallback } from 'react';
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
import { Positions } from 'react-native-calendars/src/expandableCalendar';

type CommonCalendarProps = {
  selectedDate: Date | string;
  weekCalendarProps?: WeekCalendarProps;
  expandableCalendarProps?: ExpandableCalendarProps;
  calendarContainerStyle?: ViewStyle;
  onPressDay: (date: Date) => void;
  containerStyle?: ViewStyle;
  headerTxtContainer?: ViewStyle;
  titleStyle?: TextStyle;
  iconContainerStyle?: ViewStyle;
  newMonth: string | Date;
  onChangeDate: (date: string | Date) => void;
};

const { width } = Dimensions.get('window');

const CommonCalendar: React.FC<CommonCalendarProps> = ({
  selectedDate,
  weekCalendarProps,
  expandableCalendarProps,
  containerStyle,
  onPressDay,
  calendarContainerStyle,
  headerTxtContainer,
  titleStyle,
  iconContainerStyle,
  newMonth,
  onChangeDate,
}) => {
  const focus = useIsFocused();
  const [seletedDay, setSeletedDay] = useState<string>(
    moment(selectedDate).format('YYYY-MM-DD'),
  );
  const [calendarDates, setCalendarDates] = useState(
    moment(selectedDate).format('YYYY-MM-DD'),
  );
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

  const onDayPress = (date: DateData) => {
    let tempDate = new Date(date?.dateString);
    onPressDay(tempDate);
    setSeletedDay(moment(date?.dateString).format('YYYY-MM-DD'));
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_DATE, {
      current_date: moment().format(Constants.DATE_FORMAT),
      date_selected: moment(date?.dateString).format(Constants.DATE_FORMAT),
      day_selected: moment(date?.dateString).format('dddd'),
    });
  };

  const handleNextWeek = () => {
    const nextWeek = new Date(calendarDates);
    nextWeek.setDate(nextWeek.getDate() + 7);
    const tempDate = moment(nextWeek).format('YYYY-MM-DD');
    setCalendarDates(tempDate);
    onChangeDate(tempDate);
  };

  const handlePreviousWeek = () => {
    const previousWeek = new Date(calendarDates);
    previousWeek.setDate(previousWeek.getDate() - 7);
    const tempDate = moment(previousWeek).format('YYYY-MM-DD');
    setCalendarDates(tempDate);
    onChangeDate(tempDate);
  };

  const handleNextMonth = () => {
    const currentMonnth = new Date(calendarDates);
    var nextMonth = moment(currentMonnth).add(1, 'months');
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_MONTH, {
      current_month: moment(currentMonnth).format('MM'),
      new_month: nextMonth,
    });
    const tempDate = moment(new Date(nextMonth.toString())).format(
      'YYYY-MM-DD',
    );
    focus
      ? LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut)
      : null;
    setCalendarDates(tempDate);
    onChangeDate(tempDate);
  };

  const handlePreviousMonth = () => {
    const currentMonnth = new Date(calendarDates);
    var previousMonth = moment(currentMonnth).subtract(1, 'months');
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.USER_CHANGES_MONTH, {
      current_month: moment(currentMonnth).format('MM'),
      new_month: previousMonth,
    });
    const tempDate = moment(new Date(previousMonth.toString())).format(
      'YYYY-MM-DD',
    );
    focus
      ? LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut)
      : null;
    setCalendarDates(tempDate);
    onChangeDate(tempDate);
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

  const getMondayOfWeek = (dateString: any) => {
    const date = new Date(dateString);
    const dayOfWeek = date.getDay();
    let diff = dayOfWeek - 1;
    if (dayOfWeek === 0) {
      diff = 6;
    }
    const mondayOfWeek = new Date(date);
    mondayOfWeek.setDate(date.getDate() - diff);

    return mondayOfWeek;
  };

  const onExpandCalendar = (isOpen: boolean) => {
    if (isOpen) {
      trackEvent(Constants.EVENT_NAME.FOOD_DIARY.EXPAND_CALENDAR, {
        current_date: moment().format(Constants.DATE_FORMAT),
        date_selected: moment(seletedDay).format(Constants.DATE_FORMAT),
        day_selected: moment(seletedDay).format('dddd'),
      });
    }
    setShowMore(isOpen);
    // const mondayOfWeek = getMondayOfWeek(seletedDay);
    // console.log('mondayOfWeek', mondayOfWeek);
    // const tempDate = moment(mondayOfWeek).format('YYYY-MM-DD');
    // setCalendarDates(tempDate);
    // onChangeDate(tempDate);
  };

  // const onDateChanged = useCallback((date: any, updateSource: any) => {
  //   let tempDate = new Date(date);
  //   setNewMonth(tempDate);
  //   console.log('tempDate', tempDate);

  //   // setSeletedDay(moment(date?.dateString).format('YYYY-MM-DD'))
  //   // if (updateSource === 'weekScroll') {
  //   //   let month = getMonthRangeText(new Date(tempDate))
  //   // } else {
  //   //   let month = getMonthText(new Date(tempDate))
  //   //   setNewMonth(month)
  //   // }
  // }, []);

  const markedDateStyle: MarkedDates | undefined = useMemo(() => {
    return {
      [seletedDay]: {
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
    textDisabledColor: colors.subTitleLightGray,
    todayTextColor: colors.subTitleLightGray,
    disabledArrowColor: '#d9e1e8',
    textMonthFontFamily: Fonts.BOLD,
    textDayFontWeight: '400',
    textDayHeaderFontWeight: '400',
    textDayFontSize: Matrics.mvs(13),
    textMonthFontSize: Matrics.mvs(13),
    textDayHeaderFontSize: Matrics.mvs(12),
    monthTextColor: colors.black,
    textDayFontFamily: Fonts.REGULAR,
  };

  // const renderDays = date => {
  //   // const isCurrentDate =
  //   //   moment(seletedDay).format('MM') ==
  //   //   moment(date.date?.dateString).format('MM');
  //   // if (date.state == 'disabled' || !isCurrentDate) return null;

  //   return (
  //     <TouchableOpacity
  //       key={date}
  //       onPress={date => onDayPress(date.date)}
  //       style={{
  //         backgroundColor:
  //           date?.date?.dateString == seletedDay
  //             ? colors.themePurple
  //             : colors.transparent,
  //         height: Matrics.vs(26),
  //         width: Matrics.s(35),
  //         borderRadius: Matrics.s(10),
  //         alignItems: 'center',
  //         justifyContent: 'center',
  //       }}>
  //       <Text
  //         style={{
  //           fontFamily: Fonts.REGULAR,
  //           fontSize: Matrics.mvs(13),
  //           lineHeight: 18,
  //           color:
  //             date?.date?.dateString == seletedDay
  //               ? colors.white
  //               : colors.subTitleLightGray,
  //         }}>
  //         {date.date?.day}
  //       </Text>
  //     </TouchableOpacity>
  //   );
  // };

  const calendarHeight: Positions | undefined = useMemo(() => {
    return !showMore
      ? ExpandableCalendar.positions.CLOSED
      : ExpandableCalendar.positions.OPEN;
  }, [showMore]);
  return (
    <ExpandableCalendar
      // current={moment(calendarDates).format('YYYY-MM-DD')}
      horizontal
      firstDay={1}
      initialPosition={calendarHeight}
      allowShadow={false}
      hideArrows
      onDayPress={onDayPress}
      markingType="custom"
      onCalendarToggled={isOpen => {
        onExpandCalendar(isOpen);
      }}
      disabledByDefault
      renderHeader={() => {
        return (
          <View style={[styles.container, containerStyle]}>
            <View style={[styles.leftRightContent, headerTxtContainer]}>
              <Text style={[styles.monthYearStyle, titleStyle]}>
                {!showMore
                  ? getMonthRangeText(new Date(newMonth))
                  : getMonthText(new Date(newMonth))}
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
        );
      }}
      headerStyle={{
        paddingLeft: Matrics.s(3),
        paddingRight: Matrics.s(3),
      }}
      calendarStyle={{
        paddingLeft: Matrics.s(3),
        paddingRight: Matrics.s(3),
      }}
      theme={{
        ...themeStyle,
        selectedDayBackgroundColor: undefined,
        selectedDayTextColor: colors.subTitleLightGray,
      }}
      markedDates={markedDateStyle}
      closeOnDayPress
      {...expandableCalendarProps}
    />
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
    height: Matrics.vs(38),
    paddingHorizontal: Matrics.s(3),
    flex: 1,
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  monthYearStyle: {
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.REGULAR,
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
