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
  NativeEventEmitter,
} from 'react-native';
import React, {useEffect, useRef, useState} from 'react';
import {CompositeScreenProps, useIsFocused} from '@react-navigation/native';
import Geolocation from 'react-native-geolocation-service';
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
  navigateToBookAppointment,
  navigateToDiscover,
  navigateToChronicCareProgram,
  openPlanDetails,
  onPressRenewPlan,
  openMedicineExerciseDiet,
} from '../routes/Router';
import Home from '../api/home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {StackScreenProps} from '@react-navigation/stack';
import {useApp} from '../context/app.context';

const {RNEventEmitter} = NativeModules;
const eventEmitter = new NativeEventEmitter(RNEventEmitter);

type HomeScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const HomeScreen: React.FC<HomeScreenProps> = ({route, navigation}) => {
  const {setUserData, setUserLocation} = useApp();

  const [location, setLocation] = React.useState<object>({});
  const [carePlanData, setCarePlanData] = React.useState<any>({});
  const [allPlans, setAllPlans] = React.useState<any>([]);
  const [learnMoreData, setLearnMoreData] = React.useState<any>([]);
  const [healthInsights, setHealthInsights] = React.useState<any>({});
  const [hcDevicePlans, setHcDevicePlans] = React.useState<any>({});
  const [healthDiaries, setHealthDiaries] = React.useState<any>([]);

  const refetchHealthInsights = () => {
    getMyHealthInsights();
  };

  const refetchLearnMoreData = () => {
    getLearnMoreData();
  };

  useEffect(() => {
    getCurrentLocation();
    getHomeCarePlan();
    getLearnMoreData();
    getPlans();
    getMyHealthInsights();
    getHCDevicePlans();
    getMyHealthDiaries();
  }, []);

  // Health Insight Updates
  useEffect(() => {
    const subscribe = eventEmitter.addListener(
      'updatedGoalReadingSuccess',
      refetchHealthInsights,
    );

    return () => {
      subscribe.remove();
    };
  }, []);

  // Bookmark Updates
  useEffect(() => {
    const subscribe = eventEmitter.addListener(
      'bookmarkUpdated',
      refetchLearnMoreData,
    );

    return () => {
      subscribe.remove();
    };
  }, []);

  // Bottom Tab Bar Navigation
  useEffect(() => {
    const subscribe = eventEmitter.addListener(
      'bottomTabNavigationInitiated',
      () => {
        navigation.closeDrawer();
      },
    );

    return () => {
      subscribe.remove();
    };
  }, []);

  // Location Updates
  useEffect(() => {
    const subscribe = eventEmitter.addListener(
      'locationUpdatedSuccessfully',
      (location: any) => {
        const {city, state, country} = location;
        setUserLocation({city, state, country});
      },
    );

    return () => {
      subscribe.remove();
    };
  }, []);

  // Profile Update Success
  useEffect(() => {
    const subscribe = eventEmitter.addListener(
      'profileUpdatedSuccess',
      getHomeCarePlan,
    );

    return () => {
      subscribe.remove();
    };
  }, []);

  // useEffect(() => {
  //   onPressLocation(); //Update location on all home screen focus
  // }, [isFocused]);

  const getCurrentLocation = async () => {
    const currentLocation = await AsyncStorage.getItem('location');
    setLocation(currentLocation ? JSON.parse(currentLocation) : {});
    //call for health kit sync
    await openHealthKitSyncView();
  };

  const getGreetings = () => {
    const currentHour = new Date().getHours();

    if (currentHour > 5 && currentHour < 12) {
      return 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 16) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  };

  const getHomeCarePlan = async () => {
    const homeCarePlan = await Home.getPatientCarePlan({});
    const {city, state, country} = homeCarePlan?.data;
    if (city && state && country) {
      setUserLocation({city, state, country});
    }
    setCarePlanData(homeCarePlan?.data);
    setUserData(homeCarePlan?.data);
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
    setHcDevicePlans(hcDevicePlans?.data);
  };

  const getMyHealthInsights = async () => {
    const goalsAndReadings = await Home.getMyHealthInsights();
    setHealthInsights({
      goals: goalsAndReadings?.data?.goal_data,
      readings: goalsAndReadings?.data?.readings_response,
    });
  };

  const getMyHealthDiaries = async () => {
    const diaries = await Home.getMyHealthDiaries({});
    setHealthDiaries(diaries?.data);
  };

  const getLocationFromLatLng = async (lat: any, long: any) => {
    const res = await fetch(
      `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${long}&key=AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo`,
      {
        method: 'get',
        headers: {
          'Content-Type': 'application/json',
        },
      },
    );

    const data = await res.json();

    if (
      (data?.results || []).length > 0 &&
      (data?.results[0]?.address_components || []).length > 0
    ) {
      const city = data?.results[0]?.address_components.find((a: any) =>
        a?.types.includes('administrative_area_level_3'),
      );
      const state = data?.results[0]?.address_components.find((a: any) =>
        a?.types.includes('administrative_area_level_1'),
      );
      const country = data?.results[0]?.address_components.find((a: any) =>
        a?.types.includes('country'),
      );
      const pincode = data?.results[0]?.address_components.find((a: any) =>
        a?.types.includes('postal_code'),
      );

      const locationPayload = {
        city: city?.long_name,
        state: state?.long_name,
        country: country?.long_name,
        pincode: pincode?.long_name,
      };

      setLocation({
        ...locationPayload,
      });
      await AsyncStorage.setItem('location', JSON.stringify(locationPayload));
      await Home.updatePatientLocation({}, locationPayload);
      setUserLocation(locationPayload);
    }
  };

  const onPressLocation = () => {
    // Geolocation.getCurrentPosition(
    //   async position => {
    //     await getLocationFromLatLng(
    //       position?.coords?.latitude,
    //       position?.coords?.longitude,
    //     );
    //   },
    //   error => {
    //     // Handle location error here
    //   },
    //   {enableHighAccuracy: true, timeout: 15000, maximumAge: 10000},
    // );
    navigateTo('SetLocationVC');
  };

  const onPressBell = () => {
    navigateTo('NotificationVC');
  };
  const onPressProfile = () => {
    navigation.toggleDrawer();
  };
  const onPressDevices = () => {
    navigateTo('MyDevices');
  };
  const onPressDiet = () => {
    navigateTo('FoodDiaryParentVC');
  };
  const onPressExercise = (filteredData: any) => {
    // navigateToMedicines('test');
    navigateToExercise([{filteredData: filteredData}, {firstRow: 'exercise'}]);
    // navigateTo('navigateToExercise');
  };
  const onPressMedicine = (filteredData: any) => {
    // console.log(filteredData);
    // navigateToMedicines('test');
    openMedicineExerciseDiet([
      {filteredData: filteredData},
      {firstRow: 'medication'},
    ]);
  };
  const onPressMyIncidents = () => {
    navigateToIncident();
  };

  const onPressConsultNutritionist = () => {
    if (Object.values(hcDevicePlans.nutritionist).length > 0) {
      navigateToBookAppointment('HC');
    } else {
      navigateToChronicCareProgram();
    }
  };
  const onPressConsultPhysio = (type: 'HC' | 'D') => {
    if (Object.values(hcDevicePlans.physiotherapist).length > 0) {
      navigateToBookAppointment(type);
    } else {
      navigateToChronicCareProgram();
    }
  };
  const onPressBookDiagnostic = () => {
    navigateTo('LabTestListVC');
  };
  const onPressBookDevices = () => {
    if (Object.values(hcDevicePlans.devices).length > 0) {
      navigateTo('MyDevices');
    } else {
      navigateToChronicCareProgram();
    }
  };
  const onPressCarePlan = (plan: any) => {
    openPlanDetails([{planDetails: plan}]);
  };

  const onPressRenew = (plan: any) => {
    onPressRenewPlan([{planDetails: plan}]);
  };

  const onPressReading = (filteredData: any, firstRow: any) => {
    openUpdateReading([{filteredData: filteredData}, {firstRow: firstRow}]);
  };

  const onPressGoal = (filteredData: any, firstRow: any) => {
    openUpdateGoal([{filteredData: filteredData}, {firstRow: firstRow}]);
  };

  const onPressViewAllLearn = () => {
    // navigation.navigate('AllLearnItemsScreen');
    navigateToDiscover();
  };

  const onPressLearnItem = (contentId: string, contentType: string) => {
    navigateToEngagement(contentId.toString());
  };

  const onPressBookmark = async (data: any) => {
    const payload = {
      content_master_id: data?.content_master_id,
      is_active: data?.bookmarked === 'Y' ? 'N' : 'Y',
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
          <Text style={styles.goodMorning}>
            {getGreetings()} {carePlanData?.name}!
          </Text>
          <TouchableOpacity
            style={styles.searchContainer}
            activeOpacity={1}
            onPress={() => {
              navigateTo('GlobalSearchParentVC');
            }}>
            <Icons.Search />
            <Text style={styles.searchText}>
              Find resources to manage your condition
            </Text>
          </TouchableOpacity>
          <ScrollView showsVerticalScrollIndicator={false}>
            <CarePlanView
              data={carePlanData}
              onPressCarePlan={onPressCarePlan}
              onPressRenew={onPressRenew}
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
                onPressViewAll={onPressViewAllLearn}
              />
            )}
          </ScrollView>
        </Container>
      </Screen>
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
    paddingVertical: 10,
    shadowColor: colors.black,
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.2,
    shadowRadius: 1.41,
  },
  searchText: {
    color: colors.subTitleLightGray,
    marginLeft: 10,
  },
  searchField: {
    borderWidth: 0,
    flex: 1,
  },
});
