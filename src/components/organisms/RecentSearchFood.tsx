import { StyleSheet, Text, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import RecentDietItem from '../molecules/RecentFoodItem';

type RecentSerachDietProps = {
  onPressPlus: () => void;
};

type RecentSearchItem = {
  id: number;
  title: 'Roti' | 'Poha' | 'Milk' | 'Fruit';
  description: string;
  calorieValue: number;
};

const RecentSearchDiet: React.FC<RecentSerachDietProps> = ({ onPressPlus }) => {
  const options: RecentSearchItem[] = [
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

  const renderRecentSearchItem = (item: RecentSearchItem, index: number) => {
    return (
      <RecentDietItem
        key={index}
        title={item.title}
        message={item.description}
        calorieValue={item.calorieValue}
        onPressPlus={onPressPlus}
      />
    );
  };

  return (
    <View>
      <Text style={styles.text}>Recent Search</Text>
      {options.map(renderRecentSearchItem)}
    </View>
  );
};

export default RecentSearchDiet;

const styles = StyleSheet.create({
  text: {
    fontSize: 17,
    fontWeight: 'bold',
    color: colors.black,
    marginBottom: 5,
  },
});
