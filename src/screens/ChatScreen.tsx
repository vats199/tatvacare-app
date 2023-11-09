import {
  Dimensions,
  FlatList,
  Keyboard,
  KeyboardAvoidingView,
  Platform,
  SafeAreaView,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
  useWindowDimensions,
} from 'react-native';
import React from 'react';
import {goBackFromChat} from '../routes/Router';
import {useApp} from '../context/app.context';
import {Screen} from '../components/styled/Views';
import ChatScreenHeader from '../components/atoms/ChatScreenHeader';
import ChatDisclaimer from '../components/atoms/ChatDisclaimer';
import {StackScreenProps} from '@react-navigation/stack';
import {AppStackParamList} from '../interface/Navigation.interface';
import ChatbotMessage from '../components/atoms/ChatbotMessage';
import UserMessage from '../components/atoms/UserMessage';
import ChatbotMessageLoader from '../components/atoms/ChatbotMessageLoader';
import moment from 'moment';
import {colors} from '../constants/colors';
import {Icons} from '../constants/icons';
import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';

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

  const scrollRef = React.useRef<ScrollView>(null);

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
      message: msg.trim(),
      sender: 'user',
    };
    setMessages([...messages, userMsg]);
    setLoading(true);

    const headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    };
    const body = {
      query: msg,
      id: 0,
      bot_chat: true,
      welcome_message: true,
      welcome_message_validation: true,
      conversation: [{}],
      bot_response: 'string',
    };
    const url = 'https://mytatva.azurewebsites.net/bot';

    try {
      const res = await fetch(url, {
        method: 'post',
        headers,
        body: JSON.stringify(body),
      });

      const response = await res.json();
      const {bot_response} = response;
      const botReply: Message = {
        message: bot_response,
        sender: 'bot',
      };
      setMessages([...messages, userMsg, botReply]);
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

  React.useEffect(() => {
    const keyboardDidShowListener = Keyboard.addListener(
      'keyboardDidShow',
      () => scrollRef.current?.scrollToEnd({animated: true}),
    );

    return () => {
      keyboardDidShowListener.remove();
    };
  }, []);

  const renderMessages = (item: Message, index: number) => {
    switch (item.sender) {
      case 'bot':
        return <ChatbotMessage message={item.message} key={index.toString()} />;
      case 'user':
        return <UserMessage message={item.message} key={index.toString()} />;
    }
  };

  return (
    <>
      <Screen>
        <KeyboardAvoidingView behavior={'padding'} style={{flex: 1}}>
          <ChatScreenHeader onPressBack={onPressGoBack} />
          <ChatDisclaimer />
          <ScrollView
            ref={scrollRef}
            onContentSizeChange={() =>
              scrollRef.current?.scrollToEnd({animated: true})
            }
            bounces={false}
            contentContainerStyle={styles.container}
            showsVerticalScrollIndicator={false}>
            <Text style={styles.initTime}>
              {moment(initialTime).format('ddd hh:mm A')}
            </Text>
            {messages.map(renderMessages)}
            {loading && <ChatbotMessageLoader loading={loading} />}
          </ScrollView>
          {!loading && (
            <View style={styles.inputContainer}>
              <View style={styles.textInputContainer}>
                <TextInput
                  placeholder={'Type a message...'}
                  placeholderTextColor={'#72777A'}
                  value={msg}
                  onChangeText={e => setMsg(e)}
                  keyboardType={
                    Platform.OS === 'ios' ? 'ascii-capable' : 'visible-password'
                  }
                  multiline
                  numberOfLines={3}
                  style={{
                    maxHeight: 68,
                    paddingTop: 0,
                  }}
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
        </KeyboardAvoidingView>
      </Screen>
      <SafeAreaView style={styles.bottomColor} />
    </>
  );
};

export default ChatScreen;

const styles = StyleSheet.create({
  bottomColor: {
    flex: 0,
    backgroundColor: colors.white,
  },
  container: {
    // flex: 1,
    paddingHorizontal: 16,
    paddingBottom: 16,
  },
  chatContainer: {
    flex: 1,
    backgroundColor: 'transparent',
    paddingHorizontal: 16,
  },
  initTime: {
    alignSelf: 'center',
    marginVertical: 8,
    color: '#72777A',
    lineHeight: 16,
    fontWeight: '500',
    fontSize: 12,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    gap: 16,
    backgroundColor: colors.white,
  },
  textInputContainer: {
    flex: 1,
    borderWidth: 0.5,
    borderRadius: 24,
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderColor: colors.darkGray,
  },
});
