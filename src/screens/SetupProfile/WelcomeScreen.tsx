import {Image, Text, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';

import {
  AppStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import {WelcomeScreenStyle as styles} from './styles';
import images from '../../constants/images';
import Button from '../../components/atoms/Button';
import {Matrics} from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';

type WelcomeScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'WelcomeScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const WelcomeScreen: React.FC<WelcomeScreenProps> = ({navigation}) => {
  // const {setUserData} = useApp();
  const insets = useSafeAreaInsets();
  return (
    <SafeAreaView style={styles.container}>
      <MyStatusbar translucent={true} />
      <Image
        source={images.MysteryBox}
        resizeMode="contain"
        style={styles.image}
      />
      <View style={styles.textCont}>
        <Text style={styles.titleText}>{'Almost done!'}</Text>
        <Text style={styles.descText}>
          {'We want to know you better, to curate a plan.'}
        </Text>
      </View>
      <Button
        title={`Let’s Begin`}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
        onPress={() => {
          // navigation.navigate('DrawerScreen');
          navigation.navigate('QuestionOneScreen');
        }}
      />
    </SafeAreaView>
  );
};

export default WelcomeScreen;
