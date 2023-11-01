import { Dimensions, LayoutAnimation, Platform, StyleSheet, Text, TextStyle, TouchableOpacity, View, ViewStyle } from 'react-native'
import React, { memo, useMemo, useState } from 'react'
import { CalendarProvider, DateData, ExpandableCalendar, ExpandableCalendarProps, LocaleConfig, WeekCalendar, WeekCalendarProps } from 'react-native-calendars';
import moment from 'moment';
import { Fonts, Matrics } from '../../constants';
import { colors } from '../../constants/colors';
import { MarkedDates, Theme } from 'react-native-calendars/src/types';
import { Icons } from '../../constants/icons';
import { useIsFocused } from '@react-navigation/native';

type CommonCalendarProps = {
    selectedDate: Date,
    weekCalendarProps?: WeekCalendarProps,
    expandableCalendarProps?: ExpandableCalendarProps,
    calendarContainerStyle?: ViewStyle,
    onPressDay: (date: Date) => void
    setSelectedDate: React.Dispatch<React.SetStateAction<Date>>,
    containerStyle?: ViewStyle,
    headerTxtContainer?: ViewStyle,
    titleStyle?: TextStyle,
    iconContainerStyle?: ViewStyle,
};

const { width } = Dimensions.get('window');

const CommonCalendar: React.FC<CommonCalendarProps> = ({
    selectedDate,
    weekCalendarProps,
    expandableCalendarProps,
    containerStyle,
    onPressDay,
    setSelectedDate,
    calendarContainerStyle,
    headerTxtContainer,
    titleStyle,
    iconContainerStyle
}) => {

    const focus = useIsFocused();
    const [seletedDay, setseletedDay] = useState(moment(selectedDate).format('YYYY-MM-DD'));
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
            [seletedDay]: {
                customStyles: {
                    container: {
                        backgroundColor: colors.themePurple,
                        borderRadius: Matrics.mvs(12),
                        justifyContent: 'center',
                        alignItems: 'center',
                        height: Matrics.vs(25),
                        width: Matrics.s(35),
                    },
                    text: {
                        color: 'white',
                        fontWeight: '500',
                    },
                },
            },
        };
    }, [seletedDay]);

    const themeStyle: Theme | undefined = {
        backgroundColor: colors.lightGreyishBlue,
        calendarBackground: colors.lightGreyishBlue,
        textSectionTitleColor: 'black',
        textSectionTitleDisabledColor: 'black',
        dayTextColor: 'black',
        textDisabledColor: '#d9e1e8',
        todayTextColor: 'black',
        disabledArrowColor: '#d9e1e8',
        textDayFontFamily: Fonts.MEDIUM,
        textMonthFontFamily: Fonts.BOLD,
        textDayFontWeight: '400',
        textDayHeaderFontWeight: '400',
        textDayFontSize: Matrics.mvs(13),
        textMonthFontSize: Matrics.mvs(14),
        textDayHeaderFontSize: Matrics.mvs(13),
        monthTextColor: colors.black,
        arrowColor: 'white',
    };

    const onDayPress = (date: DateData) => {
        let tempDate = new Date(date?.dateString);
        onPressDay(tempDate)
        setSelectedDate(tempDate);
        setseletedDay(date?.dateString);
    };

    const onChangeMonth = (date: DateData) => {
        let tempDate = new Date(date?.dateString);
        setSelectedDate(tempDate);
    };

    const handleNextWeek = () => {
        const nextWeek = new Date(selectedDate);
        nextWeek.setDate(nextWeek.getDate() + 7);
        setSelectedDate(nextWeek);
        setCalendarKey(calendarKey + 1);
    };

    const handlePreviousWeek = () => {
        const previousWeek = new Date(selectedDate);
        previousWeek.setDate(previousWeek.getDate() - 7);
        setSelectedDate(previousWeek);
        setCalendarKey(calendarKey - 1);
    };

    const handleNextMonth = () => {
        const currentMonnth = new Date(selectedDate);
        var nextMonth = moment(currentMonnth).add(1, 'months');
        setSelectedDate(new Date(nextMonth.toString()));
        setCalendarKey(calendarKey + 1);
    };

    const handlePreviousMonth = () => {
        const currentMonnth = new Date(selectedDate);
        var previousMonth = moment(currentMonnth).subtract(1, 'months');
        setSelectedDate(new Date(previousMonth.toString()))
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

    return (
        <>
            <View style={[styles.container, containerStyle]}>
                <View style={[styles.leftRightContent, headerTxtContainer]}>
                    <Text style={[styles.monthYearStyle, titleStyle]}>
                        {!showMore
                            ? getMonthRangeText(selectedDate)
                            : getMonthText(selectedDate)}
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
                style={[styles.calendarContainer, { height: showMore ? Matrics.vs(250) : Matrics.vs(65), }, calendarContainerStyle]}>
                <CalendarProvider
                    date={moment(selectedDate).format('YYYY-MM-DD')}
                    disabledOpacity={0.6}
                >
                    {!showMore ? (
                        <WeekCalendar
                            firstDay={0}
                            current={moment(selectedDate).format('YYYY-MM-DD')}
                            onDayPress={onDayPress}
                            markingType="custom"
                            markedDates={markedDateStyle}
                            hideDayNames={false}
                            theme={{
                                ...themeStyle,
                                selectedDayBackgroundColor: undefined,
                                selectedDayTextColor: colors.black,
                                textDisabledColor: colors.black,
                            }}
                            style={[styles.removePaddingHorizontal, { marginTop: Matrics.vs(10) }]}
                            {...weekCalendarProps}
                        />
                    ) : (
                        <ExpandableCalendar
                            horizontal
                            hideKnob
                            initialPosition={ExpandableCalendar.positions.OPEN}
                            current={moment(selectedDate).format('YYYY-MM-DD')}
                            onDayPress={onDayPress}
                            disableAllTouchEventsForDisabledDays={true}
                            calendarHeight={Matrics.vs(300)}
                            hideExtraDays={true}
                            onMonthChange={onChangeMonth}
                            markingType="custom"
                            pagingEnabled={true}
                            calendarStyle={styles.removePaddingHorizontal}
                            headerStyle={styles.removePaddingHorizontal}
                            disablePan={true}
                            collapsable={false}
                            theme={{
                                ...themeStyle,
                                selectedDayBackgroundColor: undefined,
                                selectedDayTextColor: colors.black,
                                stylesheet: {
                                    calendar: {
                                        header: {
                                            height: 0,
                                            opacity: 0,
                                        }
                                    }
                                }
                            }}
                            markedDates={markedDateStyle}
                            {...expandableCalendarProps}
                        />
                    )}
                </CalendarProvider>
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
        </>
    )
}

export default memo(CommonCalendar)

const styles = StyleSheet.create({
    removePaddingHorizontal: {
        paddingLeft: 0,
        paddingRight: 0,
    },
    calendarContainer: {
        width: width,
        overflow: 'hidden'
    },
    container: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 10,
        paddingHorizontal: Matrics.s(15),
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
})