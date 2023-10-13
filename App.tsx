import 'react-native-gesture-handler';
import {
  Platform,
  StyleSheet,
  useWindowDimensions,
  AppState,
  AppStateStatus,
  Alert,
  NativeModules
} from 'react-native';
import React from 'react';
import Router, {openHealthKitSyncView} from './src/routes/Router';
import {GestureHandlerRootView} from 'react-native-gesture-handler';
import LocationBottomSheet, {
  LocationBottomSheetRef,
} from './src/components/molecules/LocationBottomSheet';
import Geolocation from 'react-native-geolocation-service';
import {request, check, PERMISSIONS, RESULTS} from 'react-native-permissions';
import {Linking} from 'react-native';
import Home from './src/api/home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {AppProvider} from './src/context/app.context';
import {SafeAreaProvider} from 'react-native-safe-area-context';

const App = () => {
  const {height, width} = useWindowDimensions();
  const Navigation = NativeModules.Navigation;
   const showTabBarNative = Navigation.showTabbar;
   const hideTabBarNative = Navigation.hideTabbar;

  const [location, setLocation] = React.useState<object>({});
  const appState = React.useRef<AppStateStatus>(AppState.currentState);
  const BottomSheetRef = React.useRef<LocationBottomSheetRef>(null);
  const [locationPermission, setLocationPermission] =
    React.useState<string>('');

  const requestLocationPermission = async (goToSettings: boolean) => {
    try {
      if (Platform.OS === 'android') {
        const granted = await request(PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION);
        setLocationPermission(granted);
        if (granted === 'granted') {
          getLocation();
        } else if (
          goToSettings &&
          ['blocked', 'never_ask_again'].includes(granted)
        ) {
          Linking.openSettings();
        } else {
         
         await BottomSheetRef.current?.show();
        }
      } else {
        const granted = await request(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
        setLocationPermission(granted);
        if (granted == RESULTS.GRANTED) {
          getLocation();
        } else if (goToSettings) {
          Alert.alert(
            'App Permission Denied',
            'To re-enable, please go to Settings and turn on Location Service for MyTatva',
            [
              {
                text: 'Close',
              },
              {
                text: 'Go to Settings',
                onPress: () => Linking.openURL('app-settings:'),
              },
            ],
          );
        } else {
             console.log('throw');
             
                BottomSheetRef.current?.show();
               
        }
      }
    } catch (err) {
      console.log('catch');

      // hideTabBarNative()
      BottomSheetRef.current?.show();

    }
  };

  const getLocation = () => {
    Geolocation.getCurrentPosition(
      async position => {
        await getLocationFromLatLng(
          position?.coords?.latitude,
          position?.coords?.longitude,
        );
      },
      error => {
        // Handle location error here
        requestLocationPermission(false);
      },
      {enableHighAccuracy: true, timeout: 15000, maximumAge: 10000},
    );
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
      BottomSheetRef.current?.hide();
      showTabBarNative();
    }
  };

  const checkLocationPermission = async () => {
    try {
      let permissionResult = null;

      if (Platform.OS === 'ios') {
        permissionResult = await check(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
      } else {
        permissionResult = await check(
          PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION,
        );
      }

      setLocationPermission(permissionResult);

      if (permissionResult === RESULTS.GRANTED) {
        getLocation();
      } else {
        requestLocationPermission(false);
      }
    } catch (err) {
      console.log(err);
      BottomSheetRef.current?.show();
      // hideTabBarNative()

    }
  };

  React.useEffect(() => {
    const subscription = AppState.addEventListener('change', nextAppState => {
      if (
        appState.current.match(/inactive|background/) &&
        nextAppState === 'active'
      ) {
        checkLocationPermission();
      }

      appState.current = nextAppState;
    });

    return () => {
      subscription.remove();
    };
  }, []);

  React.useEffect(() => {
    checkLocationPermission();
  }, []);

  return (
    <GestureHandlerRootView style={{height, width}}>
      <SafeAreaProvider>
        <AppProvider>
          <Router />
          <LocationBottomSheet
            ref={BottomSheetRef}
            setLocation={setLocation}
            requestLocationPermission={requestLocationPermission}
            setLocationPermission={setLocationPermission}
            locationPermission={locationPermission}
          />
        </AppProvider>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
};

export default App;

const styles = StyleSheet.create({});
