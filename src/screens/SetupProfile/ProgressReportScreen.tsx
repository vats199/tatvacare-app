import {Text, View, Image, ImageBackground} from 'react-native';
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
import {Constants, Fonts, Matrics} from '../../constants';
import AuthHeader from '../../components/molecules/AuthHeader';
import SetupProfileHeading from '../../components/atoms/SetupProfileHeading';
import InputField from '../../components/atoms/AnimatedInputField';
import {colors} from '../../constants/colors';
import AnimatedDatePicker from '../../components/atoms/AnimatedDatePicker';
import {TouchableOpacity} from 'react-native';
import {Icons} from '../../constants/icons';
import images from '../../constants/images';
import constants from '../../constants/constants';

type ProgressScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'ProgressReportScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

type RiskTypeProps = {
  key: string;
  heading: string;
  value: string;
  backgroundColor: string;
  textBg: string;
  color: string;
  title: string;
  desc: string;
};

const RiskType: RiskTypeProps[] = [
  {
    key: 'high',
    heading: 'High Risk',
    value: '100',
    backgroundColor: colors.highRiskBg,
    textBg: colors.red,
    color: colors.red,
    title: 'Your Asthma Control Test (ACT) Score is very poor.',
    desc: `Did you know?
    Doing aerobic exercises at least thrice a week for more than 30 minutes can improve ACT score by 26%.`,
  },
  {
    key: 'medium',
    heading: 'Medium Risk',
    value: '50',
    backgroundColor: colors.mediumRisk,
    textBg: colors.yellow,
    color: colors.yellow,
    title: 'Your Asthma Control Test (ACT) Score is poor.',
    desc: `Did you know?
    Doing aerobic exercises at least thrice a week for more than 30 minutes can improve ACT score by 26%.`,
  },
  {
    key: 'low',
    heading: 'Low Risk',
    value: '10',
    backgroundColor: colors.lowRisk,
    textBg: colors.green,
    color: colors.green,
    title: 'Your Asthma Control Test (ACT) Score is poor.',
    desc: `Did you know?
    Doing aerobic exercises at least thrice a week for more than 30 minutes can improve ACT score by 26%.`,
  },
];
const ProgressReportScreen: React.FC<ProgressScreenProps> = ({
  navigation,
  route,
}) => {
  const insets = useSafeAreaInsets();

  // ==================== state ====================//
  const [riskData, setRiskData] = useState<RiskTypeProps | undefined>(
    RiskType.find(a => a.key === constants.RISK_TYPE.HIGH),
  );
  // ==================== function ====================//
  const onPressNext = () => {
    navigation.navigate('DrawerScreen');
  };

  return (
    <SafeAreaView style={styles.container} edges={['bottom']}>
      <View style={styles.container}>
        <View
          style={{
            backgroundColor: riskData?.backgroundColor,
            width: Matrics.screenWidth,
            height: Matrics.screenHeight * 0.25,
            borderBottomLeftRadius: Matrics.mvs(30),
            borderBottomRightRadius: Matrics.mvs(30),
            justifyContent: 'flex-end',
            alignItems: 'center',
          }}>
          <ImageBackground
            source={images.ProgressBar}
            resizeMode="contain"
            style={{
              width: Matrics.screenWidth,
              height: Matrics.vs(100),
              alignItems: 'center',
              justifyContent: 'center',
            }}>
            <Text
              style={{
                color: riskData?.color,
                fontSize: Matrics.mvs(30),
                fontFamily: Fonts.BOLD,
              }}>
              {riskData?.value}
            </Text>
          </ImageBackground>

          <View
            style={{
              position: 'absolute',
              height: Matrics.vs(26),
              bottom: Matrics.vs(-13),
              justifyContent: 'center',
              backgroundColor: riskData?.color,
              paddingHorizontal: Matrics.s(8),
              borderRadius: Matrics.mvs(8),
            }}>
            <Text
              style={{
                color: colors.white,
                fontSize: Matrics.mvs(10),
                fontFamily: Fonts.BOLD,
              }}>
              {riskData?.heading}
            </Text>
          </View>
        </View>

        <Text
          style={{
            color: colors.labelDarkGray,
            marginTop: Matrics.vs(45),
            textAlign: 'center',
            fontSize: Matrics.mvs(20),
            marginHorizontal: Matrics.s(20),
          }}>
          {riskData?.title}
        </Text>

        <Text
          style={{
            color: colors.labelDarkGray,
            marginTop: Matrics.vs(32),
            fontSize: Matrics.mvs(12),
            marginHorizontal: Matrics.s(20),
          }}>
          {riskData?.desc}
        </Text>

        <Text
          style={{
            color: colors.darkGray,
            marginTop: Matrics.vs(16),
            fontSize: Matrics.mvs(12),
            marginHorizontal: Matrics.s(20),
          }}>
          {`MyTatva’s Personalised Plan can help you get there!`}
        </Text>
      </View>
      <Button
        title={'Explore'}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
        onPress={() => onPressNext()}
      />
    </SafeAreaView>
  );
};

export default ProgressReportScreen;
