import {Platform, StyleSheet, Text, View} from 'react-native';
import React, {useEffect, useRef, useState} from 'react';
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
import {WheelPicker} from '../../components/organisms/WheelPicker';
import {PickerDataTypeProps} from '../../components/organisms/WheelPicker.Ios';
import DatePicker from 'react-native-date-picker';
import moment from 'moment';

type DeviceConnectionScreenProps = StackScreenProps<
  AppStackParamList,
  'DeviceConnectionScreen'
>;

const city = '50';
const other = '55';

const heightSubTypes = ['feet', 'Cm'];
const weightSubTypes = ['kgs', 'lbs'];
const ethniCity = [
  'Caucasian',
  'North Indian',
  'South Indian',
  'Asian',
  'Other',
];

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
  const [heightList, setHeightList] = useState<
    PickerDataTypeProps[] | undefined
  >(undefined);
  const [subHeight, setSubHeight] = useState<PickerDataTypeProps[] | undefined>(
    undefined,
  );
  const [kgsList, setKgsList] = useState<PickerDataTypeProps[] | undefined>(
    undefined,
  );
  const [lbsList, setLbsList] = useState<PickerDataTypeProps[] | undefined>(
    undefined,
  );
  const [centimeterItemList, setCentimeterItemList] = useState<
    PickerDataTypeProps[] | undefined
  >([]);
  const [ethniCityList, setEthniCityList] = useState<
    PickerDataTypeProps[] | undefined
  >(undefined);

  const [fristItemList, setFristItemList] = useState<
    PickerDataTypeProps[] | undefined
  >(undefined);
  const [secondItemList, setSecondItemList] = useState<
    PickerDataTypeProps[] | undefined
  >(undefined);

  const [selectedType, setSelectedType] = useState<{
    type: string;
    subType: string;
  } | null>(null);
  const [multiplePicker, setMultiplePicker] = useState(false);
  const [selectedItem, setSelectedItem] = useState<
    {left: string; right: string} | string
  >('');
  const [open, setOpen] = React.useState(false);

  const insets = useSafeAreaInsets();
  const onPressBackArrow = () => {
    navigation.goBack();
  };

  const onPressGenderBtn = (value: string) => {
    setIsMale(value == 'Male' ? true : false);
  };

  useEffect(() => {
    generateHeight();
    generateCentimeter();
    generateWeight();
    generateEthniCity();
  }, []);

  // useEffect(() => {
  //   if (selectedType?.type == 'Height' && selectedType.subType == 'feet') {
  //     setMultiplePicker(true);
  //   }
  // }, [selectedType]);

  useEffect(() => {
    if (selectedType?.type == 'Height') {
      if (selectedType.subType == 'feet') {
        setFristItemList(heightList);
        setSecondItemList(subHeight);
      } else {
        setFristItemList(centimeterItemList);
      }
    } else if (selectedType?.type == 'Weight') {
      if (selectedType.subType == 'kgs') {
        setFristItemList(kgsList);
      } else {
        setFristItemList(lbsList);
      }
    } else {
      setFristItemList(ethniCityList);
    }
  }, [selectedType]);

  const generateHeight = () => {
    const hightArray: PickerDataTypeProps[] = [];
    for (let i = 1; i < 10; i++) {
      const tenpObj = {
        label: `${i.toString()}'`,
        value: i,
      };
      hightArray.push(tenpObj);
    }
    console.log(
      '🚀 ~ file: DeviceConnectionScreen.tsx:69 ~ generateHeight ~ hightArray:',
      hightArray,
    );
    generateSubHeight();
    setHeightList(hightArray);
  };

  const generateSubHeight = () => {
    const subHeightArray: PickerDataTypeProps[] = [];
    for (let i = 1; i <= 12; i++) {
      const tenpObj = {
        label: `${i.toString()}"`,
        value: i,
      };
      subHeightArray.push(tenpObj);
    }
    setSubHeight(subHeightArray);
  };

  const generateCentimeter = () => {
    const centimeterArray: PickerDataTypeProps[] = [];
    for (let i = 1; i < 300; i++) {
      const tenpObj = {
        label: `${i.toString()} cm`,
        value: i,
      };
      centimeterArray.push(tenpObj);
    }
    setCentimeterItemList(centimeterArray);
  };

  const generateWeight = () => {
    const weightArray: PickerDataTypeProps[] = [];
    for (let i = 1; i < 200; i++) {
      const tenpObj = {
        label: i.toString(),
        value: i,
      };
      weightArray.push(tenpObj);
      setKgsList(weightArray);
    }
    generateLbs();
  };

  const generateLbs = () => {
    const lbsArray: PickerDataTypeProps[] = [];
    for (let i = 1; i < 200; i++) {
      const lbs = 2.205;
      const tenpObj = {
        label: (i * lbs).toFixed(3).toString(),
        value: i * lbs,
      };
      lbsArray.push(tenpObj);
    }
    setLbsList(lbsArray);
  };

  const generateEthniCity = () => {
    const tempArray = ethniCity.map((item, index) => {
      return {
        label: item,
        value: index,
      };
    });
    setEthniCityList(tempArray);
  };

  const {values, errors, touched, handleChange, handleSubmit, setFieldValue} =
    useFormik({
      initialValues: {
        height: '',
        weight: '',
        ethnicity: '',
        age: new Date() ?? '',
        gender: '',
      },
      validationSchema: PersonDetailsValidationSchema,
      onSubmit(values, formikHelpers) {},
    });

  const onPreesHeight = () => {
    setSelectedType({
      subType: 'feet',
      type: 'Height',
    });
    setMultiplePicker(true);
    bottomSheetModalRef.current?.present();
  };

  const onPressTab = (item: string) => {
    if (selectedType?.type == 'Height') {
      if (item == 'feet') {
        setMultiplePicker(true);
      } else {
        setMultiplePicker(false);
      }
      setSelectedType({
        ...selectedType,
        subType: item,
      });
    } else if (selectedType?.type == 'Weight') {
      setMultiplePicker(false);
      setSelectedType({
        ...selectedType,
        subType: item,
      });
    }
  };

  const onPreesWeight = () => {
    setSelectedType({
      subType: 'kgs',
      type: 'Weight',
    });
    bottomSheetModalRef.current?.present();
  };

  const onPreesEthniCity = () => {
    setSelectedType({
      subType: '',
      type: 'EthniCity',
    });
    bottomSheetModalRef.current?.present();
  };

  const onSaveBtnPress = () => {
    if (selectedType?.type == 'Height') {
      if (selectedType.subType == 'feet') {
        if (!selectedItem?.left || !selectedItem?.right) {
          setFieldValue('height', heightList[0].label + subHeight[0].label);
        } else {
          setFieldValue(
            'height',
            `${selectedItem?.left}${selectedItem?.right}`,
          );
        }
      } else {
        setFieldValue(
          'height',
          selectedItem !== ''
            ? `${selectedItem} cm`
            : centimeterItemList[0].label,
        );
      }
    } else if (selectedType?.type == 'Weight') {
      setFieldValue(
        'weight',
        selectedItem !== ''
          ? selectedItem
          : selectedType?.subType == 'kgs'
          ? kgsList[0].label
          : lbsList[0].label,
      );
    } else {
      const itemFound = ethniCityList?.filter(
        (item, index) => index == selectedItem ?? 0,
      )[0];
      setFieldValue('ethnicity', itemFound?.label);
    }
    bottomSheetModalRef.current?.close();
    setSelectedItem('');
  };

  // const calculateAge = date => {
  //   const birthDate = new Date(date);
  //   const otherDate = new Date();
  //   var years = otherDate.getFullYear() - birthDate.getFullYear();
  //   if (
  //     otherDate.getMonth() < birthDate.getMonth() ||
  //     (otherDate.getMonth() == birthDate.getMonth() &&
  //       otherDate.getDate() < birthDate.getDate())
  //   ) {
  //     years--;
  //   }
  //   return years;
  // };

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
            onPress={onPreesHeight}
            title="Select Height *"
            value={values.height}
            containerStyle={{
              marginTop: Matrics.vs(13),
            }}
          />
          <DropdownField
            onPress={onPreesWeight}
            title="Select Weight *"
            value={values.weight}
          />
          <DropdownField
            onPress={onPreesEthniCity}
            title="Select Ethnicity *"
            value={values.ethnicity}
          />
          <DropdownField
            onPress={() => {
              setOpen(true);
            }}
            title="Age *"
            value={values.age.toString()}
          />
          <DatePicker
            modal
            open={open}
            date={values.age}
            mode="date"
            onConfirm={date => {
              setOpen(false);
              // const age = calculateAge(date);
              // setFieldValue('age', age);
            }}
            onCancel={() => {
              setOpen(false);
            }}
          />
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
          onPress={() => {}}
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
              paddingVertical: Matrics.s(15),
            }}>
            <Text
              style={{
                fontFamily: Fonts.BOLD,
                fontSize: Matrics.mvs(20),
                fontWeight: '700',
                lineHeight: Matrics.vs(26),
                paddingHorizontal: Matrics.s(15),
              }}>
              {`Select ${selectedType?.type}`}
            </Text>
            <View
              style={{
                height: Matrics.vs(1),
                backgroundColor: colors.lightGrey,
                marginVertical: Matrics.vs(10),
                marginHorizontal: Matrics.s(15),
              }}
            />
            {selectedType?.type !== 'EthniCity' ? (
              <TabButton
                onPress={onPressTab}
                containerStyle={{
                  marginTop: Matrics.vs(5),
                }}
                btnTitles={
                  selectedType?.type == 'Height'
                    ? heightSubTypes
                    : weightSubTypes
                }
              />
            ) : null}
            <WheelPicker
              onChangeValue={item => {
                if (selectedType?.type == 'Height') {
                  if (selectedType?.subType == 'feet') {
                    setSelectedItem({
                      left:
                        item.type == 'left'
                          ? `${item.value}'`
                          : selectedItem?.left,
                      right:
                        item.type == 'right'
                          ? `${item.value}\"`
                          : selectedItem?.right,
                    });
                  } else {
                    setSelectedItem(item.value);
                  }
                } else if (selectedType?.type == 'Weight') {
                  setSelectedItem(item.value);
                } else {
                  setSelectedItem(item.value);
                }
              }}
              isShowMultiplePicker={multiplePicker}
              data={fristItemList}
              additionalData={secondItemList}
              containerStyle={{
                height: selectedType?.type == 'EthniCity' ? '65%' : undefined,
              }}
            />

            {/* <WheelPicker
              selectedIndex={selectedIndex}
              seprator={'"'}
              options={heightList}
              itemTextStyle={{
                fontFamily: Fonts.BOLD,
                fontSize: Matrics.mvs(25),
              }}
              containerStyle={{
                marginVertical: Matrics.vs(10),
                backgroundColor: 'green',
              }}
              onChange={index => setSelectedIndex(index)}
              sideIcon={{
                right: false,
                left: true,
              }}
            /> */}
            {/* <WheelPicker
              selectedIndex={selectedIndex}
              seprator={'"'}
              options={heightList}
              itemTextStyle={{
                fontFamily: Fonts.BOLD,
                fontSize: Matrics.mvs(25),
              }}
              containerStyle={{
                marginVertical: Matrics.vs(10),
                backgroundColor: 'red',
              }}
              onChange={index => setSelectedIndex(index)}
            /> */}

            <View
              style={[
                {
                  paddingBottom:
                    insets.bottom !== 0 ? insets.bottom : Matrics.vs(12),
                  backgroundColor: colors.white,
                  paddingVertical: Matrics.vs(10),
                },
                styles.bottomBtnContainerShadow,
              ]}>
              <Button onPress={onSaveBtnPress} title="Save" />
            </View>
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
