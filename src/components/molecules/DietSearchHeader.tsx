import { StyleSheet, View, TextInput, TouchableOpacity } from 'react-native';
import React, { useState } from 'react';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { colors } from '../../constants/colors';
import { globalStyles } from '../../constants/globalStyles';

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
    const spaceFree = text.trimStart()
    const cleanedText = spaceFree.replace(/[^a-zA-Z\s]/g, '');
    setSearchText(cleanedText);
    onSearch(text);
  };
  return (
    <View style={styles.container}>
      <TouchableOpacity hitSlop={8} onPress={onPressBack}>
        <Icons.backArrow height={20} width={20} />
      </TouchableOpacity>
      <TextInput
        style={[globalStyles.shadowContainer, styles.input,]}
        placeholder="Search foods"
        placeholderTextColor="gray"
        value={searchText}
        onChangeText={text => {
          handleSerache(text)
        }}
        keyboardType='ascii-capable'
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
  },
  input: {
    flex: 1,
    height: Matrics.vs(38),
    borderWidth: Matrics.s(1),
    borderColor: colors.inputBoxLightBorder,
    backgroundColor: 'white',
    borderRadius: Matrics.s(12),
    marginLeft: Matrics.s(16),
    paddingHorizontal: Matrics.s(15),
    fontSize: Matrics.mvs(12),
    color: 'gray',
    shadowOpacity: 0.1,
    shadowRadius: 5
  },
});
