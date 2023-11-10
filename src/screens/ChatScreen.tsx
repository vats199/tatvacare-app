import {
  Dimensions,
  FlatList,
  Keyboard,
  KeyboardAvoidingView,
  NativeModules,
  Platform,
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useState} from 'react';
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
import {trackEvent} from '../helpers/TrackEvent';

type ChatScreenProps = StackScreenProps<AppStackParamList, 'ChatScreen'>;

type Message = {
  sender: 'bot' | 'user';
  message: string;
};

const ChatScreen: React.FC<ChatScreenProps> = ({navigation, route}) => {
  // const {
  //   userData: {patient_id},
  // } = useApp();

  let patient_id: string = 'adsdasaAADS1234das';

  const [keyboardStatus, setKeyboardStatus] = useState<boolean>(false);

  const onPressGoBack = () => {
    if (Platform.OS == 'ios') {
      goBackFromChat();
    } else {
      NativeModules.AndroidBridge.onBackPressed();
    }
  };

  const scrollRef = React.useRef<ScrollView>(null);

  const [initialTime, setInitialTime] = React.useState<string>('');
  const [loading, setLoading] = React.useState<boolean>(false);
  const [msg, setMsg] = React.useState<string>('');
  const [lastBotReply, setLastBotReply] = React.useState<string>('');
  const [bot_chat, setBotChat] = React.useState<boolean>(false);
  const [welcome_message, setWelcomeMessage] = React.useState<boolean>(false);
  const [welcome_message_validation, setWelcomeMessageValidation] =
    React.useState<boolean>(false);
  const [conversation, setConversation] = React.useState<any[]>([]);
  const [messages, setMessages] = React.useState<Message[]>([]);

  const welcomeUser = async () => {
    setLoading(true);
    const payload = {
      id: patient_id,
      bot_chat: false,
      welcome: true,
      welcome_message_validation: false,
    };
    const headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    };
    const url = 'https://mytatva.azurewebsites.net/welcome';

    try {
      const res = await fetch(url, {
        method: 'post',
        headers,
        body: JSON.stringify(payload),
      });
      const response = await res.json();
      const {
        bot_response,
        conversation,
        bot_chat,
        welcome_message,
        welcome_message_validation,
      } = response;
      setLastBotReply(bot_response);
      setMessages([{message: bot_response, sender: 'bot'}]);
      setConversation(conversation);
      setWelcomeMessage(welcome_message);
      setWelcomeMessageValidation(welcome_message_validation);
      setBotChat(bot_chat);
    } catch (error) {
      console.log(error);
    }
    setMsg('');
    setLoading(false);
  };

  const sendMessage = async () => {
    // trackEvent("USER_TAP_ENTER",{})
    setLoading(true);
    setMessages([...messages, {sender: 'user', message: msg}]);
    const payload = {
      query: msg.trim(),
      id: patient_id,
      bot_chat,
      welcome_message,
      welcome_message_validation,
      conversation,
      bot_response: lastBotReply,
    };
    const headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    };
    const url = 'https://mytatva.azurewebsites.net/bot';

    try {
      const res = await fetch(url, {
        method: 'post',
        headers,
        body: JSON.stringify(payload),
      });
      const response = await res.json();
      const {
        bot_chat,
        bot_response,
        conversation,
        welcome_message,
        welcome_message_validation,
      } = response;
      setBotChat(bot_chat);
      setLastBotReply(bot_response);
      setWelcomeMessage(welcome_message);
      setWelcomeMessageValidation(welcome_message_validation);
      setConversation(conversation);
      if (!bot_chat && !welcome_message && !welcome_message_validation) {
        setMessages([
          ...messages,
          {sender: 'user', message: msg},
          {sender: 'bot', message: bot_response},
          {sender: 'bot', message: 'Thank You'},
        ]);
      } else {
        setMessages([
          ...messages,
          {sender: 'user', message: msg},
          {sender: 'bot', message: bot_response},
        ]);
      }
    } catch (error) {
      console.log(error);
    }
    setMsg('');
    setLoading(false);
  };

  React.useEffect(() => {
    setInitialTime(new Date().toISOString());
    welcomeUser();
  }, []);

  React.useEffect(() => {
    const keyboardDidShowListener = Keyboard.addListener(
      'keyboardDidShow',
      () => {
        setKeyboardStatus(true),
          scrollRef.current?.scrollToEnd({animated: true});
      },
    );

    const keyboardDidHideListener = Keyboard.addListener(
      'keyboardDidHide',
      () => {
        setKeyboardStatus(false);
      },
    );

    return () => {
      keyboardDidShowListener.remove();
      keyboardDidHideListener.remove();
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
        <KeyboardAvoidingView
          {...(Platform.OS == 'ios'
            ? {behavior: 'padding'}
            : {behavior: 'height'})}
          style={{flex: 1}}>
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
            <View
              style={[
                styles.inputContainer,
                {
                  marginBottom:
                    Platform.OS == 'android'
                      ? keyboardStatus
                        ? StatusBar.currentHeight
                        : 0
                      : 0,
                },
              ]}>
              <View style={styles.textInputContainer}>
                <TextInput
                  placeholder={'Type a message...'}
                  placeholderTextColor={'#72777A'}
                  value={msg}
                  onChangeText={e => setMsg(e)}
                  keyboardType={
                    Platform.OS == 'ios' ? 'ascii-capable' : 'visible-password'
                  }
                  // returnKeyType='next'
                  multiline
                  numberOfLines={3}
                  style={{
                    maxHeight: 68,
                    paddingTop: 0,
                    ...(Platform.OS == 'android' && {paddingBottom: 0}),
                  }}
                />
              </View>
              <TouchableOpacity
                onPress={sendMessage}
                disabled={msg.trim().length <= 0}
                activeOpacity={0.6}>
                {msg.trim().length > 0 ? (
                  <Icons.SendActive />
                ) : (
                  <Icons.SendInactive />
                )}
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
    paddingVertical: Platform.OS == 'ios' ? 12 : 0,
    paddingHorizontal: 16,
    borderColor: colors.darkGray,
  },
});
