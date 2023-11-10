import {
  Dimensions,
  FlatList,
  Image,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, { useEffect } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { getEncryptedText } from '../../api/base';
import { trackEvent } from '../../helpers/TrackEvent';

type MyHealthInsightsProps = {
  data: any;
  onPressReading: (filteredData: any, firstRow: any, index: any) => void;
  onPressGoal: (filteredData: any, firstRow: any, index: any) => void;
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
  const getTrackEvnetValue = (
    keys: string,
    reading_value: any,
    reading_value_data: any,
  ) => {
    switch (keys) {
      case 'bloodpressure':
        return JSON.stringify(reading_value_data);

      case 'fibro_scan':
        return JSON.stringify(reading_value_data);
      case 'blood_glucose':
        return JSON.stringify(reading_value_data);
      default:
        return reading_value;
    }
  };

  const getDisplay = (
    keys: string,
    measurements: string,
    reading_value: any,
    reading_value_data: any,
  ) => {
    switch (keys) {
      case 'bloodpressure':
        return (
          <Text>
            <Text style={styles.hiItemValue}>
              {getValue(reading_value_data.systolic)}/
              {getValue(reading_value_data.diastolic)}
            </Text>
            <Text style={styles.hiItemKey}> {measurements}</Text>
          </Text>
        );
      case 'fibro_scan':
        return (
          <Text>
            <Text style={styles.hiItemValue}>
              {getValue(reading_value_data.lsm)}
            </Text>
            <Text style={styles.hiItemKey}> {measurements.split(',')[0]} </Text>
            <Text style={styles.hiItemValue}>
              {getValue(reading_value_data.cap)}
            </Text>
            <Text style={styles.hiItemKey}> {measurements.split(',')[1]}</Text>
          </Text>
        );
      case 'blood_glucose':
        return (
          <Text>
            <Text style={styles.hiItemValue}>
              {getValue(reading_value_data.fast)}
            </Text>
            <Text style={styles.hiItemKey}> {measurements} </Text>
            <Text style={styles.hiItemValue}>
              {getValue(reading_value_data.pp)}
            </Text>
            <Text style={styles.hiItemKey}> {measurements}</Text>
          </Text>
        );
      default:
        return (
          <Text>
            <Text style={styles.hiItemValue}>{getValue(reading_value)}</Text>
            <Text style={styles.hiItemKey}> {measurements}</Text>
          </Text>
        );
    }
  };

  const renderReadings = ({ item, index }: { item: any; index: number }) => {
    return (
      <TouchableOpacity
        key={index.toString()}
        style={styles.hiItemContainerBottom}
        onPress={() => {
          if (Platform.OS == 'ios') {
            trackEvent('CLICKED_HEALTH_INSIGHTS', {
              health_marker_name: item?.reading_name ?? '',
              health_marker_colour: item?.in_range?.icon_color ?? '',
              health_marker_value: getTrackEvnetValue(
                item.keys,
                item.reading_value,
                item.reading_value_data,
              ),
            });
          }
          onPressReading(data?.readings, item.keys, index);
        }}>
        <View style={[styles.row, styles.flex]}>
          <Image
            resizeMode="contain"
            style={styles.imageStyle}
            source={{ uri: item?.image_url || '' }}
            tintColor={item?.in_range?.icon_color}
          />
          <Text style={styles.hiItemTitle}>{item?.reading_name || '-'}</Text>
        </View>
        <View style={styles.valuesRow}>
          {getDisplay(
            item.keys,
            item.measurements,
            item.reading_value,
            item.reading_value_data,
          )}
        </View>
      </TouchableOpacity>
    );
  };

  const renderGoals = ({ item, index }: { item: any; index: number }) => {
    return (
      <TouchableOpacity
        key={index.toString()}
        style={styles.hiItemContainerTop}
        onPress={() => {
          if (Platform.OS == 'ios') {
            trackEvent('CLICKED_HEALTH_INSIGHTS', {
              health_marker_name: item?.goal_name ?? '',
              health_marker_colour: item?.icon_color ?? '',
              health_marker_value: item?.todays_achieved_value,
            });
          }
          onPressGoal(data?.goals, item.keys, index);
        }}>
        <View style={[styles.row, styles.flex]}>
          <Image
            resizeMode="contain"
            style={styles.imageStyle}
            source={{ uri: item?.image_url || '' }}
            tintColor={item?.icon_color}
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
  );
};

export default MyHealthInsights;

const styles = StyleSheet.create({
  container: {
    marginTop: 8,
  },
  flex: {
    flex: 1,
  },
  title: {
    color: colors.black,
    fontFamily: 'SFProDisplay-Bold',
    fontSize: 16,
    paddingTop: 7,
    marginLeft: 16,
  },
  scrollContainer: {
    paddingVertical: 5,
    paddingLeft: 16,
  },
  hiItemContainerTop: {
    marginBottom: 5,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    // minWidth: 150,
    width: Dimensions.get('screen').width * 0.39,
    minHeight: 86,
    marginRight: 10,
    shadowColor: '#212121',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
    elevation: 2
  },
  hiItemContainerBottom: {
    marginTop: 5,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 10,
    paddingTop: 5,
    // minWidth: 150,
    width: Dimensions.get('screen').width * 0.39,
    marginRight: 10,
    minHeight: 86,
    shadowColor: '#212121',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
    elevation: 2
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
    fontFamily: 'SFProDisplay-Bold',
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
    fontFamily: 'SFProDisplay-Bold',
    fontSize: 18,
  },
  hiItemKey: {
    color: colors.secondaryLabel,
    fontFamily: 'SFProDisplay-Semibold',
    fontSize: 12,
  },
  imageStyle: {
    height: 25,
    width: 25,
  },
});
