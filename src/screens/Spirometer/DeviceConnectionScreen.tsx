import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React, {useEffect, useRef, useState} from 'react';
import {colors} from '../../constants/colors';
import CommonHeader from '../../components/molecules/CommonHeader';
import {StackScreenProps} from '@react-navigation/stack';
import {AppStackParamList} from '../../interface/Navigation.interface';
import {Fonts, Matrics} from '../../constants';
import DropdownField from '../../components/atoms/DropdownField';
import Button from '../../components/atoms/Button';
import {Icons} from '../../constants/icons';
import {useFormik} from 'formik';
import * as yup from 'yup';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import {BottomSheetModal, BottomSheetModalProvider} from '@gorhom/bottom-sheet';
import {SafeAreaView, useSafeAreaInsets} from 'react-native-safe-area-context';
import {PickerDataTypeProps} from '../../components/organisms/WheelPicker.Ios';
import DatePicker from 'react-native-date-picker';
import DeviceConnectGenderButtons from '../../components/molecules/DeviceConnectGenderButtons';
import LungFuncationBottomSheet from '../../components/molecules/LungFunctionBottomSheet';
import LungActionBottomSheet from '../../components/molecules/LungActionBottomSheet';

type DeviceConnectionScreenProps = StackScreenProps<
  AppStackParamList,
  'DeviceConnectionScreen'
>;

export type LungFuncationProps = {
  id: number;
  title: string;
  param: string;
};
const heightSubTypes = ['feet', 'Cm'];
const weightSubTypes = ['kgs', 'lbs'];
const ethniCity = [
  'Caucasian',
  'North Indian',
  'South Indian',
  'Asian',
  'Other',
];

