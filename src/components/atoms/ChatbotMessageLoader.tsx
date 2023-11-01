import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';

type ChatbotMessageLoaderProps = {
  loading: boolean;
};

const ChatbotMessageLoader: React.FC<ChatbotMessageLoaderProps> = ({
  loading,
}) => {
  return (
    <View style={styles.container}>
      <Icons.ChatBotIcon />
      <View style={styles.row}>
        <View style={styles.greyDot} />
        <View style={styles.greyDot} />
        <View style={styles.greyDot} />
      </View>
    </View>
  );
};

export default ChatbotMessageLoader;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignSelf: 'flex-start',
    gap: 8,
    marginBottom: 8,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  greyDot: {
    height: 7,
    width: 7,
    borderRadius: 5,
    backgroundColor: 'grey',
  },
});
