import {StyleSheet, Text, View} from 'react-native';
import React, {useRef, useState} from 'react';
import {colors} from '../../constants/colors';
import CommonHeader from '../../components/molecules/CommonHeader';
import {StackScreenProps} from '@react-navigation/stack';
import {AppStackParamList} from '../../interface/Navigation.interface';
import {Fonts, Matrics} from '../../constants';
import DropdownField from '../../components/atoms/DropdownField';
import Button from '../../components/atoms/Button';
import IconButton from '../../components/atoms/IconButton';
import {Icons} from '../../constants/icons';
import {useFormik} from 'formik';
import * as yup from 'yup';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import {BottomSheetModal, BottomSheetModalProvider} from '@gorhom/bottom-sheet';
import TabButton from '../../components/atoms/TabButton';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';

type DeviceConnectionScreenProps = StackScreenProps<
  AppStackParamList,
  'DeviceConnectionScreen'
>;

const city = '50';
const other = '55';

const PersonDetailsValidationSchema = yup.object().shape({
  height: yup.string().required('Please select height'),
  weight: yup.string().required('Please select weight'),
  ethnicity: yup.string().required('Please select ethnicity'),
  age: yup.string().required('Please select age'),
  gender: yup.string().required('Please select gender'),
});

const DeviceConnectionScreen: React.FC<DeviceConnectionScreenProps> = ({
  navigation,
  route,
}) => {
  const [isMale, setIsMale] = useState<boolean>(true);
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);
  const insets = useSafeAreaInsets();
  const onPressBackArrow = () => {
    navigation.goBack();
  };

  const onPressGenderBtn = (value: string) => {
    setIsMale(value == 'Male' ? true : false);
  };

  const {values, errors, touched, handleChange, handleSubmit} = useFormik({
    initialValues: {
      height: '',
      weight: '',
      ethnicity: '',
      age: '',
      gender: '',
    },
    validationSchema: PersonDetailsValidationSchema,
    onSubmit(values, formikHelpers) {},
  });

  return (
    <SafeAreaView
      edges={['top']}
      style={{
        flex: 1,
        backgroundColor: colors.lightPurple,
        justifyContent: 'space-between',
      }}>
      <View>
        <CommonHeader title="Enter Details" onPress={onPressBackArrow} />
        <View style={{paddingHorizontal: Matrics.s(15)}}>
          <Text
            style={{
              backgroundColor: colors.white,
              padding: Matrics.s(10),
              borderRadius: Matrics.s(15),
              borderWidth: Matrics.s(1),
              overflow: 'hidden',
              borderColor: colors.borderColor,
              fontFamily: Fonts.MEDIUM,
              fontSize: Matrics.mvs(12),
              fontWeight: '400',
              color: colors.darkGray,
              marginTop: Matrics.vs(15),
            }}>
            Disclaimer: We need this information to get your Lung Function
            values correctly.
          </Text>
          <DropdownField
            onPress={() => {}}
            title="Select Height *"
            value={'sad'}
            containerStyle={{
              marginTop: Matrics.vs(13),
            }}
          />
          <DropdownField
            onPress={() => {}}
            title="Select Weight *"
            value={''}
          />
          <DropdownField
            onPress={() => {}}
            title="Select Ethnicity *"
            value={''}
          />
          <DropdownField onPress={() => {}} title="Age *" value={''} />
          <Text
            style={{
              fontFamily: Fonts.MEDIUM,
              fontSize: Matrics.mvs(14),
              fontWeight: '700',
              color: colors.labelDarkGray,
              lineHeight: Matrics.vs(18),
              marginVertical: Matrics.vs(10),
            }}>
            Biological Sex*
          </Text>
          <View
            style={{
              flexDirection: 'row',
              justifyContent: 'space-between',
              alignItems: 'center',
            }}>
            <IconButton
              onPressBtn={() => onPressGenderBtn('Male')}
              containetStyle={{
                backgroundColor: isMale
                  ? colors.genderActiveButton
                  : colors.white,
                borderColor: isMale
                  ? colors.genderActiveButtonBorder
                  : colors.genderInactiveButtonBorder,
                ...styles.genderBtnContainer,
              }}
              style={styles.genderBtnTxt}
              title="Male"
              leftIcon={
                <Icons.Male
                  height={Matrics.mvs(24)}
                  weight={Matrics.mvs(24)}
                  style={styles.genderIcon}
                />
              }
            />
            <IconButton
              onPressBtn={() => onPressGenderBtn('Female')}
              containetStyle={{
                backgroundColor: isMale
                  ? colors.white
                  : colors.genderActiveButton,

                borderColor: isMale
                  ? colors.genderInactiveButtonBorder
                  : colors.genderActiveButtonBorder,
                ...styles.genderBtnContainer,
              }}
              style={styles.genderBtnTxt}
              title="Female"
              leftIcon={
                <Icons.Female
                  height={Matrics.mvs(24)}
                  weight={Matrics.mvs(24)}
                  style={styles.genderIcon}
                />
              }
            />
          </View>
        </View>
      </View>
      <View
        style={[
          styles.bottomBtnContainerShadow,
          {
            backgroundColor: colors.white,
            paddingVertical: Matrics.vs(8),
            paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(16),
          },
        ]}>
        <Button
          title="Save & Next"
          titleStyle={{
            fontFamily: Fonts.BOLD,
            fontSize: Matrics.mvs(16),
            fontWeight: '700',
          }}
          buttonStyle={{
            borderRadius: Matrics.s(19),
          }}
          onPress={() => {
            bottomSheetModalRef.current?.present();
          }}
        />
      </View>
      <BottomSheetModalProvider>
        <CommonBottomSheetModal
          index={0}
          snapPoints={['55%']}
          ref={bottomSheetModalRef}>
          <View
            style={{
              flex: 1,
              backgroundColor: colors.white,
              padding: Matrics.s(15),
            }}>
            <Text
              style={{
                fontFamily: Fonts.BOLD,
                fontSize: Matrics.mvs(20),
                fontWeight: '700',
                lineHeight: Matrics.vs(26),
              }}>
              Select Height
            </Text>
            <View
              style={{
                height: Matrics.vs(1),
                backgroundColor: colors.lightGrey,
                marginVertical: Matrics.vs(10),
              }}
            />

            <TabButton btnTitles={['Feet', 'cm']} />
            {/* <View style={{}}>
              <Button title="Save" />
            </View> */}
          </View>
        </CommonBottomSheetModal>
      </BottomSheetModalProvider>
    </SafeAreaView>
  );
};

export default DeviceConnectionScreen;

const styles = StyleSheet.create({
  genderBtnContainer: {
    padding: Matrics.s(8),
    width: Matrics.s(150),
    borderRadius: Matrics.s(10),
    borderWidth: Matrics.s(1),
    marginHorizontal: 0,
    marginTop: 0,
    alignItems: 'center',
    justifyContent: 'center',
  },
  genderBtnTxt: {
    marginHorizontal: 0,
    marginLeft: 0,
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(12),
    color: colors.disableButton,
    fontWeight: '600',
  },
  genderIcon: {
    marginRight: Matrics.s(5),
  },
  bottomBtnContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
});
