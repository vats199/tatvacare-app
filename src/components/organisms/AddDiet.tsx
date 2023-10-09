import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import Button from '../Atoms/Button';
import DropdownComponent from '../Atoms/Dropdown';
import {colors} from '../../constants/colors';

type AddDietProps = {
  onPressAdd: () => void;
};

const AddDiet: React.FC<AddDietProps> = ({onPressAdd}) => {
  const data = [
    {label: 'Item 1', value: '1'},
    {label: 'Item 2', value: '2'},
    {label: 'Item 3', value: '3'},
  ];

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
              />
              <DropdownComponent
                data={data}
                dropdownStyle={{width: '48%'}}
                placeholder="Measure"
                placeholderStyle={styles.dropdownTitleText}
              />
            </View>
            <Button
              title="Add"
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
});
