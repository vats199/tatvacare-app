import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

type MessageItemProps = {
  message: string;
};

const UserMessage: React.FC<MessageItemProps> = ({message}) => {
  return (
    <View style={styles.container}>
      <View style={styles.msgContainer}>
        <Text style={styles.message}>{message}</Text>
      </View>
    </View>
  );
};

export default UserMessage;

const styles = StyleSheet.create({
  container: {
    alignSelf: 'flex-end',
    marginBottom: 8,
  },
  msgContainer: {
    width: '80%',
    paddingHorizontal: 16,
    paddingVertical: 10,
    backgroundColor: colors.themePurple,
    borderBottomLeftRadius: 24,
    borderTopRightRadius: 24,
    borderTopLeftRadius: 24,
  },
  message: {
    color: colors.white,
    fontSize: 16,
    fontWeight: '400',
  },
});
