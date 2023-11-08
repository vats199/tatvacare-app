import {
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  NativeModules,
  NativeEventEmitter,
  LayoutRectangle,
  Animated,
  Platform,
  DeviceEventEmitter,
  Alert
} from 'react-native';
import React, { useEffect, useRef, useState } from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import { Container, Screen } from '../components/styled/Views';
import { Icons } from '../constants/icons';
import { colors } from '../constants/colors';
import CarePlanView from '../components/organisms/CarePlanView';
import HealthTip from '../components/organisms/HealthTip';
import MyHealthInsights from '../components/organisms/MyHealthInsights';
import MyHealthDiary from '../components/organisms/MyHealthDiary';
import HomeHeader from '../components/molecules/HomeHeader';
import AdditionalCareServices from '../components/organisms/AdditionalCareServices';
import Learn from '../components/organisms/Learn';
import { DrawerScreenProps } from '@react-navigation/drawer';
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
  navigateToPlan,
  navigateToMedicines,
} from '../routes/Router';
import Home from '../api/home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { StackScreenProps } from '@react-navigation/stack';
import { useApp } from '../context/app.context';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import TatvaLoader from '../components/atoms/TatvaLoader';
// food diary 31st Oct
import InputField, {
  AnimatedInputFieldRef,
} from '../components/atoms/AnimatedInputField';
import SearchModal from '../components/molecules/SearchModal';
import { trackEvent } from '../helpers/TrackEvent'
import { Constants } from '../constants';
import moment from 'moment';

const { RNEventEmitter } = NativeModules;
const eventEmitter = new NativeEventEmitter(RNEventEmitter);

type HomeScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'HomeScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {
  const { setUserData, setUserLocation, userData } = useApp();

  const [loading, setLoading] = React.useState<boolean>(true);

  const [location, setLocation] = React.useState<object>({});
  const [carePlanData, setCarePlanData] = React.useState<any>({});
  const [allPlans, setAllPlans] = React.useState<any>([]);
  const [learnMoreData, setLearnMoreData] = React.useState<any>([]);
  const [healthInsights, setHealthInsights] = React.useState<any>({});
  const [hcDevicePlans, setHcDevicePlans] = React.useState<any>({});
  const [healthDiaries, setHealthDiaries] = React.useState<any>([]);
  const [hideIncidentSurvey, setHideIncidentSurvey] = React.useState<boolean>(false);
  const [incidentDetails, setIncidentDetails] = React.useState<any>(null);
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
    getIncidentDetails();
  }, []);

  // Health Insight Updates

  useEffect(() => {
    if (Platform.OS == "android") {
      const subscribeToken = DeviceEventEmitter.addListener(
        'UserToken',
        async (data: any) => {
          await AsyncStorage.setItem("accessToken", data.Token)
          getCurrentLocation();
          getHomeCarePlan();
          getLearnMoreData();
          getPlans();
          getMyHealthInsights();
          getHCDevicePlans();
          getMyHealthDiaries();
        },
      );

      return () => {
        subscribeToken.remove();
      };
    }
  }, []);

  useEffect(() => {
    if (Platform.OS == "android") {
      const subscribe = DeviceEventEmitter.addListener(
        'HideIncidentSurvey',
        (data: any) => {
          console.log("HideIncidentSurvey==", data);
        },
      );

      return () => {
        subscribe.remove();
      };
    }
  }, []);

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
        const { city, state, country } = location;
        setUserLocation({ city, state, country });
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
    if (Platform.OS == 'ios') {
      //await openHealthKitSyncView();
    } else {

    }
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
    const { city, state, country } = homeCarePlan?.data;
    if (city && state && country) {
      setUserLocation({ city, state, country });
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
    const allPlans = await Home.getHomePagePlans({}, { page: 0 });
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

  const getIncidentDetails = async () => {
    setLoading(true);
    const details = await Home.getIncidentDetails();
    setHideIncidentSurvey(!!!details?.data.incidentSurveyData);
    setIncidentDetails(details?.data);
    setLoading(false);
  };

  const onPressLocation = () => {
    if (Platform.OS == 'ios') {
      navigateTo('SetLocationVC');
    } else {
      NativeModules.AndroidBridge.openLocationSelectionScreen();
    }
  };

  const onPressBell = () => {
    trackEvent("CLICKED_NOTIFICATION", {

    })
    // CLICKED_NOTIFICATION
    if (Platform.OS == 'ios') {
      navigateTo('NotificationVC');
    } else {
      NativeModules.AndroidBridge.openNotificationScreen();
    }
  };
  const onPressProfile = () => {
    trackEvent("USER_CLICKED_ON_MENU", {
      "photo_uploaded": userData.profile_pic ? "yes" : "no"
    })
    navigation.toggleDrawer();
  };
  const onPressDevices = () => {
    if (Platform.OS == 'ios') {
      navigateTo('MyDevices');
    } else {
      NativeModules.AndroidBridge.openDeviceScreen();
    }
  };
  const RNonPressDiet = () => {
    // navigateTo('FoodDiaryParentVC');
    trackEvent(Constants.EVENT_NAME.FOOD_DIARY.CLICKED_HEALTH_DIARY, {
      "goal_id": "",
      "goal_name": "",
      "diet_plan_assigned": ""
    })
    navigation.navigate('DietStackScreen');
  };

  const onPressDiet = (data: any) => {
    if (Platform.OS == 'ios') {
      navigateTo('FoodDiaryParentVC');
    } else {
      let achievedVal = data.find((fd: any) => fd.keys === 'diet').todays_achieved_value
      let goalVal = data.find((fd: any) => fd.keys === 'diet').goal_value
      NativeModules.AndroidBridge.openDietScreen(isNaN(parseFloat(achievedVal) / parseFloat(goalVal) * 100) ? 0 : parseFloat(achievedVal) / parseFloat(goalVal) * 100);
    }
  };

  const onPressExercise = (filteredData: any) => {
    // openMedicineExerciseDiet([
    //   { filteredData: filteredData },
    //   { firstRow: 'exercise' },
    // ]);
    if (Platform.OS == 'ios') {
      openMedicineExerciseDiet([
        { filteredData: filteredData },
        { firstRow: 'exercise' },
      ]);
    } else {
      let achievedVal = filteredData.find((fd: any) => fd.keys === 'exercise').todays_achieved_value
      let goalVal = filteredData.find((fd: any) => fd.keys === 'exercise').goal_value
      NativeModules.AndroidBridge.openExerciseDetailsScreen(JSON.stringify(filteredData), filteredData.findIndex((fd: any) => fd.keys === 'exercise'), isNaN(parseFloat(achievedVal) / parseFloat(goalVal) * 100) ? 0 : parseFloat(achievedVal) / parseFloat(goalVal) * 100);
    }
  };
  const onPressMedicine = (filteredData: any) => {
    if (Platform.OS == 'ios') {
      openMedicineExerciseDiet([
        { filteredData: filteredData },
        { firstRow: 'medication' },
      ]);
    } else {
      let achievedVal = filteredData.find((fd: any) => fd.keys === 'medication').todays_achieved_value
      let goalVal = filteredData.find((fd: any) => fd.keys === 'medication').goal_value
      console.log("medication===", achievedVal / goalVal * 100)
      NativeModules.AndroidBridge.openMedicationScreen(JSON.stringify(filteredData), filteredData.findIndex((fd: any) => fd.keys === 'medication'), isNaN(parseFloat(achievedVal) / parseFloat(goalVal) * 100) ? 0 : parseFloat(achievedVal) / parseFloat(goalVal) * 100);
    }
  };
  const onPressMyIncidents = () => {
    if (Platform.OS == 'ios') {
      navigateToIncident([{ surveyDetails: incidentDetails }]);
    } else {

      console.log("Incident Value---", JSON.stringify(incidentDetails));
      if (incidentDetails) {

        NativeModules.AndroidBridge.openIncidentScreen(JSON.stringify(incidentDetails));
      }
    }
  }


  const onPressConsultNutritionist = () => {
    if (canBookHealthCoach) {
      if (Platform.OS == 'ios') {
        trackEvent("CLICKED_CONSULT_NUTRITIONIST", {})
        navigateToBookAppointment('HC');
      } else {
        NativeModules.AndroidBridge.openConsultNutritionistScreen();
      }
    } else {
      if (Platform.OS == 'ios') {
        trackEvent("CLICKED_CONSULT_NUTRITIONIST", {})
        navigateToChronicCareProgram('show_nutritionist');
      } else {
        NativeModules.AndroidBridge.openAllPlanScreen("show_nutritionist");
      }
    }
  };
  const onPressConsultPhysio = (type: 'HC' | 'D') => {
    if (canBookHealthCoach) {
      if (Platform.OS == 'ios') {
        trackEvent("CLICKED_CONSULT_PHYSIO", {})
        navigateToBookAppointment(type);
      } else {
        NativeModules.AndroidBridge.openConsultPhysioScreen();
      }
    } else {
      if (Platform.OS == 'ios') {
        trackEvent("CLICKED_CONSULT_PHYSIO", {})
        navigateToChronicCareProgram('show_physio');
      } else {
        NativeModules.AndroidBridge.openAllPlanScreen("show_physio");
      }
    }
  };
  const onPressBookDiagnostic = () => {
    if (Platform.OS == 'ios') {
      trackEvent("HOME_LABTEST_CARD_CLICKED", {})
      navigateTo('LabTestListVC');
    } else {
      NativeModules.AndroidBridge.openBookDiagnosticScreen();
    }
  };

  const onPressBookDevices = () => {
    if (Object.values(hcDevicePlans.devices).length > 0) {
      if (Platform.OS == 'ios') {
        trackEvent("CLICKED_BOOK_DEVICES", {})
        navigateTo('MyDevices');
      } else {
        NativeModules.AndroidBridge.openBookDeviceScreen();
      }
    } else {

      if (Platform.OS == 'ios') {
        trackEvent("CLICKED_BOOK_DEVICES", {})
        navigateToChronicCareProgram('show_book_device');
      } else {
        NativeModules.AndroidBridge.openAllPlanScreen("show_book_device");
      }
    }
  };

  const onPressCarePlan = (plan: any) => {
    if (Platform.OS == 'ios') {
      trackEvent("HOME_CARE_PLAN_CARD_CLICKED", {
        plan_id: plan?.plan_master_id ?? "",
        plan_type: plan?.plan_type ?? "",
        plan_duration: moment(plan?.expiry_date, "YYYY-MM-DD").diff(moment(plan.plan_start_date).format("YYYY-MM-DD"), "days")
      })
      openPlanDetails([{ planDetails: plan }]);
    } else {
      console.log("Plan Details===", plan)
      NativeModules.AndroidBridge.openPurchasedPlanDetailScreen(JSON.stringify(plan));
    }
  };

  const onPressReading = (filteredData: any, firstRow: any, index: any) => {
    if (Platform.OS == 'ios') {
      openUpdateReading([{ filteredData: filteredData }, { firstRow: firstRow }]);
    } else {
      NativeModules.AndroidBridge.openReadingsItemDetailScreen(JSON.stringify(filteredData), JSON.stringify(firstRow), index)
    }
  };

  const onPressGoal = (filteredData: any, firstRow: any, index: any) => {
    if (Platform.OS == 'ios') {
      openUpdateGoal([{ filteredData: filteredData }, { firstRow: firstRow }]);
    } else {
      NativeModules.AndroidBridge.openGoalItemDetailScreen(JSON.stringify(filteredData), JSON.stringify(firstRow), index)
    }
  }

  const onPressViewAllLearn = () => {
    if (Platform.OS == 'ios') {
      trackEvent("CLICKED_CONTENT_VIEW_ALL", {})
      navigateToDiscover();
    } else {
      NativeModules.AndroidBridge.openLearnScreen();
    }
  };

  const onPressLearnItem = (contentId: string, contentType: string, learnItem: any) => {
    if (Platform.OS == 'ios') {
      trackEvent("USER_CLICKED_ON_CARD", {
        content_master_id: learnItem?.content_master_id ?? "",
        content_type: learnItem?.content_type ?? "",
        content_heading: learnItem?.title ?? "",
        content_card_number: learnItem?.content_id ?? ""
      })
      navigateToEngagement(contentId.toString());
    } else {
      NativeModules.AndroidBridge.openLearnDetailsScreen(contentId, contentType);
    }
  };

  const onPressBookmark = async (data: any) => {
    let trackEventPayload = {
      content_master_id: data?.content_master_id ?? "",
      content_type: data?.content_type ?? "",
      content_heading: data?.title ?? "",
      content_card_number: data?.content_id ?? ""
    }
    trackEvent(`${data?.bookmarked === 'Y' ? "USER_UN_BOOKMARK_CONTENT" : "USER_BOOKMARKED_CONTENT"}`, trackEventPayload)
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
              [{ nativeEvent: { contentOffset: { y: scrollY } } }],
              { useNativeDriver: true },
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
            <View style={[styles.searchBar, { backgroundColor: 'red' }]} />
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
              hideIncident={hideIncidentSurvey}
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
                  trackEvent("CLICKED_SEARCH", {
                    "search_type": "attempted"
                  })
                  if (Platform.OS == 'ios') {
                    navigateTo('GlobalSearchParentVC');
                  } else {
                    NativeModules.AndroidBridge.openSearchScreen();
                  }
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
    fontFamily: 'SFProDisplay-Bold',
    marginVertical: Platform.OS == "ios" ? 15 : 10,
    lineHeight: 20,
  },
  header: {
    height: 90,
  },
  searchBar: {
    height: 60,
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
    shadowColor: "#000",
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.22,
    shadowRadius: 2.22,
    elevation: 3,
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
