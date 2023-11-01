import {
  FlatList,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import React from 'react';
import {goBackFromChat} from '../routes/Router';
import {useApp} from '../context/app.context';
import {Screen} from '../components/styled/Views';
import ChatScreenHeader from '../components/atoms/ChatScreenHeader';
import ChatDisclaimer from '../components/atoms/ChatDisclaimer';
import {GiftedChat} from 'react-native-gifted-chat';
import {StackScreenProps} from '@react-navigation/stack';
import {AppStackParamList} from '../interface/Navigation.interface';
import ChatbotMessage from '../components/atoms/ChatbotMessage';
import UserMessage from '../components/atoms/UserMessage';
import ChatbotMessageLoader from '../components/atoms/ChatbotMessageLoader';
import moment from 'moment';
import {colors} from '../constants/colors';
import {Icons} from '../constants/icons';

type ChatScreenProps = StackScreenProps<AppStackParamList, 'ChatScreen'>;

type Message = {
  sender: 'bot' | 'user';
  message: string;
};

const ChatScreen: React.FC<ChatScreenProps> = ({navigation, route}) => {
  const {
    userData: {patient_id},
  } = useApp();

  const onPressGoBack = () => {
    goBackFromChat();
  };

  const [initialTime, setInitialTime] = React.useState<string>('');
  const [messages, setMessages] = React.useState<Message[]>([]);
  const [loading, setLoading] = React.useState<boolean>(false);
  const [msg, setMsg] = React.useState<string>('');

  const initialMessage: Message = {
    sender: 'bot',
    message:
      "Hello, \nI'm your health assistant, you can ask or share any health related problem with me",
  };

  const onPressSend = async () => {
    const userMsg: Message = {
      message: msg,
      sender: 'user',
    };
    setMessages([userMsg, ...messages]);
    setLoading(true);

    const headers = {
      Accept: 'application/json',
    };
    const url = `http://20.243.170.91:8002/bot?query=${encodeURIComponent(
      JSON.stringify(msg),
    )}&id=${patient_id}`;

    try {
      const res = await fetch(url, {method: 'post', headers});
      const response = await res.json();
      console.log(response);
      const botReply: Message = {
        message: response,
        sender: 'bot',
      };
      setMessages([botReply, userMsg, ...messages]);
    } catch (error) {
      console.log(error);
    }
    setMsg('');
    setLoading(false);
  };

  React.useEffect(() => {
    setInitialTime(new Date().toISOString());
    setMessages([initialMessage]);
  }, []);

  const renderMessages = ({item, index}: {item: Message; index: number}) => {
    switch (item.sender) {
      case 'bot':
        return <ChatbotMessage message={item.message} />;
      case 'user':
        return <UserMessage message={item.message} />;
    }
  };

  return (
    <Screen>
      <ChatScreenHeader onPressBack={onPressGoBack} />
      <ChatDisclaimer />
      <View style={styles.chatContainer}>
        <Text style={styles.initTime}>
          {moment(initialTime).format('ddd, hh:mm A')}
        </Text>
        <FlatList
          data={messages}
          keyExtractor={(_item, index) => index.toString()}
          renderItem={renderMessages}
          bounces={false}
          inverted
          showsVerticalScrollIndicator={false}
          ListHeaderComponent={() =>
            loading ? <ChatbotMessageLoader loading={loading} /> : <></>
          }
        />
      </View>
      {!loading && (
        <View style={styles.inputContainer}>
          <View style={styles.textInputContainer}>
            <TextInput
              placeholder={'Type a message...'}
              value={msg}
              onChangeText={e => setMsg(e)}
              keyboardType={'default'}
              multiline
              style={{flex: 1}}
            />
          </View>
          <TouchableOpacity
            onPress={onPressSend}
            disabled={msg.length <= 0}
            activeOpacity={0.6}>
            {msg.length > 0 ? <Icons.SendActive /> : <Icons.SendInactive />}
          </TouchableOpacity>
        </View>
      )}
    </Screen>
  );
};

export default ChatScreen;

const styles = StyleSheet.create({
  chatContainer: {
    flex: 1,
    backgroundColor: 'transparent',
    paddingHorizontal: 16,
  },
  initTime: {
    alignSelf: 'center',
    marginVertical: 8,
    color: colors.darkGray,
    fontWeight: '500',
    fontSize: 12,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    gap: 16,
    backgroundColor: colors.white,
  },
  textInputContainer: {
    flex: 1,
    borderWidth: 0.5,
    borderRadius: 24,
    paddingVertical: 10,
    paddingHorizontal: 12,
    borderColor: colors.darkGray,
  },
});
