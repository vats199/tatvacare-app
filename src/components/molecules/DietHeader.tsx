import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  LayoutAnimation,
  Platform,
} from 'react-native';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { TouchableOpacity } from 'react-native';
import { Fonts, Matrics } from '../../constants';
import { useIsFocused } from '@react-navigation/native';
import CommonCalendar from './CommonCalendar';

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

  const [selectedDate, setSelectedDate] = useState(new Date());

  const onPressDay = (date: Date) => {
    onPressOfNextAndPerviousDate(date)
  }

  return (
    <View style={styles.mainContainer}>
      <View style={styles.upperContainer}>
        <View style={styles.customHeader}>
          <TouchableOpacity hitSlop={8} onPress={onPressBack}>
            <Icons.backArrow />
          </TouchableOpacity>
          <Text style={styles.customHeaderText}> {title}</Text>
        </View>
        <CommonCalendar
          selectedDate={selectedDate}
          onPressDay={onPressDay}
          setSelectedDate={setSelectedDate}
        />
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
    paddingHorizontal: Matrics.s(18),
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
});

export default DietHeader;
