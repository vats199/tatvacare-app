import { Image, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React, { useEffect, useRef, useState } from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container } from '../components/styled/Views'
import { Icons } from '../constants/icons'
import { colors } from '../constants/colors'
import InputField from '../components/atoms/InputField'
import CarePlanView from '../components/organisms/CarePlanView'
import HealthTip from '../components/organisms/HealthTip'
import MyHealthInsights from '../components/organisms/MyHealthInsights'
import MyHealthDiary from '../components/organisms/MyHealthDiary'
import HomeHeader from '../components/molecules/HomeHeader'
import Aes from 'react-native-aes-crypto';
import CRYPTO from 'react-native-crypto-js';

type HomeScreenProps = CompositeScreenProps<
    BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
    NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {

    const [search, setSearch] = React.useState<string>('')

    const generateKey = (password: string, salt: any, cost: any, length: any) =>
        Aes.pbkdf2(password, salt, cost, length);

    const encryptData = (text: any, key: any) => {
        return Aes.randomKey(16).then(iv => {
            return Aes.encrypt(text, key, iv, 'aes-256-cbc').then(cipher => ({
                cipher,
                iv,
            }));
        });
    };

    const decryptData = (encryptedData: any, key: any) =>
        Aes.decrypt(encryptedData.cipher, key, encryptedData.iv, 'aes-256-cbc');

    const fullData = () => {
        try {
            generateKey('Arnold', 'salt', 5000, 256).then(key => {
                console.log('Key:', key);
                encryptData(JSON.stringify({ "otp": "1234", "contact_no": "8511449158" }), key)
                    .then(({ cipher, iv }) => {
                        console.log('Encrypted:', cipher);

                        decryptData({ cipher, iv }, key)
                            .then(text => {
                                console.log('Decrypted:', text);
                            })
                            .catch(error => {
                                console.log(error);
                            });

                        Aes.hmac256(cipher, key).then(hash => {
                            console.log('HMAC', hash);
                        });
                    })
                    .catch(error => {
                        console.log(error);
                    });
            });
        } catch (e) {
            console.error(e);
        }
    };
    useEffect(() => {
        // crypto();
    }, []);

    const crypto = () => {
        let ciphertext = CRYPTO.AES.encrypt(JSON.stringify({ "otp": "1234", "contact_no": "8511449158" }), '9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6').toString();

        let bytes = CRYPTO.AES.decrypt('DiSWOCdgv9zLnzuSJg2MwzjLMDx+BS59v+OM+S4U5DFqSxFBKuqTWl6xHAm4EEh/', '9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6');
        let originalText = bytes.toString(CRYPTO.enc.Utf8)

        return {
            cipher: ciphertext,
            originalText: originalText
        }

    }

    const onPressLocation = () => { }
    const onPressBell = () => {
        
        const crypt = crypto();
        console.log(crypt);
        
     }
    const onPressProfile = () => { }
    const onPressDevices = () => { }
    const onPressDiet = () => { }
    const onPressExercise = () => { }
    const onPressMedicine = () => { }
    const onPressMyIncidents = () => { }

    return (
        <Container>
            <ScrollView showsVerticalScrollIndicator={false}>
                <HomeHeader
                    onPressBell={onPressBell}
                    onPressLocation={onPressLocation}
                    onPressProfile={onPressProfile}
                />
                <Text style={styles.goodMorning}>Good Morning Test!</Text>
                <View style={styles.searchContainer}>
                    <Icons.Search />
                    <InputField
                        value={search}
                        onChangeText={e => setSearch(e)}
                        placeholder={'Find resources to manage your condition'}
                        style={styles.searchField}
                    />
                </View>
                <CarePlanView />
                <HealthTip />
                <MyHealthInsights />
                <MyHealthDiary
                    onPressDevices={onPressDevices}
                    onPressDiet={onPressDiet}
                    onPressExercise={onPressExercise}
                    onPressMedicine={onPressMedicine}
                    onPressMyIncidents={onPressMyIncidents}
                />
            </ScrollView>
        </Container>
    )
}

export default HomeScreen

const styles = StyleSheet.create({
    goodMorning: {
        color: colors.black,
        fontSize: 16,
        fontWeight: '700',
        marginVertical: 15
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.subTitleLightGray,
        borderRadius: 12,
        paddingHorizontal: 10
    },
    searchField: {
        borderWidth: 0,
        flex: 1,
    },
})