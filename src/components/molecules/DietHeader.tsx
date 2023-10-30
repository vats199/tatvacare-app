import React, { useState } from 'react';
import CalendarStrip from 'react-native-calendar-strip';
import { StyleSheet, Text, View, Dimensions, LayoutAnimation, } from 'react-native';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { TouchableOpacity } from 'react-native';
import { LocaleConfig, CalendarList } from 'react-native-calendars';
import { Fonts, Matrics } from '../../constants';
import moment from 'moment';
import { useIsFocused } from '@react-navigation/native';

const { width } = Dimensions.get('window');
type DietHeaderProps = {
  onPressBack: () => void;
  onPressOfNextAndPerviousDate: (data: any) => void;
  title: string;
};
const DietHeader: React.FC<DietHeaderProps> = ({
  onPressBack,
  onPressOfNextAndPerviousDate,
  title,
}) => {
  //const calendarStripRef = useRef(null);
  const focus = useIsFocused();
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [calendarKey, setCalendarKey] = useState(0);
  const [seletedDay, setseletedDay] = useState(
    moment(selectedDate).format('YYYY-MM-DD'),
  );
  const [showMore, setShowMore] = useState<boolean>(false);

  const handleNextWeek = () => {
    const nextWeek = new Date(selectedDate);
    nextWeek.setDate(nextWeek.getDate() + 7);
    setSelectedDate(nextWeek);

    onPressOfNextAndPerviousDate(nextWeek);
    setCalendarKey(calendarKey + 1);
  };

  const handlePreviousWeek = () => {
    const previousWeek = new Date(selectedDate);
    previousWeek.setDate(previousWeek.getDate() - 7);
    setSelectedDate(previousWeek);
    onPressOfNextAndPerviousDate(previousWeek);
    setCalendarKey(calendarKey - 1);
  };

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
    dayNamesShort: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'],
    today: 'Today',
  };

  LocaleConfig.defaultLocale = 'en';

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

  const handleNextMonth = () => {
    const nextMonth = new Date(selectedDate);
    nextMonth.setMonth(nextMonth.getMonth() + 1);
    setSelectedDate(nextMonth);
    onPressOfNextAndPerviousDate(nextMonth);
    setCalendarKey(calendarKey + 1);
  };

  return (
    <View style={styles.mainContainer}>
      <View style={styles.upperContainer}>
        <View style={styles.customHeader}>
          <TouchableOpacity hitSlop={8} onPress={onPressBack}>
            <Icons.backArrow />
          </TouchableOpacity>
          <Text style={styles.customHeaderText}> {title}</Text>
        </View>
        <View>
          <View style={styles.container}>
            <View style={styles.leftRightContent}>
              <View style={styles.row}>
                <Text style={styles.monthYearStyle}>
                  {getMonthRangeText(selectedDate)}
                </Text>
              </View>
              {/* <Icons.RightArrow
                height={20}
                width={20}
                onPress={handleNextMonth}
              /> */}
            </View>
            <View style={styles.leftRightContent}>
              <TouchableOpacity onPress={handlePreviousWeek} hitSlop={8}>
                <Icons.backArrow
                  height={11}
                  width={11}
                  style={{
                    marginHorizontal: Matrics.s(12),
                  }}
                />
              </TouchableOpacity>
              <TouchableOpacity onPress={handleNextWeek} hitSlop={8}>
                <Icons.RightArrow height={22} width={22} />
              </TouchableOpacity>
            </View>
          </View>
          {!showMore ? (
            <View style={{ paddingHorizontal: Matrics.s(5) }}>
              <CalendarStrip
                selectedDate={selectedDate}
                key={calendarKey}
                showMonth={false}
                onDateSelected={date => {
                  setSelectedDate(date);
                  onPressOfNextAndPerviousDate(date);
                }}
                weekendDateNameStyle={{ textTransform: 'capitalize' }}
                daySelectionAnimation={{
                  type: 'border',
                  duration: 200,
                  borderWidth: 1,
                  borderHighlightColor: 'white',
                }}
                style={{ height: Matrics.vs(70) }}
                dayContainerStyle={{
                  borderRadius: 0,
                }}
                calendarColor={colors.lightGreyishBlue}
                dateNumberStyle={styles.dateNumberStyle}
                dateNameStyle={{ color: 'black' }}
                highlightDateNumberStyle={[
                  styles.dateNumberStyle,
                  styles.highlighetdDateNumberStyle,
                ]}
                highlightDateNameStyle={{ color: 'black' }}
                disabledDateNameStyle={{ color: 'grey' }}
                disabledDateNumberStyle={{ color: 'grey' }}
                iconLeftStyle={{ display: 'none' }}
                iconRightStyle={{ display: 'none' }}
              />
            </View>
          ) : (
            <CalendarList
              firstDay={1}
              horizontal={true}
              pagingEnabled={true}
              current={moment(selectedDate).format('YYYY-MM-DD')}
              onDayPress={day => {
                let date = new Date(day?.dateString);
                onPressOfNextAndPerviousDate(date);
                setSelectedDate(date);
                setseletedDay(day?.dateString);
              }}
              onMonthChange={day => {
                if (selectedDate) {
                  setSelectedDate(selectedDate);
                  setseletedDay(moment(selectedDate).format('YYYY-MM-DD'));
                  let date = new Date(day?.dateString);
                  setSelectedDate(date);
                } else {
                  let date = new Date(day?.dateString);
                  setSelectedDate(date);
                }
              }}
              markingType="custom"
              markedDates={{
                [seletedDay]: {
                  customStyles: {
                    container: {
                      backgroundColor: colors.themePurple,
                      borderRadius: Matrics.mvs(10),
                      justifyContent: 'center',
                      alignItems: 'center',
                    },
                    text: {
                      color: 'white',
                      fontWeight: '700',
                    },
                  },
                },
              }}
              calendarWidth={width}
              calendarHeight={Matrics.vs(250)}
              theme={{
                backgroundColor: colors.lightGreyishBlue,
                calendarBackground: colors.lightGreyishBlue,
                textSectionTitleColor: 'black',
                textSectionTitleDisabledColor: 'black',
                dayTextColor: 'black',
                textDisabledColor: '#d9e1e8',
                todayTextColor: 'black',
                disabledArrowColor: '#d9e1e8',
                textDayFontFamily: Fonts.MEDIUM,
                textMonthFontFamily: Fonts.MEDIUM,
                textDayFontWeight: '400',
                textDayHeaderFontWeight: '400',
                textDayFontSize: 13,
                textMonthFontSize: 13,
                textDayHeaderFontSize: 11,
                arrowColor: 'white',
                'stylesheet.calendar.header': {
                  header: {
                    height: 0,
                    opacity: 0,
                  },
                },
              }}
            />
          )}
        </View>
        <TouchableOpacity
          style={styles.dropDwonIcon}
          onPress={() => {
            setShowMore(!showMore);
            focus
              ? LayoutAnimation.configureNext(
                LayoutAnimation.Presets.easeInEaseOut,
              )
              : null;
          }}>
          {showMore ? <Icons.ShowMore /> : <Icons.ShowLess />}
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  mainContainer: {
    backgroundColor: colors.lightGreyishBlue,
    overflow: 'hidden',
    paddingBottom: Matrics.vs(2),
  },
  upperContainer: {
    backgroundColor: colors.lightGreyishBlue,
    borderBottomWidth: 0.3,
    borderBottomColor: '#E5E5E5',
    paddingBottom: 5,
    elevation: 2,
    borderBottomRightRadius: 15,
    borderBottomLeftRadius: 15,
    shadowOffset: { width: 0, height: 0 },
    shadowColor: '#171717',
    shadowOpacity: 0.1,
    shadowRadius: 3,
  },
  customHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 20,
    paddingHorizontal: Matrics.s(15),
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
    paddingVertical: Matrics.vs(8),
    paddingHorizontal: Matrics.s(10),
    marginTop: Matrics.vs(10),

  },
  highlighetdDateNumberStyle: {
    fontSize: Matrics.mvs(14),
    backgroundColor: '#760FB1',
    borderRadius: Matrics.mvs(8),
    color: 'white',
    overflow: 'hidden',
    fontFamily: Fonts.REGULAR,
    fontWeight: '400'
  },
  leftRightContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
    paddingHorizontal: Matrics.s(18),
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  monthYearStyle: {
    fontSize: Matrics.mvs(14),
    fontFamily: Fonts.BOLD,
    color: colors.black,
  },
  dropDwonIcon: {
    opacity: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingBottom: Matrics.vs(5),
  },
  arrowContainer: {
    height: Matrics.mvs(20), width: Matrics.mvs(30), justifyContent: 'center', alignItems: "center",
  }
});

export default DietHeader;
