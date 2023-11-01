import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';

type ChatScreenHeaderProps = {
  onPressBack: () => void;
};

const ChatScreenHeader: React.FC<ChatScreenHeaderProps> = ({
  onPressBack = () => {},
}) => {
  return (
    <View style={styles.container}>
      <TouchableOpacity activeOpacity={0.6} onPress={onPressBack}>
        <Icons.BackIcon />
      </TouchableOpacity>
      <Text style={styles.header}>Ask About Health</Text>
    </View>
  );
};

export default ChatScreenHeader;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
  },
  header: {
    color: colors.labelDarkGray,
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 16,
  },
});
