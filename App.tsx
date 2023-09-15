import 'react-native-gesture-handler';
import { Alert, Dimensions, PermissionsAndroid, Permission, Platform, StatusBar, StyleSheet, Text, View } from 'react-native'
import React, { useEffect, useRef, useState } from 'react'
import Router from './src/routes/Router';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import LocationBottomSheet, { LocationBottomSheetRef } from './src/components/molecules/LocationBottomSheet';
import Geolocation from 'react-native-geolocation-service';
import { request, check, PERMISSIONS, RESULTS } from 'react-native-permissions';
import { Linking } from 'react-native';

const App = () => {
  const [location, setLocation] = useState<Geolocation.GeoPosition | null>(null);
  const BottomSheetRef = useRef<LocationBottomSheetRef>(null);
  const [locationPermission, setLocationPermission] = useState<string>('');

  const requestLocationPermission = async (goToSettings: boolean) => {

    try {
      if (Platform.OS == 'android') {

        const granted = await PermissionsAndroid.request(
          PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION
        );

        setLocationPermission(granted)

        if (granted === 'granted') {
          getLocation()
        } else if (goToSettings && ['blocked', 'never_ask_again'].includes(granted)) {
          Linking.openSettings()
        } else {
          BottomSheetRef.current?.show();
        }
      }

      else {

        if (goToSettings) {
          Linking.openURL('app-settings:');
        } else {
          Geolocation.requestAuthorization
          // request(PERMISSIONS.IOS.L).then((result) => {
          //   Alert.alert(result);
          // });
        }

      }
    } catch (err) {
      BottomSheetRef.current?.show()
    }

  };

  const getLocation = () => {
    Geolocation.getCurrentPosition(
      async position => {
        // await AsyncStorage.setItem('location', JSON.stringify(position));
        setLocation(position);
        BottomSheetRef.current?.hide();
      },
      error => {
        // Handle location error here
        requestLocationPermission(false);
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