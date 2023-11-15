import {
  FlatList,
  Image,
  StyleSheet,
  Text,
  View,
  Modal,
  KeyboardAvoidingView,
} from 'react-native';
import React from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import {
  AppStackParamList,
  AuthStackParamList,
} from '../../interface/Navigation.interface';
import { useSafeAreaInsets, SafeAreaView } from 'react-native-safe-area-context';
import { StackScreenProps } from '@react-navigation/stack';
import { OtpStyle as styles } from './styles';
import OTPInputView from '@twotalltotems/react-native-otp-input';
import { Matrics } from '../../constants';
import { TouchableOpacity } from 'react-native-gesture-handler';
import AuthHeader from '../../components/molecules/AuthHeader';
import Auth from '../../api/auth';
import { useApp } from '../../context/app.context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Loader from '../../components/atoms/Loader';
import { useDispatch } from 'react-redux';
import * as actions from '../../redux/slices';

type OTPScreenProps = CompositeScreenProps<
  StackScreenProps<AuthStackParamList, 'OTPScreen'>,
  StackScreenProps<AppStackParamList, 'AuthStackScreen'>
>;

const OTPScreen: React.FC<OTPScreenProps> = ({ navigation, route }) => {
  const dispatch = useDispatch();
  const insets = useSafeAreaInsets();

  const intervalRef = React.useRef<null | NodeJS.Timeout>(null);
  const { setUserData } = useApp();
  const [otp, setOtp] = React.useState<string>('');
  const [timer, setTimer] = React.useState<number>(30);
  const [isLoading, setIsLoading] = React.useState<boolean>(false);

  React.useEffect(() => {
    //Implementing the setInterval method
    intervalRef.current = setInterval(() => {
      if (timer > 0) setTimer(timer - 1);
    }, 1000);

    //Clearing the interval
    return () => clearInterval(intervalRef.current as NodeJS.Timeout);
  }, [timer]);

  const onPressResendCode = () => {
    setTimer(30);
  };

  const onCodeFilled = async (code: string) => {
    let payload = {
      contact_no: route?.params?.contact_no.trim(),
      otp: code,
    };

    new Promise((resolve, reject) => {
      if (route?.params?.isLoginOTP) {
        dispatch(
          actions.verifyLoginOtpRequest({
            payload,
            resolve,
            reject,
          }),
        );
      } else {
        dispatch(
          actions.verifySignUpOtpRequest({
            payload,
            resolve,
            reject,
          }),
        );
      }
    })
      .then(res => {
        //TODO: set token for user on global
        //   await AsyncStorage.setItem('accessToken', userData?.token);
        console.log(res, 'resssssss');
        navigation.navigate('DrawerScreen'); // TODO: manange setup profile according to response
      })
      .catch(err => {
        console.log(err);
      });
  };

  return (
    <SafeAreaView edges={['bottom', 'top']} style={styles.container}>
      <AuthHeader
        onPressBack={() => {
          navigation.goBack();
        }}
      />
      <View>
        <Text style={styles.title}>{`OTP Verification`}</Text>
        <Text style={styles.description}>
          {`Please enter the OTP, we have sent to your phone number `}
          <Text style={styles.nestedBoldText}>
            {`+91-${route?.params?.contact_no}`}
          </Text>
        </Text>

        <OTPInputView
          style={{ height: Matrics.vs(80) }}
          pinCount={6}
          // code={this.state.code} //You can supply this prop or not. The component will be used as a controlled / uncontrolled component respectively.
          // onCodeChanged = {code => { this.setState({code})}}
          autoFocusOnLoad={true}
          codeInputFieldStyle={styles.underlineStyleBase}
          codeInputHighlightStyle={styles.underlineStyleHighLighted}
          onCodeFilled={code => {
            onCodeFilled(code);
            // setTimer(30.)
            // clearInterval(intervalRef.current as NodeJS.Timeout)
            console.log(`Code is ${code}, you are good to go!`);
          }}
        />

        <View style={styles.resendCont}>
          <Text style={styles.resendDesc}>{`Didn’t receive OTP? `}</Text>
          <TouchableOpacity
            activeOpacity={0.7}
            onPress={() => onPressResendCode()}>
            <Text
              style={timer != 0 ? styles.resendNestedTest : styles.resendCode}>
              {timer != 0 ? `Resend code in ${timer}sec` : `Resend Code`}
            </Text>
          </TouchableOpacity>
        </View>
      </View>
      <Loader visible={isLoading} />
    </SafeAreaView>
  );
};

export default OTPScreen;