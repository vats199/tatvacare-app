import {StyleSheet, View, TextInput} from 'react-native';
import React, {useState} from 'react';
import {Icons} from '../../constants/icons';
import {Matrics} from '../../constants';

type DietSearchHeaderProps = {
  onPressBack: () => void;
  onSearch: (text: string) => void;
};

const DietSearchHeader: React.FC<DietSearchHeaderProps> = ({
  onPressBack,
  onSearch,
}) => {
  const [searchText, setSearchText] = useState<string>('');

  const handleSerache = (text: string) => {
    const cleanedText = text.replace(/[^a-zA-Z\s]/g, '');
    setSearchText(cleanedText);
    onSearch(text);
  };
  return (
    <View style={styles.container}>
      <Icons.backArrow height={22} width={22} onPress={onPressBack} />
      <TextInput
        style={styles.input}
        placeholder="Search foods"
        placeholderTextColor="gray"
        value={searchText}
        onChangeText={text => {
          setSearchText(text);
          handleSerache(text);
        }}
      />
    </View>
  );
};

export default DietSearchHeader;

const styles = StyleSheet.create({
  container: {
    width: '100%',
    flexDirection: 'row',
    marginBottom: 30,
    marginTop: 20,
    alignItems: 'center',
    marginTop: Matrics.vs(10),
  },
  input: {
    width: '90%',
    height: 45,
    borderWidth: 0.2,
    borderColor: 'black',
    backgroundColor: 'white',
    borderRadius: 6,
    marginHorizontal: 10,
    paddingLeft: 15,
    fontSize: 16,
    color: 'gray',
  },
});
