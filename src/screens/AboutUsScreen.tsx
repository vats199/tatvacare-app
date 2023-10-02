import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {DrawerScreenProps} from '@react-navigation/drawer';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {colors} from '../constants/colors';
import {SafeAreaView} from 'react-native-safe-area-context';
import {StackScreenProps} from '@react-navigation/stack';

type AboutUsScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'AboutUsScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const AboutUsScreen: React.FC<AboutUsScreenProps> = ({navigation, route}) => {
  return (
    <SafeAreaView edges={['bottom', 'top']} style={styles.screen}>
      <View style={styles.container}>
        <Text style={{color: 'black'}}>AboutUsScreen</Text>
      </View>
    </SafeAreaView>
  );
};

export default AboutUsScreen;

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: 'orange',
  },
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
});
