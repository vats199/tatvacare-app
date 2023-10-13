import {
  Dimensions,
  FlatList,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useEffect} from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import {getEncryptedText} from '../../api/base';

type MyHealthInsightsProps = {
  data: any;
  onPressReading: (filteredData: any, firstRow: any) => void;
  onPressGoal: (filteredData: any, firstRow: any) => void;
};

const MyHealthInsights: React.FC<MyHealthInsightsProps> = ({
  data,
  onPressReading,
  onPressGoal,
}) => {
  const myHealthDiaryItems: string[] = ['Diet', 'Medication', 'Exercise'];

  const goals: any[] = data?.goals;
  const readings: any[] = data?.readings;

  const getValue = (val: string) => {
    let num = parseFloat(val);
    if (num) {
      return num.toLocaleString('en-IN', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 2,
      });
    } else {
      return '-';
    }
  };

  const renderReadings = ({item, index}: {item: any; index: number}) => {
    return (
      <TouchableOpacity
        key={index.toString()}
        style={styles.hiItemContainerBottom}
        onPress={() => onPressReading(data?.readings, item.keys)}>
        <View style={[styles.row, styles.flex]}>
          <Image
            resizeMode="contain"
            style={styles.imageStyle}
            source={{uri: item?.image_url || ''}}
          />
          <Text style={styles.hiItemTitle}>{item?.reading_name || '-'}</Text>
        </View>
        <View style={styles.valuesRow}>
          <Text style={styles.hiItemValue}>
            {getValue(item?.keys == 'bloodpressure' ? item?.reading_value_data?.diastolic : item?.keys == 'blood_glucose' ? item?.reading_value_data?.fast  :  item?.keys == 'fibro_scan' ?  item?.reading_value_data?.cap :   item?.reading_value) || '-'}
          </Text>
          <Text style={styles.hiItemKey}>{item?.measurements}</Text>
        </View>
      </TouchableOpacity>
    );
  };

  const renderGoals = ({item, index}: {item: any; index: number}) => {
    return (
      <TouchableOpacity
        key={index.toString()}
        style={styles.hiItemContainerTop}
        onPress={() => onPressGoal(data?.goals, item.keys)}>
        <View style={[styles.row, styles.flex]}>
          <Image
            resizeMode="contain"
            style={styles.imageStyle}
            source={{uri: item?.image_url || ''}}
          />
          <Text style={styles.hiItemTitle}>{item?.goal_name || '-'}</Text>
        </View>
        <View style={styles.valuesRow}>
          <Text style={styles.hiItemValue}>
            {item?.todays_achieved_value || '0'}
          </Text>
          <Text style={styles.hiItemKey}>
            / {item?.goal_value} {item?.goal_measurement}
          </Text>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>My Health Insights</Text>
      <View style={styles.scrollContainer}>
        <FlatList
          data={readings}
          keyExtractor={(_item, index) => index.toString()}
          renderItem={renderReadings}
          horizontal
          showsHorizontalScrollIndicator={false}
          nestedScrollEnabled={false}
          contentContainerStyle={styles.scrollContainer}
        />
        <FlatList
          data={goals?.filter(
            goal => !myHealthDiaryItems.includes(goal.goal_name),
          )}
          keyExtractor={(_item, index) => index.toString()}
          renderItem={renderGoals}
          horizontal
          showsHorizontalScrollIndicator={false}
          nestedScrollEnabled={false}
          contentContainerStyle={styles.scrollContainer}
        />
      </View>
    </View>
  );
};

export default MyHealthInsights;

const styles = StyleSheet.create({
  container: {
    marginVertical: 10,
  },
  flex: {
    flex: 1,
  },
  title: {
    color: colors.black,
    fontWeight: '700',
    fontSize: 16,
  },
  scrollContainer: {
    paddingVertical: 5,
  },
  hiItemContainerTop: {
    marginBottom: 5,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    // minWidth: 150,
    width: Dimensions.get('screen').width * 0.45,
    minHeight: 86,
    marginRight: 10,
    shadowColor: '#2121210D',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.1,
    shadowRadius: 1.41,
  },
  hiItemContainerBottom: {
    marginTop: 5,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    // minWidth: 150,
    width: Dimensions.get('screen').width * 0.45,
    marginRight: 10,
    minHeight: 86,
    shadowColor: '#2121210D',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.1,
    shadowRadius: 1.41,
  },
  columnContainer: {
    marginRight: 10,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  hiItemTitle: {
    flex: 1,
    flexShrink: 1,
    color: colors.black,
    fontWeight: '700',
    fontSize: 12,
    marginLeft: 5,
  },
  valuesRow: {
    flexDirection: 'row',
    alignItems: 'baseline',
    marginTop: 10,
    gap: 5,
  },
  hiItemValue: {
    color: colors.black,
    flexShrink: 1,
    fontWeight: '700',
    fontSize: 18,
  },
  hiItemKey: {
    color: colors.secondaryLabel,
    fontWeight: '400',
    fontSize: 12,
  },
  imageStyle: {
    height: 25,
    width: 25,
  },
});
