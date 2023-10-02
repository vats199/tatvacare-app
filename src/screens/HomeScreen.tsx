import {
  Alert,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  NativeModules,
  requireNativeComponent,
  SafeAreaView,
} from 'react-native';
import React, {useEffect, useRef, useState} from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {Container, Screen} from '../components/styled/Views';
import {Icons} from '../constants/icons';
import {colors} from '../constants/colors';
import InputField, {
  AnimatedInputFieldRef,
} from '../components/atoms/AnimatedInputField';
import CarePlanView from '../components/organisms/CarePlanView';
import HealthTip from '../components/organisms/HealthTip';
import MyHealthInsights from '../components/organisms/MyHealthInsights';
import MyHealthDiary from '../components/organisms/MyHealthDiary';
import HomeHeader from '../components/molecules/HomeHeader';
import AdditionalCareServices from '../components/organisms/AdditionalCareServices';
import Learn from '../components/organisms/Learn';
import SearchModal from '../components/molecules/SearchModal';
import {DrawerScreenProps} from '@react-navigation/drawer';
import {
  navigateTo,
  navigateToPlan,
  navigateToMedicines,
  navigateToEngagement,
  navigateToIncident,
  openUpdateReading,
  openHealthKitSyncView,
  openUpdateGoal,
  navigateToExercise,
  getHomeScreenDataStatus,
} from '../routes/Router';
import Home from '../api/home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {StackScreenProps} from '@react-navigation/stack';

type HomeScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const HomeScreen: React.FC<HomeScreenProps> = ({route, navigation}) => {
  const [search, setSearch] = React.useState<string>('');
  const [location, setLocation] = React.useState<object>({});
  const [visible, setVisible] = React.useState<boolean>(false);
  const [carePlanData, setCarePlanData] = React.useState<any>({});
  const [allPlans, setAllPlans] = React.useState<any>([]);
  const [learnMoreData, setLearnMoreData] = React.useState<any>([]);
  const [healthInsights, setHealthInsights] = React.useState<any>({});
  const [healthDiaries, setHealthDiaries] = React.useState<any>([]);

  const inputRef = useRef<AnimatedInputFieldRef>(null);

  useEffect(() => {
    getCurrentLocation();
    getHomeCarePlan();
    getLearnMoreData();
    getPlans();
    getMyHealthInsights();
    getHCDevicePlans();
    getMyHealthDiaries();
  }, []);

  const getCurrentLocation = async () => {
    const currentLocation = await AsyncStorage.getItem('location');

    await setLocation(currentLocation ? JSON.parse(currentLocation) : {});

    //call for health kit sync
    await openHealthKitSyncView();
  };

  const getGreetings = () => {
    const currentHour = new Date().getHours();

    if (currentHour > 5 && currentHour < 12) {
      return 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 16) {
      return 'Good Afternoon';
    } else if (currentHour >= 16 && currentHour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  };

  const getHomeCarePlan = async () => {
    const homeCarePlan = await Home.getPatientCarePlan({});
    setCarePlanData(homeCarePlan?.data);
  };

  const getLearnMoreData = async () => {
    const learnMore = await Home.getLearnMoreData({});
    setLearnMoreData(learnMore?.data);
  };

  const getPlans = async () => {
    const allPlans = await Home.getHomePagePlans({}, {page: 0});
    setAllPlans(allPlans?.data ?? []);
  };

  const getHCDevicePlans = async () => {
    const hcDevicePlans = await Home.getHCDevicePlan();
    console.log('hcDevicePlanshcDevicePlanshcDevicePlans', hcDevicePlans);
  };

  const getMyHealthInsights = async () => {
    // const insights = await Home.getMyHealthInsights({});
    // setHealthInsights(insights?.data);
    const goalsAndReadings = await Home.getGoalsAndReadings({
      current_datetime: new Date().toISOString(),
    });
    setHealthInsights(goalsAndReadings.data);
  };

  const getMyHealthDiaries = async () => {
    const diaries = await Home.getMyHealthDiaries({});

    setHealthDiaries(diaries?.data);
  };

  const onPressLocation = () => {};
  const onPressBell = () => {
    navigateTo('NotificationVC');
  };
  const onPressProfile = () => {
   getHomeScreenDataStatus((error:any, data:any) => {
        if (error) { 
           console.log(error,'error');
        } else {
           console.log(data,'data=========>');
        }
    })
    navigation.toggleDrawer();
  };
  const onPressDevices = () => {
    navigateTo('MyDevices');
  };
  const onPressDiet = () => {
    navigateTo('FoodDiaryParentVC');
  };
  const onPressExercise = (filteredData : any) => {
        // navigateToMedicines('test');
        navigateToExercise([{filteredData: filteredData}, {firstRow: 'exercise'}])
    // navigateTo('navigateToExercise');
  };
  const onPressMedicine = (filteredData : any) => {
    // navigateToMedicines('test');
    openUpdateGoal([{filteredData: filteredData}, {firstRow: 'medication'}])
  };
  const onPressMyIncidents = () => {
    navigateToIncident();
  };

  const onPressConsultNutritionist = () => {
    navigateTo('AppointmentsHistoryVC');
  };
  const onPressConsultPhysio = () => {
    navigateTo('AppointmentsHistoryVC');
  };
  const onPressBookDiagnostic = () => {
    navigateTo('LabTestListVC');
  };
  const onPressBookDevices = () => {
    navigateTo('MyDevices');
  };
  const onPressCarePlan = () => {
    navigateToPlan('navigateToPlan');
  };
  const onPressReading = (filteredData: any, firstRow: any) => {
    openUpdateReading([{filteredData: filteredData}, {firstRow: firstRow}]);
  };

  const onPressGoal = (filteredData: any, firstRow: any) => {
    openUpdateGoal([{filteredData: filteredData}, {firstRow: firstRow}]);
  };

  const onPressLearnItem = (contentId: string, contentType: string) => {
    navigateToEngagement(contentId.toString());
  };

  const onPressBookmark = async (data: any) => {
    const payload = {
      content_master_id: data?.content_master_id,
      is_active: data?.is_active === 'Y' ? 'N' : 'Y',
    };
    const resp = await Home.addBookmark({}, payload);
    if (resp?.data) {
      getLearnMoreData();
    }
  };

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
              onFocus={() => navigateTo('GlobalSearchParentVC')}
              ref={inputRef}
            />
          </View>
          <ScrollView showsVerticalScrollIndicator={false}>
            <CarePlanView
              data={carePlanData}
              onPressCarePlan={onPressCarePlan}
              allPlans={allPlans}
            />
            {carePlanData?.doctor_says?.description && (
              <HealthTip tip={carePlanData?.doctor_says} />
            )}
            <MyHealthInsights
              data={healthInsights}
              onPressReading={onPressReading}
              onPressGoal={onPressGoal}
            />
            <MyHealthDiary
              onPressDevices={onPressDevices}
              onPressDiet={onPressDiet}
              onPressExercise={onPressExercise}
              onPressMedicine={onPressMedicine}
              onPressMyIncidents={onPressMyIncidents}
              data={healthDiaries}
              healthInsights={healthInsights}
            />
            <AdditionalCareServices
              onPressConsultNutritionist={onPressConsultNutritionist}
              onPressConsultPhysio={onPressConsultPhysio}
              onPressBookDiagnostic={onPressBookDiagnostic}
              onPressBookDevices={onPressBookDevices}
            />
            {learnMoreData?.length > 0 && (
              <Learn
                onPressBookmark={onPressBookmark}
                data={learnMoreData}
                onPressItem={onPressLearnItem}
              />
            )}
          </ScrollView>
        </Container>
      </Screen>
      <SearchModal
        visible={visible}
        setVisible={setVisible}
        search={search}
        setSearch={setSearch}
      />
    </>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  goodMorning: {
    color: colors.black,
    fontSize: 16,
    fontWeight: '700',
    marginVertical: 15,
    lineHeight: 20,
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.inputBoxLightBorder,
    borderRadius: 12,
    paddingHorizontal: 10,
    marginBottom: 10,
  },
  searchField: {
    borderWidth: 0,
    flex: 1,
  },
});
