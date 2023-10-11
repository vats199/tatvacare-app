import {Image, Text, View} from 'react-native';
import React from 'react';
import {CommonActions, CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';

import {
  AppStackParamList,
  AuthStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import {useApp} from '../../context/app.context';
import {WelcomeScreenStyle as styles} from './styles';
import images from '../../constants/images';
import Button from '../../components/atoms/Button';
import {Constants, Matrics} from '../../constants';
import AuthHeader from '../../components/molecules/AuthHeader';

type QuestionOneScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'QuestionOneScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const QuestionOneScreen: React.FC<QuestionOneScreenProps> = ({
  navigation,
  route,
}) => {
  const {setUserData} = useApp();
  const insets = useSafeAreaInsets();
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.container}>
        <AuthHeader
          onPressBack={() => {
            navigation.goBack();
          }}
        />
      </View>
      <Button
        title={`Next`}
        type={Constants.BUTTON_TYPE.SECONDARY}
        disabled={true}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
      />
    </SafeAreaView>
  );
};

export default QuestionOneScreen;
