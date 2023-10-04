import {
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

  const getValue = (val: any) => {
    if (val || (val == 0 && val !== '')) {
      return parseInt(val);
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
        <View style={styles.row}>
          <Image
            resizeMode="contain"
            style={styles.imageStyle}
            source={{uri: item?.image_url || ''}}
          />
          <Text style={styles.hiItemTitle}>{item?.reading_name || '-'}</Text>
        </View>
        <View style={styles.valuesRow}>
          <Text style={styles.hiItemValue}>
            {getValue(item?.reading_value)}
          </Text>
          <Text style={styles.hiItemKey}>{item?.keys}</Text>
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
        <View style={styles.row}>
          <Image
            resizeMode="contain"
            style={styles.imageStyle}
            source={{uri: item?.image_url || ''}}
          />
          <Text style={styles.hiItemTitle}>{item?.goal_name || '-'}</Text>
        </View>
        <View style={styles.valuesRow}>
          <Text style={styles.hiItemValue}>
            {getValue(item?.achieved_value)} / {getValue(item?.goal_value)}
          </Text>
          <Text style={styles.hiItemKey}>{item?.goal_measurement}</Text>
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
    minWidth: 150,
    minHeight: 86,
    marginRight: 10,
  },
  hiItemContainerBottom: {
    marginTop: 5,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    minWidth: 150,
    marginRight: 10,
    minHeight: 86,
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
    fontWeight: '700',
    fontSize: 20,
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
