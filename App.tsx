import 'react-native-gesture-handler';
import { Dimensions, StatusBar, StyleSheet, View } from 'react-native';
import React, { useEffect, useRef, useState } from 'react';
import Router from './src/routes/Router';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import LocationBottomSheet, { LocationBottomSheetRef } from './src/components/molecules/LocationBottomSheet';
import Geolocation from 'react-native-geolocation-service';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';
import { check, request, PERMISSIONS, RESULTS } from 'react-native-permissions';

const App = () => {
  const [location, setLocation] = useState<Geolocation.GeoPosition | null>(null);
  const BottomSheetRef = useRef<LocationBottomSheetRef>(null);
  const [locationPermission, setLocationPermission] = useState<string>('');

  const requestLocationPermission = async () => {
    try {
      let permissionResult = null;

      if (Platform.OS === 'ios') {
        permissionResult = await request(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
      } else {
        permissionResult = await request(PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION);
      }

      setLocationPermission(permissionResult);

      if (permissionResult === RESULTS.GRANTED) {
        getLocation();
      } else {
        BottomSheetRef.current?.show();
      }
    } catch (err) {
      BottomSheetRef.current?.show();
    }
  };

  const getLocation = () => {
    Geolocation.getCurrentPosition(
      async position => {
        await AsyncStorage.setItem('location', JSON.stringify(position));
        setLocation(position);
        BottomSheetRef.current?.hide();
      },
      error => {
        // Handle location error here
        requestLocationPermission();
      },
      { enableHighAccuracy: true, timeout: 15000, maximumAge: 10000 },
    );
  };

  useEffect(() => {
    checkLocationPermission();
  }, []);

  const checkLocationPermission = async () => {
    try {
      let permissionResult = null;

      if (Platform.OS === 'ios') {
        permissionResult = await check(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
      } else {
        permissionResult = await check(PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION);
      }

      setLocationPermission(permissionResult);

      if (permissionResult === RESULTS.GRANTED) {
        getLocation();
      } else {
        BottomSheetRef.current?.show();
      }
    } catch (err) {
      BottomSheetRef.current?.show();
    }
  };

  return (
    <GestureHandlerRootView style={{ height: Dimensions.get('window').height }}>
      <Router />
      <LocationBottomSheet ref={BottomSheetRef} setLocation={setLocation} requestLocationPermission={requestLocationPermission} locationPermission={locationPermission} />
    </GestureHandlerRootView>
  );
};

export default App;

const styles = StyleSheet.create({});