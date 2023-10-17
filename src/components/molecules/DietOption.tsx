import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';

type DietOptionItem = {
  id: number;
  title: 'Roti' | 'Poha' | 'Milk' | 'Fruit';
  description: string;
  calorieValue: number;
};

const DietOption: React.FC = () => {
  console.log("hey");
  
  const options: DietOptionItem[] = [
    {
      id: 1,
      title: 'Roti',
      description: 'Quantity| Micronutrients',
      calorieValue: 120,
    },
    {
      id: 2,
      title: 'Poha',
      description: 'Quantity| Micronutrients',
      calorieValue: 120,
    },
    {
      id: 3,
      title: 'Milk',
      description: 'Quantity| Micronutrients',
      calorieValue: 120,
    },
    {
      id: 4,
      title: 'Fruit',
      description: 'Quantity| Micronutrients',
      calorieValue: 120,
    },
  ];
  const renderDietOptionItem = (item: DietOptionItem, index: number) => {
    const isRoti = item.title === 'Roti';
    return (
      <View style={styles.OptionitemContainer} key={index}>
        <View style={styles.leftContainer}>
          {isRoti ? (
            <Icons.Success height={28} width={28} />
          ) : (
            <Icons.Ellipse height={28} width={28} />
          )}
          <View style={styles.titleDescription}>
            <Text style={styles.title}>{item.title}</Text>
            <Text style={styles.description}>{item.description}</Text>
          </View>
        </View>
        <View style={{flexDirection: 'row'}}>
          <Text style={styles.value}>{item.calorieValue}cal</Text>
          <Icons.ThreeDot />
        </View>
      </View>
    );
  };

  return (
    <View>
      {options.map(renderDietOptionItem)}
      <View style={styles.belowContainer}>
        <Text>1.Tip one goes here</Text>
        <Text>2.Tip two goes here</Text>
        <Text>3.Tip three goes here</Text>
      </View>
    </View>
  );
};

export default DietOption;

const styles = StyleSheet.create({
  OptionitemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    //alignItems: 'center',
    marginVertical: 5,
    marginHorizontal: 5,
  },
  leftContainer: {
    flexDirection: 'row',
  },
  titleDescription: {
    marginLeft: 10,
  },
  title: {
    fontSize: 15,
    //fontWeight: 'bold',
    color: colors.black,
  },
  description: {
    fontSize: 14,
    color: '#444444',
  },
  value: {
    fontSize: 15,
    //fontWeight: 'bold',
    color: colors.black,
  },
  belowContainer: {
    borderWidth: 0.5,
    borderColor: colors.darkGray,
    borderRadius: 15,
    // paddingVertical: 15,
    // paddingLeft: 15,
    padding: 15,
    marginVertical: 6,
    marginHorizontal: 4,
  },
});
