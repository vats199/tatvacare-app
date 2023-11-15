import { View } from 'react-native';
import React from 'react';
import { CommonActions, CompositeScreenProps } from '@react-navigation/native';
import {
  AppStackParamList,
  AuthStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import SplashScreen from 'react-native-splash-screen';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { useSelector } from 'react-redux';
import { RootState } from '../../redux/Store';
type SplahScreenProps = CompositeScreenProps<
  StackScreenProps<AuthStackParamList, 'Splash'>,
  StackScreenProps<AppStackParamList, 'AuthStackScreen'>
>;

const Splash: React.FC<SplahScreenProps> = ({ navigation }) => {
  const { Auth } = useSelector((s: RootState) => s);
  React.useEffect(() => {
    checkAuthentication();
  }, []);

  const checkAuthentication = async () => {
    if (Auth.isUserLoggedIn == true) {
      SplashScreen.hide();
      navigation.dispatch(
        CommonActions.reset({
          index: 0,
          routes: [{ name: 'DrawerScreen' }],
        }),
      );
    } else {
      SplashScreen.hide();
      navigation.dispatch(
        CommonActions.reset({
          index: 0,
          routes: [{ name: 'OnBoardingScreen' }],
        }),
      );
    }
  };

  return <View>{/* <MyStatusbar /> */}</View>;
};

export default Splash;