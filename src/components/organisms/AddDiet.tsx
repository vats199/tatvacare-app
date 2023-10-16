import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import Button from '../atoms/Button';
import DropdownComponent from '../atoms/Dropdown';
import {colors} from '../../constants/colors';
import {Icons} from '../../constants/icons';

type AddDietProps = {
  onPressAdd: () => void;
  buttonText: string;
  onSeleteQty: (qty: string) => void;
  measureUnit:string
};

const AddDiet: React.FC<AddDietProps> = ({
  onPressAdd,
  buttonText,
  onSeleteQty,measureUnit
}) => {
  const data = [
    {label: '1', value: '1'},
    {label: '2', value: '2'},
    {label: '3', value: '3'},
    {label: '4', value: '4'},
    {label: '5', value: '5'},
  ];
  const handleSelectedQty = (ietm: string) => {
    onSeleteQty(ietm);
  };
  const handleSelectedMeasures = (ietm: string) => {};

  return (
    <View style={styles.container}>
      <View style={styles.innerContainer}>
        <Text style={styles.title}>Add Roti as Breakfast</Text>
        <View style={styles.borderline} />
        <View style={styles.belowBox}>
          <View style={styles.belowBoxContent}>
            <View style={styles.dropdownContainer}>
              <DropdownComponent
                data={data}
                dropdownStyle={{width: '48%'}}
                placeholder="Quality"
                placeholderStyle={styles.dropdownTitleText}
                selectedItem={handleSelectedQty}
                isDisable={false}
              />
              {/* <DropdownComponent
                data={data}
                dropdownStyle={{ width: '48%' }}
                placeholder="Measure"
                placeholderStyle={styles.dropdownTitleText}
                 isDisable={true}
                selectedItem={handleSelectedMeasures}
              /> */}
              <View style={styles.measureContainer}>
                <Text style={styles.dropdownTitleText}>{measureUnit}</Text>
                <Icons.DropdownIcon />
              </View>
            </View>
            <Button
              title={buttonText}
              titleStyle={styles.outlinedButtonText}
              buttonStyle={styles.outlinedButton}
              onPress={onPressAdd}
            />
          </View>
        </View>
      </View>
    </View>
  );
};

export default AddDiet;

const styles = StyleSheet.create({
  container: {
    borderWidth: 0.1,
    borderColor: '#808080',
    overflow: 'hidden',
    borderRadius: 14,
    margin: 5,
    elevation: 8,
  },
  innerContainer: {
    backgroundColor: 'white',
  },
  title: {
    marginLeft: 14,
    marginVertical: 20,
    fontSize: 17,
    fontWeight: 'bold',
    color: colors.black,
  },
  borderline: {
    borderBottomWidth: 0.2,
    borederColor: colors.lightGrey,
  },
  belowBox: {
    paddingHorizontal: 16,
    paddingBottom: 20,
  },
  belowBoxContent: {
    width: '100%',
  },
  dropdownContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 25,
  },
  dropdownTitleText: {
    fontSize: 17,
    paddingLeft: 7,
    color: colors.black,
  },
  outlinedButtonText: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  outlinedButton: {
    padding: 10,
    borderRadius: 16,
  },
  measureContainer: {
    borderRadius: 10,
    borderWidth: 0.4,
    width: '50%',
    height: '98%',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 8,
  },
});