import React, {useState, useEffect} from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
;
import {StyleSheet, Text, View} from 'react-native';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';

import CalorieConsumer from '../../components/molecules/CalorieConsumer';
import DietHeader from '../../components/molecules/DietHeader';
import DietTime from '../../components/organisms/DietTime';
import {colors} from '../../constants/colors';
import {
  AppStackParamList,
  BottomTabParamList,
  HomeStackParamList
} from '../../interface/Navigation.interface';
import {StackScreenProps} from '@react-navigation/stack';
import Diet from '../../api/diet';

type DietScreenProps = CompositeScreenProps<
  StackScreenProps<HomeStackParamList, 'DietScreen'>,
  CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
  >
>;

const DietScreen: React.FC<DietScreenProps> = ({navigation, route}) => {
  const title = route.params?.dietData;
  const [dietOption, setDietOption] = useState<boolean>(false);

useEffect(()=>{
getData();
},[]);

  useEffect(() => {
    if (title) {
      setDietOption(true);
    } else {
      setDietOption(false);
    }
  }, [title]);

  const getData = async () => {
    const diet = await Diet.getDietPlan({date:"2023-10-01"});
    console.log(diet);
    
  };

  const onPressBack = () => {
    navigation.goBack();
  };
  const onPressPlus = () => {
    navigation.navigate('AddDiet');
  };

  return (
    <View style={{flex: 1}}>
      <DietHeader onPressBack={onPressBack} />
      <View style={styles.belowContainer}>
        <CalorieConsumer />
        <DietTime onPressPlus={onPressPlus} dietOption={dietOption} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  belowContainer: {
    flex: 1,
    paddingHorizontal: 15,
    backgroundColor: colors.veryLightGreyishBlue,
    paddingBottom: 30,
  },
});

export default DietScreen;
