import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';

type MyHealthDiaryProps = {
  onPressMedicine: (data: any) => void;
  onPressDiet: () => void;
  onPressExercise: (data: any) => void;
  onPressDevices: () => void;
  onPressMyIncidents: () => void;
  data: any;
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
      onPress: onPressDevices,
    },
    {
      title: 'My Incidents',
      description: 'Log your exercise details!',
      onPress: onPressMyIncidents,
    },
  ];

  if (exeObj) {
    options.unshift({
      title: 'Exercises',
      description:
        exeObj?.achieved_value > 0
          ? `${parseInt(exeObj.achieved_value)}/${parseInt(
              exeObj.goal_value,
            )} minutes`
          : 'Log your exercise details!',
      onPress: () => onPressExercise(data),
    });
  }

  if (dietObj) {
    options.unshift({
      title: 'Diet',
      description:
        dietObj?.achieved_value > 0
          ? `${parseInt(dietObj.achieved_value)}/${parseInt(
              dietObj.goal_value,
            )} cal`
          : 'Log and track your calories!',
      onPress: onPressDiet,
    });
  }

  if (medicineObj) {
    options.unshift({
      title: 'Medicines',
      description:
        medicineObj?.achieved_value > 0
          ? `${parseInt(medicineObj.achieved_value)}/${parseInt(
              medicineObj.goal_value,
            )} doses`
          : 'Log and track your medicines!',
      onPress: () => onPressMedicine(data),
    });
  }

  const renderIcon = (
    title: 'Medicines' | 'Diet' | 'Exercises' | 'Devices' | 'My Incidents',
  ) => {
    switch (title) {
      case 'Medicines':
        return medicineObj?.achieved_value / medicineObj?.goal_value > 0.75 ? (
          <Icons.MedicineGreen />
        ) : medicineObj?.achieved_value &&
          medicineObj?.achieved_value / medicineObj?.goal_value < 0.75 &&
          medicineObj?.achieved_value / medicineObj?.goal_value > 0 ? (
          <Icons.MedicineOmbre />
        ) : (
          <Icons.HealthDiaryMedicines />
        );
      case 'Diet':
        return dietObj?.achieved_value / dietObj?.goal_value > 0.75 ? (
          <Icons.DietGreen />
        ) : dietObj?.achieved_value &&
          dietObj?.achieved_value / dietObj?.goal_value < 0.75 &&
          dietObj?.achieved_value / dietObj?.goal_value > 0 ? (
          <Icons.DietOmbre />
        ) : (
          <Icons.HealthDiaryDiet />
        );
      case 'Exercises':
        return exeObj?.achieved_value / exeObj?.goal_value > 0.75 ? (
          <Icons.ExerciseGreen />
        ) : exeObj?.achieved_value &&
          exeObj?.achieved_value / exeObj?.goal_value < 0.75 &&
          exeObj?.achieved_value / exeObj?.goal_value > 0 ? (
          <Icons.ExerciseOmbre />
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
    marginVertical: 10,
  },
  title: {
    fontSize: 16,
    fontWeight: '700',
    color: colors.black,
  },
  healthDiaryItemContainer: {
    marginVertical: 5,
    padding: 10,
    backgroundColor: colors.white,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    minHeight: 70,
    shadowColor: '#2121210D',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.1,
    shadowRadius: 1.41,
  },
  textContainer: {
    marginLeft: 10,
    minHeight: 38,
  },
  text: {
    fontSize: 16,
    fontWeight: '700',
    color: colors.labelDarkGray,
    lineHeight: 20,
  },
  subText: {
    fontSize: 12,
    fontWeight: '300',
    lineHeight: 16,
    color: colors.subTitleLightGray,
  },
  imageStyle: {
    height: 40,
    width: 40,
  },
});
