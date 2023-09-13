import {StyleSheet, ScrollView, View} from 'react-native';
import React from 'react';
import DietExactTime from '../molecules/DietExactTime';

type DietTimeItem = {
  title: 'Breakfast' | 'Lunch' | 'Snacks' | 'Dinner';
  description: string;
};

const DietTime: React.FC = () => {
  const options: DietTimeItem[] = [
    {
      title: 'Breakfast',
      description: 'Breakfast is a passport to morning',
    },
    {
      title: 'Lunch',
      description: 'Lunch is a passport to noon',
    },
    {
      title: 'Snacks',
      description: 'Snacks is a passport to evening',
    },
    {
      title: 'Dinner',
      description: 'Dinner is a passport to better sleep',
    },
  ];

  const renderDietTimeItem = (item: DietTimeItem, index: number) => {
    return (
      <DietExactTime
        key={index}
        title={item.title}
        message={item.description}
      />
    );
  };

  return (
    <ScrollView style={styles.container}>
      {options.map(renderDietTimeItem)}
    </ScrollView>
  );
};

export default DietTime;

const styles = StyleSheet.create({
  container: {
    marginTop: 10,
  },
});
