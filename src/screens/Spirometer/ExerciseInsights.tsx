import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import InsightsScreen from '../../components/molecules/InsightsScreen';
import {HealthInsightsList} from './HealthInsightsScreen';

const ExerciseInsights = () => {
  return <InsightsScreen data={HealthInsightsList} />;
};

export default ExerciseInsights;

const styles = StyleSheet.create({});
