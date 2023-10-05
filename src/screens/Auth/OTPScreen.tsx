import { FlatList, Image, StyleSheet, Text, View, Modal, KeyboardAvoidingView } from 'react-native';
import React from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import {
  AppStackParamList,
  AuthStackParamList
} from '../../interface/Navigation.interface';
import { useSafeAreaInsets, SafeAreaView } from 'react-native-safe-area-context';
import { StackScreenProps } from '@react-navigation/stack';
import { OtpStyle as styles } from './styles';
import OTPInputView from '@twotalltotems/react-native-otp-input'


type OTPScreenProps = CompositeScreenProps<
  StackScreenProps<AuthStackParamList, 'OTPScreen'>,
  StackScreenProps<AppStackParamList, 'AuthStackScreen'>
>;

const OTPScreen: React.FC<OTPScreenProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets()

  const [otp, setOtp] = React.useState<string>('')

  const onChangeText = (text: string) => {
    // setMobileNumber(text)
  }

  return (
    <SafeAreaView edges={['bottom']} style={styles.container}>
      <View>
        <Text style={styles.title}>{`OTP Verification`}</Text>
        <Text style={styles.description}>{`Please enter the OTP, we have sent to your phone number `}
          <Text style={styles.nestedBoldText}>
            {`+91-9999999999`}
          </Text>
        </Text>

        <OTPInputView
          style={{ width: '80%', height: 100, alignSelf: 'center' }}
          pinCount={6}
          // code={this.state.code} //You can supply this prop or not. The component will be used as a controlled / uncontrolled component respectively.
          // onCodeChanged = {code => { this.setState({code})}}
          autoFocusOnLoad
          // codeInputFieldStyle={styles.underlineStyleBase}
          // codeInputHighlightStyle={styles.underlineStyleHighLighted}
          onCodeFilled={(code) => {
            console.log(`Code is ${code}, you are good to go!`)
          }}
        />
      </View>
    </SafeAreaView>
  );
};

export default OTPScreen;

