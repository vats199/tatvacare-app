import { Image, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React, { useEffect, useRef, useState } from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList, DrawerParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container, Screen } from '../components/styled/Views'
import { Icons } from '../constants/icons'
import { colors } from '../constants/colors'
import InputField, { AnimatedInputFieldRef } from '../components/atoms/AnimatedInputField'
import CarePlanView from '../components/organisms/CarePlanView'
import HealthTip from '../components/organisms/HealthTip'
import MyHealthInsights from '../components/organisms/MyHealthInsights'
import MyHealthDiary from '../components/organisms/MyHealthDiary'
import HomeHeader from '../components/molecules/HomeHeader'
import CRYPTO from 'crypto-js';
import AdditionalCareServices from '../components/organisms/AdditionalCareServices'
import Learn from '../components/organisms/Learn'
import SearchModal from '../components/molecules/SearchModal'
import { DrawerScreenProps } from '@react-navigation/drawer'
import Home from '../api/home'

type HomeScreenProps = CompositeScreenProps<
    DrawerScreenProps<DrawerParamList, 'HomeScreen'>,
    NativeStackScreenProps<AppStackParamList, 'DrawerScreen'>
>

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {

    const [search, setSearch] = React.useState<string>('')
    const [visible, setVisible] = React.useState<boolean>(false)

    const inputRef = useRef<AnimatedInputFieldRef>(null)

    useEffect(() => {
        Home.getPatientCarePlan({})
    }, [])

    const onPressLocation = () => { }
    const onPressBell = () => {
    }
    const onPressProfile = () => {
        navigation.toggleDrawer()
    }
    const onPressDevices = () => { }
    const onPressDiet = () => { }
    const onPressExercise = () => { }
    const onPressMedicine = () => { }
    const onPressMyIncidents = () => { }

    const onPressConsultNutritionist = () => { }
    const onPressConsultPhysio = () => { }
    const onPressBookDiagnostic = () => { }
    const onPressBookDevices = () => { }

    return (
        <Screen>
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
                            onFocus={() => { setVisible(true); inputRef.current?.blur() }}
                            ref={inputRef}
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
                    <AdditionalCareServices
                        onPressConsultNutritionist={onPressConsultNutritionist}
                        onPressConsultPhysio={onPressConsultPhysio}
                        onPressBookDiagnostic={onPressBookDiagnostic}
                        onPressBookDevices={onPressBookDevices}
                    />
                    <Learn />
                </ScrollView>
                <SearchModal visible={visible} setVisible={setVisible} search={search} setSearch={setSearch} />
            </Container>
        </Screen>
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