const LungFuncationAction: LungFuncationProps[] = [
  {
    id: 1,
    title: 'Measure Lung Health',
    param: 'Lung Health',
  },
  {
    id: 2,
    title: 'Lung Exercise',
    param: 'Lung Exercise',
  },
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
  const bottomSheetModalRef = useRef<BottomSheetModal>(null);

  // values
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

  // wheel picker list
  const [firstItemList, setfirstItemList] = useState<
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
  const [selectedDate, setSelectedDate] = React.useState(new Date());
  const [selectAction, setSelectAction] = useState(false);

  const insets = useSafeAreaInsets();
  const onPressBackArrow = () => {
    navigation.goBack();
  };

  const onPressGenderBtn = (value: string) => {
    setFieldValue('gender', value);
  };

  useEffect(() => {
    generateHeight();
    generateCentimeter();
    generateWeight();
    generateEthniCity();
  }, []);

  useEffect(() => {
    if (selectedType?.type == 'Height') {
      if (selectedType.subType == 'feet') {
        setfirstItemList(heightList);
        setSecondItemList(subHeight);
      } else {
        setfirstItemList(centimeterItemList);
      }
    } else if (selectedType?.type == 'Weight') {
      if (selectedType.subType == 'kgs') {
        setfirstItemList(kgsList);
      } else {
        setfirstItemList(lbsList);
      }
    } else {
      setfirstItemList(ethniCityList);
    }
  }, [selectedType]);

  const generateHeight = () => {
    const hightArray = arrayGenerator(10, "'");
    generateSubHeight();
    setHeightList(hightArray);
  };

  const generateSubHeight = () => {
    const subHeightArray = arrayGenerator(12, '"');
    setSubHeight(subHeightArray);
  };

  const generateCentimeter = () => {
    const centimeterArray = arrayGenerator(300, ' cm');
    setCentimeterItemList(centimeterArray);
  };

  const generateWeight = () => {
    const weightArray = arrayGenerator(200);
    setKgsList(weightArray);
    generateLbs();
  };

  const arrayGenerator = (
    number: number,
    seprator?: string,
    extra?: number,
  ) => {
    const arrayList: PickerDataTypeProps[] = [];
    for (let i = 1; i < number; i++) {
      const tenpObj = {
        label: `${extra ? (i * extra).toFixed(3) : i.toString()}${
          seprator == '' || seprator == undefined ? '' : seprator
        }`,
        value: i,
      };
      arrayList.push(tenpObj);
    }
    return arrayList;
  };

  const generateLbs = () => {
    const lbsArray = arrayGenerator(200, '', 2.205);
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
        age: '',
        gender: 'Male',
      },
      validationSchema: PersonDetailsValidationSchema,
      onSubmit(values, formikHelpers) {
        setSelectAction(true);
        bottomSheetModalRef.current?.present();
      },
    });

  const onPreesHeight = () => {
    selectAction && setSelectAction(false);
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
    selectAction && setSelectAction(false);
    setSelectedType({
      subType: 'kgs',
      type: 'Weight',
    });
    bottomSheetModalRef.current?.present();
  };

  const onPreesEthniCity = () => {
    selectAction && setSelectAction(false);
    setSelectedType({
      subType: '',
      type: 'EthniCity',
    });
    bottomSheetModalRef.current?.present();
  };

  const onSaveBtnPress = () => {
    if (selectedType?.type == 'Height') {
      if (selectedType.subType == 'feet') {
        const firstTxt = !selectedItem.left
          ? heightList[0].label
          : selectedItem.left;
        const secondTxt = !selectedItem?.right
          ? subHeight[0].label
          : selectedItem?.right;
        setFieldValue('height', `${firstTxt}${secondTxt}`);
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

  const calculateAge = date => {
    const birthDate = new Date(date);
    const otherDate = new Date();
    var years = otherDate.getFullYear() - birthDate.getFullYear();
    if (
      otherDate.getMonth() < birthDate.getMonth() ||
      (otherDate.getMonth() == birthDate.getMonth() &&
        otherDate.getDate() < birthDate.getDate())
    ) {
      years--;
    }
    return years;
  };

  const onPressLungAction = (param: any) => {
    navigation.navigate('AnalyserScreen', {type: param});
  };

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
          <Text style={styles.disclaimerTxt}>
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
            error={errors.height}
          />
          <DropdownField
            onPress={onPreesWeight}
            title="Select Weight *"
            value={values.weight}
            error={errors.weight}
          />
          <DropdownField
            onPress={onPreesEthniCity}
            title="Select Ethnicity *"
            value={values.ethnicity}
            error={errors.ethnicity}
          />
          <DropdownField
            onPress={() => {
              setOpen(true);
            }}
            title="Age *"
            value={values.age.toString()}
            error={errors.age}
          />
          <DatePicker
            modal
            open={open}
            date={selectedDate}
            mode="date"
            onConfirm={date => {
              setOpen(false);
              setSelectedDate(date);
              const age = calculateAge(date);
              setFieldValue('age', age);
            }}
            onCancel={() => {
              setOpen(false);
            }}
          />
          <DeviceConnectGenderButtons
            onPress={onPressGenderBtn}
            error={errors.gender}
          />
        </View>
      </View>
      <View
        style={[
          styles.bottomBtnContainerShadow,
          styles.bottonBtnContainer,
          {
            paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(16),
          },
        ]}>
        <Button
          title="Save & Next"
          titleStyle={styles.saveBtnTxt}
          buttonStyle={{
            borderRadius: Matrics.s(19),
          }}
          onPress={() => handleSubmit()}
        />
      </View>
      <BottomSheetModalProvider>
        <CommonBottomSheetModal
          index={0}
          snapPoints={
            selectAction
              ? ['25%']
              : [selectedType?.type == 'EthniCity' ? '50%' : '55%']
          }
          ref={bottomSheetModalRef}
          onChange={index => {
            index == -1 && setMultiplePicker(false);
          }}>
          {selectAction ? (
            <LungActionBottomSheet
              data={LungFuncationAction}
              onPress={onPressLungAction}
            />
          ) : (
            <LungFuncationBottomSheet
              selectedType={selectedType}
              onPressTab={onPressTab}
              setSelectedItem={setSelectedItem}
              btnTitles={
                selectedType?.type == 'Height' ? heightSubTypes : weightSubTypes
              }
              firstItemList={firstItemList}
              multiplePicker={multiplePicker}
              onSaveBtnPress={onSaveBtnPress}
              secondItemList={secondItemList}
              selectedItem={selectedItem}
            />
          )}
        </CommonBottomSheetModal>
      </BottomSheetModalProvider>
    </SafeAreaView>
  );
};

export default DeviceConnectionScreen;

const styles = StyleSheet.create({
  bottomBtnContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
  disclaimerTxt: {
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
  },
  bottonBtnContainer: {
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(8),
  },
  saveBtnTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(16),
    fontWeight: '700',
  },
});
