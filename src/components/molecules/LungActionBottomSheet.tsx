import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import {Fonts, Matrics} from '../../constants';
import {LungFuncationProps} from '../../screens/Spirometer/DeviceConnectionScreen';

type LungActionBottomSheetProps = {
  onPress: (param: string) => void;
  data: LungFuncationProps[];
};
const LungActionBottomSheet: React.FC<LungActionBottomSheetProps> = ({
  onPress,
  data,
}) => {
  return (
    <View style={styles.lungBottomSheetContainer}>
      <Text style={styles.lungBottomSheetTxt}>
        Select Action For Your Lungs
      </Text>
      <View style={styles.lungSheetSeprator} />
      {data.map((item, index) => {
        return (
          <>
            <TouchableOpacity
              onPress={() => onPress(item.param)}
              style={styles.lungItemContainer}>
              <Text style={styles.lungItemTxt}>{item.title}</Text>
              <Icons.RightArrow
                height={Matrics.mvs(20)}
                weight={Matrics.mvs(20)}
              />
            </TouchableOpacity>
            {index == data.length - 1 ? null : (
              <View style={styles.lungItemSeprator} />
            )}
          </>
        );
      })}
    </View>
  );
};

export default LungActionBottomSheet;

const styles = StyleSheet.create({
  lungBottomSheetContainer: {
    flex: 1,
    backgroundColor: colors.white,
    paddingVertical: Matrics.vs(15),
  },
  lungBottomSheetTxt: {
    paddingHorizontal: Matrics.s(15),
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(20),
    color: colors.labelDarkGray,
    fontWeight: '700',
  },
  lungSheetSeprator: {
    height: Matrics.vs(0.5),
    backgroundColor: colors.lightGrey,
    marginTop: Matrics.s(12),
  },
  lungItemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: Matrics.s(15),
    marginVertical: Matrics.vs(12),
    alignItems: 'center',
  },
  lungItemTxt: {
    fontFamily: Fonts.MEDIUM,
    fontSize: Matrics.mvs(15),
    color: colors.labelDarkGray,
    fontWeight: '400',
  },
  lungItemSeprator: {
    height: Matrics.vs(0.5),
    backgroundColor: colors.lightGrey,
    marginHorizontal: Matrics.s(15),
  },
});
