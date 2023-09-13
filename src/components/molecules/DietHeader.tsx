import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import CalendarStrip from 'react-native-calendar-strip';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';

type DietHeaderProps = {
  onPressBack: () => void;
};

const DietHeader: React.FC<DietHeaderProps> = ({onPressBack}) => {
  return (
    <View style={styles.upperContainer}>
      <View style={styles.customHeader}>
        <Icons.ChevronBack onPress={onPressBack} />
        <Text style={styles.customHeaderText}> Diet</Text>
      </View>
      <CalendarStrip
        scrollable
        style={{height: 100, paddingTop: 20, paddingBottom: 10}}
        calendarHeaderContainerStyle={{marginBottom: 10}}
        calendarColor={colors.lightGreyishBlue}
        calendarHeaderStyle={{
          color: colors.black,
          position: 'absolute',
          left: 40,
        }}
        dateNumberStyle={{color: colors.black}}
        dateNameStyle={{color: colors.black}}
        iconContainer={{flex: 0.1}}
      />
    </View>
  );
};

export default DietHeader;

const styles = StyleSheet.create({
  upperContainer: {
    backgroundColor: colors.lightGreyishBlue,
    borderBottomWidth: 0.3,
    borderBottomColor: '#E5E5E5',
    elevation: 0.2,
    paddingTop: 30,
  },
  customHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginLeft: 15,
  },
  customHeaderText: {
    fontSize: 22,
    color: colors.black,
    marginLeft: 10,
  },
});
