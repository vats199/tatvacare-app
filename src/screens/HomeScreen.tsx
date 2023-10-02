import { Alert, Image, ScrollView, StyleSheet, Text, TouchableOpacity, View, NativeModules, requireNativeComponent, SafeAreaView } from 'react-native'
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
import RNShare from '../native/RNShare'
import { navigateTo, navigateToPlan, navigateToMedicines, navigateToEngagement, navigateToIncident, openAlert, openHealthKitSyncView } from '../routes/Router'
import Home from '../api/home'
import AsyncStorage from '@react-native-async-storage/async-storage'

type HomeScreenProps = CompositeScreenProps<
    DrawerScreenProps<DrawerParamList, 'HomeScreen'>,
    NativeStackScreenProps<AppStackParamList, 'DrawerScreen'>
>

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {
    // const CounterView = requireNativeComponent("CounterView")
    const [search, setSearch] = React.useState<string>('')
    const [location, setLocation] = React.useState<object>({})
    const [visible, setVisible] = React.useState<boolean>(false)
    const [carePlanData, setCarePlanData] = React.useState<any>({})
    const [learnMoreData, setLearnMoreData] = React.useState<any>([])
    const [healthInsights, setHealthInsights] = React.useState<any>({})
    const [healthDiaries, setHealthDiaries] = React.useState<any>([])

    const inputRef = useRef<AnimatedInputFieldRef>(null)

    useEffect(() => {
        getCurrentLocation()
        getHomeCarePlan()
        getLearnMoreData()
        getPlans()
        getMyHealthInsights()
        getMyHealthDiaries()
    }, [])

    const getCurrentLocation = async () => {
        const currentLocation = await AsyncStorage.getItem('location');

       await setLocation(currentLocation ? JSON.parse(currentLocation) : {})

          //call for health kit sync
          await openHealthKitSyncView()
    }

    const getGreetings = () => {
        const currentHour = new Date().getHours();

        if (currentHour > 5 && currentHour < 12) {
            return 'Good Morning'
        } else if (currentHour >= 12 && currentHour < 16) {
            return 'Good Afternoon'
        } else if (currentHour >= 16 && currentHour < 21) {
            return 'Good Evening'
        } else {
            return 'Good Night'
        }
    }

    const getHomeCarePlan = async () => {

        const homeCarePlan = await Home.getPatientCarePlan({})
        console.log(homeCarePlan?.data?.patient_plans, 'homeCarePlanhomeCarePlanhomeCarePlan');


        setCarePlanData(homeCarePlan?.data)
    }

    const getLearnMoreData = async () => {

        const learnMore = await Home.getLearnMoreData({});
        console.log('learnMorelearnMorelearnMorelearnMore');

        setLearnMoreData(learnMore?.data)
    }

    const getPlans = async () => {

        const allPlans = await Home.getHomePagePlans({}, { page: 0 })

    }

    const getMyHealthInsights = async () => {
        const insights = await Home.getMyHealthInsights({})
        console.log(insights?.data, 'insightsinsightsinsights');
        setHealthInsights(insights?.data)
    }

    const getMyHealthDiaries = async () => {
        const diaries = await Home.getMyHealthDiaries({});

        setHealthDiaries(diaries?.data)
    }

    const onPressLocation = () => { }
    const onPressBell = () => {
        navigateTo('NotificationVC');

    }
    const onPressProfile = () => {
        navigation.toggleDrawer();
    }
    const onPressDevices = () => {
        navigateTo('MyDevices');
    }
    const onPressDiet = () => {
        navigateTo('FoodDiaryParentVC')
        // navigateTo('PlanDetailsVC');
    }
    const onPressExercise = () => { navigateTo('ExerciseParentVC'); }
    const onPressMedicine = () => {


        navigateToMedicines('test');
    }
    const onPressMyIncidents = () => {
        navigateToIncident();
    }

    const onPressConsultNutritionist = () => { navigateTo('AppointmentsHistoryVC') }
    const onPressConsultPhysio = () => {
        navigateTo('AppointmentsHistoryVC')
    }
    const onPressBookDiagnostic = () => {
        navigateTo('LabTestListVC')
            ;
    }
    const onPressBookDevices = () => {

        // navigateTo('SearchDeviceVC');
        navigateTo('MyDevices');

    }
    const onPressCarePlan = () => {


        // navigateTo('BCPCarePlanDetailVC');
        navigateToPlan('navigateToPlan');
    }
    const onPressRow1 = (filteredData: any, firstRow: any) => {


        // navigateTo('BCPCarePlanDetailVC');
        openAlert([{filteredData: filteredData},{ firstRow : firstRow}]);
    }

    const onPressLearnItem = (contentId: string, contentType:string) => {
        navigateToEngagement(contentId.toString())
    }

    const onPressBookmark = async (data: any) => {
        if (data?.bookmarked !== 'Y') {
            const payload = {
                content_master_id: data?.content_master_id,
                is_active: data?.is_active
            }
            const resp = await Home.addBookmark({}, payload);

            if (resp?.data) {
                getLearnMoreData()
            }
        }
    }

    return (
        <>
            <Screen>
                <Container>
                    <HomeHeader
                        onPressBell={onPressBell}
                        onPressLocation={onPressLocation}
                        onPressProfile={onPressProfile}
                        userLocation={location}
                    />
                    <Text style={styles.goodMorning}>{getGreetings()} Test!</Text>
                    <View style={styles.searchContainer}>
                        <Icons.Search />
                        <InputField
                            value={search}
                            onChangeText={e => setSearch(e)}
                            placeholder={'Find resources to manage your condition'}
                            style={styles.searchField}
                            // onFocus={() => { setVisible(true); inputRef.current?.blur(); navigateTo('GlobalSearchParentVC') }}
                            onFocus={() => { navigateTo('GlobalSearchParentVC'), console.log('onFocus========>') }}
                            ref={inputRef}
                        />
                    </View>
                    <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={{ paddingBottom: 70 }}>
                        <CarePlanView data={carePlanData} onPressCarePlan={onPressCarePlan} />
                        {carePlanData?.doctor_says?.description && <HealthTip tip={carePlanData?.doctor_says} />}
                        <MyHealthInsights data={healthInsights} onPressRow1={onPressRow1} />
                        <MyHealthDiary
                            onPressDevices={onPressDevices}
                            onPressDiet={onPressDiet}
                            onPressExercise={onPressExercise}
                            onPressMedicine={onPressMedicine}
                            onPressMyIncidents={onPressMyIncidents}
                            data={healthDiaries}
                        />
                        <AdditionalCareServices
                            onPressConsultNutritionist={onPressConsultNutritionist}
                            onPressConsultPhysio={onPressConsultPhysio}
                            onPressBookDiagnostic={onPressBookDiagnostic}
                            onPressBookDevices={onPressBookDevices}
                        />
                        {learnMoreData?.length > 0 && <Learn onPressBookmark={onPressBookmark} data={learnMoreData} onPressItem={onPressLearnItem} />}
                    </ScrollView>
                </Container>
            </Screen>
            <SearchModal visible={visible} setVisible={setVisible} search={search} setSearch={setSearch} />
        </>
    )
}

export default HomeScreen

const styles = StyleSheet.create({
    goodMorning: {
        color: colors.black,
        fontSize: 16,
        fontWeight: '700',
        marginVertical: 15,
        lineHeight: 20
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: 12,
        paddingHorizontal: 10,
        marginBottom: 10
    },
    searchField: {
        borderWidth: 0,
        flex: 1,
    },
})