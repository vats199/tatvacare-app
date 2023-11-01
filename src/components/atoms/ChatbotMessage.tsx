import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';

type MessageItemProps = {
  message: string;
};

const ChatbotMessage: React.FC<MessageItemProps> = ({message}) => {
  return (
    <View style={styles.container}>
      <Icons.ChatBotIcon />
      <View style={styles.msgContainer}>
        <Text style={styles.message}>{message}</Text>
      </View>
    </View>
  );
};

export default ChatbotMessage;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignSelf: 'flex-start',
    gap: 8,
    marginBottom: 8,
  },
  msgContainer: {
    width: '75%',
    padding: 16,
    backgroundColor: colors.white,
    borderBottomLeftRadius: 24,
    borderTopRightRadius: 24,
    borderBottomRightRadius: 24,
  },
  message: {
    color: colors.labelDarkGray,
    fontSize: 16,
    fontWeight: '400',
  },
});
