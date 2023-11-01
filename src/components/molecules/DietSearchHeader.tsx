import {StyleSheet, View, TextInput, TouchableOpacity} from 'react-native';
import React, {useEffect, useState} from 'react';
import {Icons} from '../../constants/icons';
import Matrics from '../../constants/Matrics';

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
    const spaceFree = text.trimStart();
    const cleanedText = spaceFree.replace(/[^a-zA-Z\s]/g, '');
    setSearchText(cleanedText);
    onSearch(text);
  };
  return (
    <View style={styles.container}>
      <TouchableOpacity activeOpacity={0.7} hitSlop={15} onPress={onPressBack}>
        <Icons.backArrow height={22} width={22} />
      </TouchableOpacity>
      <TextInput
        style={styles.input}
        placeholder="Search foods"
        placeholderTextColor="gray"
        value={searchText}
        onChangeText={text => {
          handleSerache(text);
        }}
        keyboardType="ascii-capable"
      />
    </View>
  );
};

export default DietSearchHeader;

const styles = StyleSheet.create({
  container: {
    width: '100%',
    flexDirection: 'row',
    marginBottom: Matrics.vs(30),
    alignItems: 'center',
    marginTop: Matrics.vs(10),
  },
  input: {
    width: '90%',
    height: Matrics.vs(42),
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: 'black',
    backgroundColor: 'white',
    borderRadius: 6,
    marginHorizontal: 10,
    paddingLeft: 15,
    fontSize: Matrics.vs(12),
    color: 'gray',
  },
});
