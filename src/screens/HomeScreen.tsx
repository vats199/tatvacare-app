import {
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  NativeModules,
  NativeEventEmitter,
  LayoutRectangle,
  Animated,
} from 'react-native';
import React, {useEffect} from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {Container, Screen} from '../components/styled/Views';
import {Icons} from '../constants/icons';
import {colors} from '../constants/colors';
import CarePlanView from '../components/organisms/CarePlanView';
import HealthTip from '../components/organisms/HealthTip';
import MyHealthInsights from '../components/organisms/MyHealthInsights';
import MyHealthDiary from '../components/organisms/MyHealthDiary';
import HomeHeader from '../components/molecules/HomeHeader';
import AdditionalCareServices from '../components/organisms/AdditionalCareServices';
import Learn from '../components/organisms/Learn';
import {DrawerScreenProps} from '@react-navigation/drawer';
import {
  navigateTo,
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
  openMedicineExerciseDiet,
} from '../routes/Router';
import Home from '../api/home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {StackScreenProps} from '@react-navigation/stack';
import {useApp} from '../context/app.context';
import {useSafeAreaInsets} from 'react-native-safe-area-context';
import TatvaLoader from '../components/atoms/TatvaLoader';

const {RNEventEmitter} = NativeModules;
const eventEmitter = new NativeEventEmitter(RNEventEmitter);

type HomeScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const HomeScreen: React.FC<HomeScreenProps> = ({route, navigation}) => {
  const {setUserData, setUserLocation} = useApp();

  const [loading, setLoading] = React.useState<boolean>(true);

  const [location, setLocation] = React.useState<object>({});
  const [carePlanData, setCarePlanData] = React.useState<any>({});
  const [allPlans, setAllPlans] = React.useState<any>([]);
  const [learnMoreData, setLearnMoreData] = React.useState<any>([]);
  const [healthInsights, setHealthInsights] = React.useState<any>({});
  const [hcDevicePlans, setHcDevicePlans] = React.useState<any>({});
  const [healthDiaries, setHealthDiaries] = React.useState<any>([]);

  const canBookHealthCoach: boolean = !!carePlanData?.patient_plans?.find(
    (pp: any) => {
      return pp?.features_res.find((fr: any) =>
        (fr.sub_features_keys ?? '')
          .split(',')
          .includes('book_appointments_hc'),
      );
    },
  );

  const refetchHealthInsights = () => {
    getMyHealthInsights();
  };

  const refetchHealthDiary = () => {
    getMyHealthDiaries();
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
      () => {
        refetchHealthInsights();
        refetchHealthDiary();
      },
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
    setLoading(true);
    const homeCarePlan = await Home.getPatientCarePlan({});
    const {city, state, country} = homeCarePlan?.data;
    if (city && state && country) {
      setUserLocation({city, state, country});
    }
    setCarePlanData(homeCarePlan?.data);
    setUserData(homeCarePlan?.data);
    setLoading(false);
  };

  const getLearnMoreData = async () => {
    const learnMore = await Home.getLearnMoreData({});
    setLearnMoreData(learnMore?.data);
  };

  const getPlans = async () => {
    setLoading(true);
    const allPlans = await Home.getHomePagePlans({}, {page: 0});
    setAllPlans(allPlans?.data ?? []);
    setLoading(false);
  };

  const getHCDevicePlans = async () => {
    setLoading(true);
    const hcDevicePlans = await Home.getHCDevicePlan();
    setHcDevicePlans(hcDevicePlans?.data);
    setLoading(false);
  };

  const getMyHealthInsights = async () => {
    setLoading(true);
    const goalsAndReadings = await Home.getMyHealthInsights();
    setHealthInsights({
      goals: goalsAndReadings?.data?.goal_data,
      readings: goalsAndReadings?.data?.readings_response,
    });
    setLoading(false);
  };

  const getMyHealthDiaries = async () => {
    setLoading(true);
    const diaries = await Home.getMyHealthDiaries({});
    setHealthDiaries(diaries?.data);
    setLoading(false);
  };

  const onPressLocation = () => {
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
    navigateToExercise([{filteredData: filteredData}, {firstRow: 'exercise'}]);
  };
  const onPressMedicine = (filteredData: any) => {
    openMedicineExerciseDiet([
      {filteredData: filteredData},
      {firstRow: 'medication'},
    ]);
  };
  const onPressMyIncidents = () => {
    navigateToIncident();
  };

  const onPressConsultNutritionist = () => {
    if (canBookHealthCoach) {
      navigateToBookAppointment('HC');
    } else {
      navigateToChronicCareProgram();
    }
  };
  const onPressConsultPhysio = (type: 'HC' | 'D') => {
    if (canBookHealthCoach) {
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

  const onPressReading = (filteredData: any, firstRow: any) => {
    openUpdateReading([{filteredData: filteredData}, {firstRow: firstRow}]);
  };

  const onPressGoal = (filteredData: any, firstRow: any) => {
    openUpdateGoal([{filteredData: filteredData}, {firstRow: firstRow}]);
  };

  const onPressViewAllLearn = () => {
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

  // Sticky Header
  const [header, setHeader] = React.useState<LayoutRectangle | null>(null);
  const scrollY = React.useRef(new Animated.Value(0)).current;
  const topEdge = header?.height;

  return (
    <>
      <Screen>
        {loading && <TatvaLoader />}
        <Container>
          <Animated.ScrollView
            showsVerticalScrollIndicator={false}
            onScroll={Animated.event(
              [{nativeEvent: {contentOffset: {y: scrollY}}}],
              {useNativeDriver: true},
            )}>
            <View
              style={styles.header}
              onLayout={(ev: any) => setHeader(ev.nativeEvent.layout)}>
              <HomeHeader
                onPressBell={onPressBell}
                onPressLocation={onPressLocation}
                onPressProfile={onPressProfile}
                userLocation={location}
              />
              <Text style={styles.goodMorning}>
                {getGreetings()} {carePlanData?.name}!
              </Text>
            </View>
            <View style={[styles.searchBar, {backgroundColor: 'red'}]} />
            <CarePlanView
              data={carePlanData}
              onPressCarePlan={onPressCarePlan}
              // onPressRenew={onPressRenew}
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
          </Animated.ScrollView>
          {topEdge && (
            <Animated.View
              style={[
                styles.searchBar,
                {
                  backgroundColor: '#f9f8fd',
                  position: 'absolute',
                  width: '100%',
                  transform: [
                    {
                      translateY: scrollY.interpolate({
                        inputRange: [0, topEdge - 1, topEdge, topEdge + 1],
                        outputRange: [topEdge, 1, 0, 0],
                      }),
                    },
                  ],
                },
              ]}>
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
            </Animated.View>
          )}
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
  header: {
    height: 90,
  },
  searchBar: {
    height: 80,
    alignSelf: 'center',
    alignItems: 'center',
    justifyContent: 'center',
  },
  searchContainer: {
    alignSelf: 'center',
    flexDirection: 'row',
    width: '100%',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.inputBoxLightBorder,
    borderRadius: 12,
    padding: 10,
    shadowColor: '#2121210D',
    shadowOffset: {
      width: 0,
      height: 0.5,
    },
    shadowOpacity: 0.1,
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
