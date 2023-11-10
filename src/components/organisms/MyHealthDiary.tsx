import {
  DeviceEventEmitter,
  Image,
  NativeModules,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useEffect} from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';
import {CircularProgress} from 'react-native-circular-progress';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {trackEvent} from '../../helpers/TrackEvent';

type MyHealthDiaryProps = {
  onPressMedicine: (data: any) => void;
  onPressDiet: (data: any) => void;
  onPressExercise: (data: any) => void;
  onPressDevices: () => void;
  onPressMyIncidents: () => void;
  data: any;
  hideIncident: boolean;
};
type HealthDiaryItem = {
  title: 'Medicines' | 'Diet' | 'Exercises' | 'Devices' | 'My Incidents';
  description: string;
  onPress: () => void;
};

const MyHealthDiary: React.FC<MyHealthDiaryProps> = ({
  onPressDevices,
  onPressDiet,
  onPressExercise,
  onPressMedicine,
  onPressMyIncidents,
  data,
  hideIncident,
}) => {
  const dietObj = data?.find((goalObj: any) => goalObj.goal_name === 'Diet');
  const medicineObj = data?.find(
    (goalObj: any) => goalObj.goal_name === 'Medication',
  );
  const exeObj = data?.find((goalObj: any) => goalObj.goal_name === 'Exercise');

  const options: HealthDiaryItem[] = [
    {
      title: 'Devices',
      description: 'Connect and monitor your condition!',
      onPress: () => {
        if (Platform.OS == 'ios') {
          trackEvent('CLICKED_HEALTH_DIARY', {
            diary_item: 'device',
            diary_item_completion: null,
          });
        }
        onPressDevices();
      },
    },
  ];

  if (
    (Platform.OS === 'ios' && !NativeModules.RNShare.hide_incident_survey) ||
    !hideIncident ||
    (Platform.OS === 'android' && !global.isHideIncident)
  ) {
    options.unshift({
      title: 'My Incidents',
      description: 'Log your exercise details!',
      onPress: () => {
        if (Platform.OS == 'ios') {
          trackEvent('CLICKED_HEALTH_DIARY', {
            diary_item: 'incident',
            diary_item_completion: null,
          });
        }
        onPressMyIncidents();
      },
    });
  }

  if (exeObj) {
    options.unshift({
      title: 'Exercises',
      description:
        exeObj?.goal_value > 0
          ? `${parseInt(exeObj?.todays_achieved_value)}/${parseInt(
              exeObj?.goal_value,
            )} minutes`
          : 'Log your exercise details!',
      onPress: () => {
        if (Platform.OS == 'ios') {
          trackEvent('CLICKED_HEALTH_DIARY', {
            diary_item: 'exercises',
            diary_item_completion: `${parseInt(
              exeObj?.todays_achieved_value,
            )}/${parseInt(exeObj?.goal_value)}`,
          });
        }
        onPressExercise(data);
      },
    });
  }

  if (dietObj) {
    options.unshift({
      title: 'Diet',
      description:
        dietObj?.goal_value > 0
          ? `${parseInt(dietObj?.todays_achieved_value)}/${parseInt(
              dietObj?.goal_value,
            )} cal`
          : 'Log and track your calories!',
      onPress: () => {
        if (Platform.OS == 'ios') {
          trackEvent('CLICKED_HEALTH_DIARY', {
            diary_item: 'diet',
            diary_item_completion: `${parseInt(
              dietObj?.todays_achieved_value,
            )}/${parseInt(dietObj?.goal_value)}`,
          });
        }
        onPressDiet(data);
      },
    });
  }

  if (medicineObj) {
    options.unshift({
      title: 'Medicines',
      description:
        medicineObj?.goal_value > 0
          ? `${parseInt(medicineObj?.todays_achieved_value)}/${parseInt(
              medicineObj?.goal_value,
            )} doses`
          : 'Log and track your medicines!',
      onPress: () => {
        if (Platform.OS == 'ios') {
          trackEvent('CLICKED_HEALTH_DIARY', {
            diary_item: 'medicines',
            diary_item_completion: `${parseInt(
              medicineObj?.todays_achieved_value,
            )}/${parseInt(medicineObj?.goal_value)}`,
          });
        }

        onPressMedicine(data);
      },
    });
  }

  const renderIcon = (
    title: 'Medicines' | 'Diet' | 'Exercises' | 'Devices' | 'My Incidents',
  ) => {
    switch (title) {
      case 'Medicines':
        return medicineObj?.todays_achieved_value / medicineObj?.goal_value >=
          0.75 ? (
          <CircularProgress
            size={38}
            width={2}
            fill={
              (medicineObj?.todays_achieved_value / medicineObj?.goal_value) *
              100
            }
            rotation={0}
            backgroundWidth={1}
            tintColor={colors.green}
            backgroundColor={colors.greenLineBg}
            childrenContainerStyle={{backgroundColor: colors.greenBg}}>
            {() => <Icons.MedicineGreen />}
          </CircularProgress>
        ) : medicineObj?.todays_achieved_value &&
          medicineObj?.todays_achieved_value / medicineObj?.goal_value < 0.75 &&
          medicineObj?.todays_achieved_value / medicineObj?.goal_value > 0 ? (
          <CircularProgress
            size={38}
            width={2}
            fill={
              (medicineObj?.todays_achieved_value / medicineObj?.goal_value) *
              100
            }
            rotation={0}
            backgroundWidth={1}
            tintColor={colors.orange}
            backgroundColor={colors.orangeLineBg}
            childrenContainerStyle={{backgroundColor: colors.orangeBg}}>
            {() => <Icons.MedicineOmbre />}
          </CircularProgress>
        ) : (
          <Icons.HealthDiaryMedicines />
        );

      case 'Diet':
        return dietObj?.todays_achieved_value / dietObj?.goal_value >= 0.75 ? (
          <CircularProgress
            size={38}
            width={2}
            fill={(dietObj?.todays_achieved_value / dietObj?.goal_value) * 100}
            rotation={0}
            backgroundWidth={1}
            tintColor={colors.green}
            backgroundColor={colors.greenLineBg}
            childrenContainerStyle={{backgroundColor: colors.greenBg}}>
            {() => <Icons.DietGreen />}
          </CircularProgress>
        ) : dietObj?.todays_achieved_value &&
          dietObj?.todays_achieved_value / dietObj?.goal_value < 0.75 &&
          dietObj?.todays_achieved_value / dietObj?.goal_value > 0 ? (
          <CircularProgress
            size={38}
            width={2}
            fill={(dietObj?.todays_achieved_value / dietObj?.goal_value) * 100}
            rotation={0}
            backgroundWidth={1}
            tintColor={colors.orange}
            backgroundColor={colors.orangeLineBg}
            childrenContainerStyle={{backgroundColor: colors.orangeBg}}>
            {() => <Icons.DietOmbre />}
          </CircularProgress>
        ) : (
          <Icons.HealthDiaryDiet />
        );
      case 'Exercises':
        return exeObj?.todays_achieved_value / exeObj?.goal_value >= 0.75 ? (
          <CircularProgress
            size={38}
            width={2}
            fill={(exeObj?.todays_achieved_value / exeObj?.goal_value) * 100}
            rotation={0}
            backgroundWidth={1}
            tintColor={colors.green}
            backgroundColor={colors.greenLineBg}
            childrenContainerStyle={{backgroundColor: colors.greenBg}}>
            {() => <Icons.ExerciseGreen />}
          </CircularProgress>
        ) : exeObj?.todays_achieved_value &&
          exeObj?.todays_achieved_value / exeObj?.goal_value < 0.75 &&
          exeObj?.todays_achieved_value / exeObj?.goal_value > 0 ? (
          <CircularProgress
            size={38}
            width={2}
            fill={(exeObj?.todays_achieved_value / exeObj?.goal_value) * 100}
            rotation={0}
            backgroundWidth={1}
            tintColor={colors.orange}
            backgroundColor={colors.orangeLineBg}
            childrenContainerStyle={{backgroundColor: colors.orangeBg}}>
            {() => <Icons.ExerciseOmbre />}
          </CircularProgress>
        ) : (
          <Icons.HealthDiaryExercise />
        );
      case 'Devices':
        return <Icons.HealthDiaryDevices />;
      case 'My Incidents':
        return <Icons.HealthDiaryMyIncidents />;
    }
  };

  const renderHealthDiaryItem = (item: HealthDiaryItem, index: number) => {
    const {title, description, onPress} = item;
    return (
      <TouchableOpacity
        key={index.toString()}
        style={styles.healthDiaryItemContainer}
        onPress={onPress}
        activeOpacity={0.7}>
        {renderIcon(title)}
        <View style={styles.textContainer}>
          <Text style={styles.text}>{title}</Text>
          <Text style={styles.subText}>{description}</Text>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>My Health Diary</Text>
      {options.map(renderHealthDiaryItem)}
      {/* {data?.map((item: any, idx: number) => { return renderHealthDiaryItem(item, idx) })} */}
    </View>
  );
};

export default MyHealthDiary;

const styles = StyleSheet.create({
  container: {
    marginTop: 24,
    marginHorizontal: 16,
  },
  title: {
    fontSize: 16,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.black,
    marginBottom: 9,
  },
  healthDiaryItemContainer: {
    marginVertical: 6,
    padding: 10,
    backgroundColor: colors.white,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    minHeight: 70,
    shadowColor: '#212121',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
  },
  textContainer: {
    marginLeft: 10,
    minHeight: 38,
  },
  text: {
    fontSize: 16,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.labelDarkGray,
    lineHeight: 20,
  },
  subText: {
    fontSize: 12,
    fontFamily: 'SFProDisplay-Semibold',
    lineHeight: 16,
    color: colors.subTitleLightGray,
  },
  imageStyle: {
    height: 40,
    width: 40,
  },
});
