import 'react-native-gesture-handler';
import {
  Alert,
  Dimensions,
  PermissionsAndroid,
  Permission,
  Platform,
  StatusBar,
  StyleSheet,
  Text,
  View,
  SafeAreaView,
  useWindowDimensions,
} from 'react-native';
import React, {useEffect, useRef, useState} from 'react';
import Router from './src/routes/Router';
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
import SplashScreen from 'react-native-splash-screen';

const App = () => {
  const {height, width} = useWindowDimensions();
  const [location, setLocation] = useState<object>({});
  const BottomSheetRef = useRef<LocationBottomSheetRef>(null);
  const [locationPermission, setLocationPermission] = useState<string>('');

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
          BottomSheetRef.current?.show();
        }
      } else {
        const granted = await request(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
        setLocationPermission(granted);
        if (granted == RESULTS.GRANTED) {
          getLocation();
        } else if (goToSettings) {
          Linking.openURL('app-settings:');
        } else {
          BottomSheetRef.current?.show();
        }
      }
    } catch (err) {
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
    }
  };

  useEffect(() => {
    checkLocationPermission();
    SplashScreen.hide();
  }, []);

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
        // BottomSheetRef.current?.show();
        requestLocationPermission(false);
      }
    } catch (err) {
      BottomSheetRef.current?.show();
    }
  };

  return (
    <GestureHandlerRootView style={{height, width}}>
      <AppProvider>
        <SafeAreaView style={{flex: 1}}>
          <Router />
          <LocationBottomSheet
            ref={BottomSheetRef}
            setLocation={setLocation}
            requestLocationPermission={requestLocationPermission}
            setLocationPermission={setLocationPermission}
            locationPermission={locationPermission}
          />
        </SafeAreaView>
      </AppProvider>
    </GestureHandlerRootView>
  );
};

export default App;

const styles = StyleSheet.create({});
