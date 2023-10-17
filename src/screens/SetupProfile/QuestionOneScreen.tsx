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

type QuestionOneScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'QuestionOneScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const QuestionOneScreen: React.FC<QuestionOneScreenProps> = ({
  navigation,
  route,
}) => {
  const insets = useSafeAreaInsets();

  // ==================== state ====================//
  const [name, setName] = useState<string>('');
  // const [email, setEmail] = useState<string>('');
  const [doctorCode, setDoctorCode] = useState<string>('');
  const [dob, setDob] = useState<string | null>(null);
  const [selectedGenderIndex, setSelectedGenderIndex] = useState<number | null>(
    null,
  );

  const isButtonDisable = React.useMemo(() => {
    return name != '' && dob != null && selectedGenderIndex != null;
  }, [name, dob, selectedGenderIndex]);

  const [arr, setArr] = React.useState<
    Array<{
      id: number;
      title: string;
      icon: React.ReactNode;
    }>
  >([
    {
      id: 1,
      title: 'Male',
      icon: <Icons.Male />,
    },
    {
      id: 2,
      title: 'Female',
      icon: <Icons.Female />,
    },
    {
      id: 3,
      title: 'Other',
      icon: <Icons.Other />,
    },
  ]);

  // ==================== function ====================//
  const onChangeName = (text: string) => {
    setName(text);
  };

  // const onChangeEmail = (text: string) => {
  //   setEmail(text);
  // };

  const onChangeCode = (text: string) => {
    setDoctorCode(text);
  };

  const onPressGenderSelection = (index: number) => {
    setSelectedGenderIndex(index);
  };
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.container}>
        <AuthHeader
          onPressBack={() => {
            navigation.goBack();
          }}
        />

        <SetupProfileHeading title={'Setup your profile'} />
        <View
          style={[
            styles.inputCont,
            {
              borderColor: name?.length
                ? colors.inputBoxDarkBorder
                : colors.inputBoxLightBorder,
            },
          ]}>
          <InputField
            value={name}
            showAnimatedLabel={true}
            onChangeText={setName}
            textStyle={name === '' ? styles.inputBoxStyle : styles.inputBoxFill}
            placeholder="Your Name"
            style={styles.pincodeInputStyle}
          />
        </View>

        {/* <View style={[styles.inputCont, { borderColor: email?.length ? colors.inputBoxDarkBorder : colors.inputBoxLightBorder }]}>
          <InputField
            value={email}
            showAnimatedLabel={true}
            onChangeText={onChangeEmail}
            textStyle={email == '' ? styles.inputBoxStyle : styles.inputBoxFill}
            placeholder='Your Email'
            style={styles.pincodeInputStyle} />

        </View> */}

        <TouchableOpacity
          style={[
            styles.inputCont,
            {
              borderColor:
                dob != null
                  ? colors.inputBoxDarkBorder
                  : colors.inputBoxLightBorder,
            },
          ]}
          activeOpacity={0.7}>
          <AnimatedDatePicker
            showAnimatedLabel={true}
            placeholder={'Date of Birth'}
          />
        </TouchableOpacity>

        <View style={styles.genderContainer}>
          <Text style={styles.genderTitle}>{'Gender'}</Text>
          <View style={styles.genderWrapper}>
            {arr.map((ele, index) => {
              return (
                <TouchableOpacity
                  style={[
                    styles.itemWidth,
                    index === selectedGenderIndex && {
                      borderColor: colors.genderSelectedBorderColor,
                      backgroundColor: colors.THEME_OVERLAY,
                    },
                  ]}
                  activeOpacity={0.7}
                  onPress={() => onPressGenderSelection(index)}>
                  {ele.icon}
                  <Text
                    style={[
                      styles.genderItemText,
                      index === selectedGenderIndex && {
                        color: colors.labelDarkGray,
                      },
                    ]}>
                    {ele.title}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        </View>
        <>
          <Text style={styles.doctorCodeTitle}>
            {'Doctor Code '}
            <Text style={styles.optionalText}>{'(Optional)'}</Text>
          </Text>
        </>

        <View style={styles.wrapper}>
          <View
            style={[
              styles.doctorCodeCont,
              {
                borderColor: doctorCode?.length
                  ? colors.inputBoxDarkBorder
                  : colors.inputBoxLightBorder,
              },
            ]}>
            <InputField
              value={doctorCode}
              showAnimatedLabel={true}
              onChangeText={onChangeCode}
              textStyle={
                doctorCode === '' ? styles.inputBoxStyle : styles.inputBoxFill
              }
              placeholder="Enter Code"
              style={styles.pincodeInputStyle}
            />
          </View>

          <TouchableOpacity
            activeOpacity={0.7}
            style={styles.scanButton}
            onPress={() => navigation.navigate('ScanCodeScreen')}>
            <Icons.QrCodeScanner />
          </TouchableOpacity>
        </View>
      </View>

      <Button
        title={'Next'}
        type={Constants.BUTTON_TYPE.SECONDARY}
        disabled={!isButtonDisable}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
      />
    </SafeAreaView>
  );
};

export default QuestionOneScreen;
