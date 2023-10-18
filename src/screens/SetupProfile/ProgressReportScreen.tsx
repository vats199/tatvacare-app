import {Text, View} from 'react-native';
import React, {useState} from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';

import {
  AppStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import {QuestionOneScreenStyle as styles} from './styles';
import Button from '../../components/atoms/Button';
import {Constants, Matrics} from '../../constants';
import AuthHeader from '../../components/molecules/AuthHeader';
import SetupProfileHeading from '../../components/atoms/SetupProfileHeading';
import InputField from '../../components/atoms/AnimatedInputField';
import {colors} from '../../constants/colors';
import AnimatedDatePicker from '../../components/atoms/AnimatedDatePicker';
import {TouchableOpacity} from 'react-native';
import {Icons} from '../../constants/icons';

type ProgressScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'ProgressReportScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const ProgressReportScreen: React.FC<ProgressScreenProps> = ({
  navigation,
  route,
}) => {
  const insets = useSafeAreaInsets();

  // ==================== state ====================//

  // ==================== function ====================//
  const onPressNext = () => {
    navigation.navigate('DrawerScreen');
  };

  return (
    <SafeAreaView style={styles.container} edges={['bottom']}>
      <Button
        title={'Explore'}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
        onPress={() => onPressNext()}
      />
    </SafeAreaView>
  );
};

export default ProgressReportScreen;
