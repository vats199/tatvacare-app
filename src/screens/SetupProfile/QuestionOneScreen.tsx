import { Image, Text, View } from 'react-native';
import React, { useState } from 'react';
import { CommonActions, CompositeScreenProps } from '@react-navigation/native';
import { StackScreenProps } from '@react-navigation/stack';
import { useSafeAreaInsets, SafeAreaView } from 'react-native-safe-area-context';

import {
  AppStackParamList,
  AuthStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import { useApp } from '../../context/app.context';
import { QuestionOneScreenStyle as styles } from './styles';
import images from '../../constants/images';
import Button from '../../components/atoms/Button';
import { Constants, Matrics } from '../../constants';
import AuthHeader from '../../components/molecules/AuthHeader';
import SetupProfileHeading from '../../components/atoms/SetupProfileHeading';
import InputField from '../../components/atoms/AnimatedInputField';
import { colors } from '../../constants/colors';
import AnimatedDatePicker from '../../components/atoms/AnimatedDatePicker';
import { TouchableOpacity } from 'react-native';
import { Icons } from '../../constants/icons';

type QuestionOneScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'QuestionOneScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const QuestionOneScreen: React.FC<QuestionOneScreenProps> = ({
  navigation,
  route,
}) => {
  const { setUserData } = useApp();
  const insets = useSafeAreaInsets();

  // ==================== state ====================//
  const [name, setName] = useState<string>('')
  const [email, setEmail] = useState<string>('')
  const [doctorCode, setDoctorCode] = useState<string>('')
  const [dob, setDob] = useState<string | null>(null)
  const [selectedGenderIndex, setSelectedGenderIndex] = useState<number | null>(null)

  const [arr, setArr] = React.useState<Array<{
    id: number,
    title: string
  }>>([
    {
      id: 1,
      title: `Male`
    },
    {
      id: 2,
      title: `Female`
    },
    {
      id: 3,
      title: `Other`
    }
  ])

  // ==================== function ====================//
  const onChangeName = (text: string) => {
    setName(text)
  }

  const onChangeEmail = (text: string) => {
    setEmail(text)
  }

  const onChangeCode = (text: string) => {
    setDoctorCode(text)
  }

  const onPressGenderSelection = (index: number) => {
    setSelectedGenderIndex(index)
  }
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.container}>
        <AuthHeader
          onPressBack={() => {
            navigation.goBack();
          }}
        />

        <SetupProfileHeading
          title={`Setup your profile`}
        />
        <View style={[styles.inputCont, { borderColor: name?.length ? colors.inputBoxDarkBorder : colors.inputBoxLightBorder }]}>
          <InputField
            showAnimatedLabel={true}
            value={name}
            onChangeText={onChangeName}
            textStyle={name == '' ? styles.inputBoxStyle : styles.inputBoxFill}
            placeholder='Your Name'
            style={styles.pincodeInputStyle} />

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

        <TouchableOpacity style={[styles.inputCont, { borderColor: dob != null ? colors.inputBoxDarkBorder : colors.inputBoxLightBorder }]} activeOpacity={0.7}>
          <AnimatedDatePicker
            showAnimatedLabel={true}
            placeholder={`Date of Birth`}
          />
        </TouchableOpacity>

        <View style={styles.genderContainer}>
          <Text style={styles.genderTitle}>{`Gender`}</Text>
          <View style={styles.genderWrapper}>
            {arr.map((ele, index) => {
              return (
                <TouchableOpacity style={[styles.itemWidth, index == selectedGenderIndex && { borderColor: colors.genderSelectedBorderColor, backgroundColor: colors.THEME_OVERLAY }]} activeOpacity={0.7} onPress={() => onPressGenderSelection(index)}>
                  {
                    index == 0 && (
                      <Icons.Male />
                    )
                  }
                  {
                    index == 1 && (
                      <Icons.Female />
                    )
                  }
                  {
                    index == 2 && (
                      <Icons.Other />
                    )
                  }
                  <Text style={[styles.genderItemText, index == selectedGenderIndex && { color: colors.labelDarkGray }]}>
                    {ele.title}
                  </Text>
                </TouchableOpacity>
              )
            })}
            {/* <View style={styles.itemWidth}>
              <Icons.Male />
              <Text style={styles.genderItemText}>
                {`Male`}
              </Text>
            </View>

            <View style={styles.itemWidth}>
              <Icons.Female />
              <Text style={styles.genderItemText}>
                {`Female`}
              </Text>
            </View>

            <View style={styles.itemWidth}>
              <Icons.Other />
              <Text style={styles.genderItemText}>
                {`Other`}
              </Text>
            </View> */}
          </View>
        </View>
        <>
          <Text style={styles.doctorCodeTitle}>
            {`Doctor Code `}
            <Text style={styles.optionalText}>
              {`(Optional)`}
            </Text>
          </Text>
        </>

        <View style={styles.wrapper}>
          <View style={[styles.doctorCodeCont, { borderColor: doctorCode?.length ? colors.inputBoxDarkBorder : colors.inputBoxLightBorder }]}>
            <InputField
              value={doctorCode}
              showAnimatedLabel={true}
              onChangeText={onChangeCode}
              textStyle={doctorCode == '' ? styles.inputBoxStyle : styles.inputBoxFill}
              placeholder='Enter Code'
              style={styles.pincodeInputStyle} />
          </View>

          <TouchableOpacity activeOpacity={0.7} style={styles.scanButton}>
            <Icons.QrCodeScanner />
          </TouchableOpacity>
        </View>

      </View>


      <Button
        title={`Next`}
        type={Constants.BUTTON_TYPE.SECONDARY}
        disabled={true}
        buttonStyle={{ marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0 }}
      />
    </SafeAreaView>
  );
};

export default QuestionOneScreen;
