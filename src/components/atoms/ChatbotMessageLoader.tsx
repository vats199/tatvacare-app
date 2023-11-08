import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import LottieView from 'lottie-react-native';

type ChatbotMessageLoaderProps = {
  loading: boolean;
};

const ChatbotMessageLoader: React.FC<ChatbotMessageLoaderProps> = ({
  loading,
}) => {
  return (
    <View style={styles.container}>
      <Icons.ChatBotIcon />
      <LottieView
        autoPlay
        loop
        style={{height: 50, width: 50}}
        source={require('../../assets/images/response_loading.json')}
      />
    </View>
  );
};

export default ChatbotMessageLoader;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignSelf: 'flex-start',
    alignItems: 'center',
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
