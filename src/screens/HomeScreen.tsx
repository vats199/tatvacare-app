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
import CRYPTO from 'crypto-js';

type HomeScreenProps = CompositeScreenProps<
    BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
    NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {

    const [search, setSearch] = React.useState<string>('')

    const crypto = () => {

        var truncHexKey = CRYPTO.SHA256('9Ddyaf6rfywpiTvTiax2iq6ykKpaxgJ6').toString().substr(0, 32); // hex encode and truncate

        var key = CRYPTO.enc.Utf8.parse(truncHexKey);

        var iv = CRYPTO.enc.Utf8.parse('9Ddyaf6rfywpiTvT');

        var ciphertext = CRYPTO.AES.encrypt(JSON.stringify({ "otp": "1234", "contact_no": "8511449158" }), key, {
            iv: iv,
            mode: CRYPTO.mode.CBC,
        });

        var decryptedData = CRYPTO.AES.decrypt('mHseU7meqOo7S3aq/vgQmOpvmwrgUWFI0z63FEvwffP6imwite97eSgma2ah/ZAECejeQddtlWqzKep3MaGH5A==', key, {
            iv: iv,
            mode: CRYPTO.mode.CBC,
        });
        let str = null
        try {
            str = decryptedData.toString(CRYPTO.enc.Utf8)
        } catch (error) {
            console.log(error);
        }

        return {
            plainText: str
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