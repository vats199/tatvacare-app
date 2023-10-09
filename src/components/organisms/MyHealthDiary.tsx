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
  //DYNAMIC DATA FROM API //

  // const renderHealthDiaryItem = (item: any, idx: number) => {
  //     return (
  //         <TouchableOpacity
  //             key={idx.toString()}
  //             style={styles.healthDiaryItemContainer}
  //             // onPress={onPress}
  //             activeOpacity={0.7}
  //         >
  //             <Image resizeMode='contain' source={{ uri: item?.image_url || '' }} style={styles.imageStyle} />
  //             {/* {renderIcon(title)} */}
  //             <View style={styles.textContainer}>
  //                 <Text style={styles.text}>{item?.goal_name || '-'}</Text>
  //                 {item?.achieved_value ? <Text style={styles.subText}>{item?.achieved_value || 0} of {item?.goal_value || 0} {item?.goal_measurement}</Text> : null}
  //             </View>
  //         </TouchableOpacity>
  //     )
  // }

  // return (
  //     <View style={styles.container}>
  //         <Text style={styles.title}>My Health Diary</Text>
  //         {data?.map((item: any, idx: number) => { return renderHealthDiaryItem(item, idx) })}

  //     </View>
  // )

  // const myHealthDiaryItems = ['Diet', 'Medication', 'Exercise'];
  // const goals = healthInsights?.goals?.filter((goal: any) =>
  //   myHealthDiaryItems.includes(goal.goal_name),
  // );
  const dietObj = data?.find((goalObj: any) => goalObj.goal_name === 'Diet');
  const medicineObj = data?.find(
    (goalObj: any) => goalObj.goal_name === 'Medication',
  );
  const exeObj = data?.find((goalObj: any) => goalObj.goal_name === 'Exercise');

  //STATIC DATA //
  const options: HealthDiaryItem[] = [
    {
      title: 'Medicines',
      description:
        medicineObj?.achieved_value > 0
          ? `${medicineObj.achieved_value}/${medicineObj.goal_value}`
          : 'Log and track your medicines!',
      onPress: () => onPressMedicine(data),
    },
    {
      title: 'Diet',
      description:
        dietObj?.achieved_value > 0
          ? `${dietObj.achieved_value}/${dietObj.goal_value}`
          : 'Log and track your calories!',
      onPress: onPressDiet,
    },
    {
      title: 'Exercises',
      description:
        exeObj?.achieved_value > 0
          ? `${exeObj.achieved_value}/${exeObj.goal_value}`
          : 'Log your exercise details!',
      onPress: () => onPressExercise(data),
    },
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
