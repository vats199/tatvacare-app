import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import TabButton from '../atoms/TabButton';
import Button from '../atoms/Button';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {PickerDataTypeProps} from '../organisms/WheelPicker.ios';
import {WheelPicker} from '../organisms/WheepPicker';

type LungFunctionBottomSheetProps = {
  selectedType: {
    type: string;
    subType: string;
  } | null;
  onPressTab: (item: string) => void;
  setSelectedItem: React.Dispatch<
    React.SetStateAction<
      | string
      | {
          left: string;
          right: string;
        }
    >
  >;
  onSaveBtnPress: () => void;
  selectedItem:
    | string
    | {
        left: string;
        right: string;
      };
  btnTitles: string[];
  multiplePicker: boolean;
  firstItemList: PickerDataTypeProps[] | undefined;
  secondItemList: PickerDataTypeProps[] | undefined;
};

const LungFunctionBottomSheet: React.FC<LungFunctionBottomSheetProps> = ({
  selectedType,
  onPressTab,
  setSelectedItem,
  onSaveBtnPress,
  selectedItem,
  btnTitles,
  firstItemList,
  multiplePicker,
  secondItemList,
}) => {
  const insets = useSafeAreaInsets();

  return (
    <View style={styles.bottomSheetContainer}>
      <Text style={styles.bottomSheetTitleTxt}>
        {`Select ${selectedType?.type}`}
      </Text>
      <View style={styles.bottomSheetInnerContainer} />
      {selectedType?.type != 'EthniCity' ? (
        <TabButton
          onPress={onPressTab}
          containerStyle={{
            marginTop: Matrics.vs(5),
          }}
          btnTitles={btnTitles}
        />
      ) : null}
      <WheelPicker
        onChangeValue={item => {
          if (selectedType?.type == 'Height') {
            if (selectedType?.subType == 'feet') {
              setSelectedItem({
                left:
                  item.type == 'left' ? `${item.value}'` : selectedItem?.left,
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
        data={firstItemList}
        additionalData={secondItemList}
        containerStyle={{
          height: selectedType?.type == 'EthniCity' ? '65%' : undefined,
        }}
      />
      <View
        style={[
          {
            paddingBottom: insets.bottom !== 0 ? insets.bottom : Matrics.vs(12),
          },
          styles.bottomSheetSaveBtn,
          styles.bottomBtnContainerShadow,
        ]}>
        <Button onPress={onSaveBtnPress} title="Save" />
      </View>
    </View>
  );
};

export default LungFunctionBottomSheet;

const styles = StyleSheet.create({
  bottomSheetContainer: {
    flex: 1,
    backgroundColor: colors.white,
    paddingVertical: Matrics.s(15),
  },
  bottomSheetTitleTxt: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(20),
    fontWeight: '700',
    lineHeight: Matrics.vs(26),
    paddingHorizontal: Matrics.s(15),
  },
  bottomSheetInnerContainer: {
    height: Matrics.vs(1),
    backgroundColor: colors.lightGrey,
    marginVertical: Matrics.vs(10),
    marginHorizontal: Matrics.s(15),
  },
  bottomSheetSaveBtn: {
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(10),
  },
  bottomBtnContainerShadow: {
    shadowColor: colors.black,
    shadowOffset: {width: 0, height: 0},
    shadowOpacity: 0.08,
    shadowRadius: 8,
    elevation: 2,
  },
});
