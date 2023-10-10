import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import AsyncStorage from '@react-native-async-storage/async-storage'
import { CommonActions, CompositeScreenProps } from '@react-navigation/native';
import { AppStackParamList, AuthStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import SplashScreen from 'react-native-splash-screen';
import { useApp } from '../../context/app.context';
type SplahScreenProps = CompositeScreenProps<
    StackScreenProps<AuthStackParamList, 'Splash'>,
    StackScreenProps<AppStackParamList, 'AuthStackScreen'>
>;

const Splash: React.FC<SplahScreenProps> = ({ navigation, route }) => {

    const { setUserData } = useApp()

    React.useEffect(() => {
        checkAuthentication()
    }, [])

    const checkAuthentication = async () => {
        let isUserLoggedIn = await AsyncStorage.getItem("isUserLoggedIn")
        if (isUserLoggedIn == 'true') {
            let userData = await AsyncStorage.getItem("userData")
            setUserData(JSON.parse(userData))
            SplashScreen.hide()
            navigation.dispatch(
                CommonActions.reset({
                    index: 0,
                    routes: [{ name: 'DrawerScreen' }],
                }),
            );
        } else {
            SplashScreen.hide()
            navigation.dispatch(
                CommonActions.reset({
                    index: 0,
                    routes: [{ name: 'OnBoardingScreen' }],
                }),
            );
        }
    }

    return (
        <View>
            {/* <Text>Splash</Text> */}
        </View>
    )
}

export default Splash

const styles = StyleSheet.create({})