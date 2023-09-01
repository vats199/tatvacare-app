import 'react-native-gesture-handler';
import { Alert, Dimensions, PermissionsAndroid,Permission, Platform, StatusBar, StyleSheet, Text, View } from 'react-native'
import React, { useEffect, useRef, useState } from 'react'
import Router from './src/routes/Router';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import LocationBottomSheet, { LocationBottomSheetRef } from './src/components/molecules/LocationBottomSheet';
import Geolocation from 'react-native-geolocation-service';
import {request, check, PERMISSIONS, RESULTS} from 'react-native-permissions';

const App = () => {
  const [location, setLocation] = useState<Geolocation.GeoPosition | null>(null)

  const BottomSheetRef = useRef<LocationBottomSheetRef>(null)

  const [locationPermission, setLocationPermission] = useState<string>('')

  const requestLocationPermission = async () => {
    try {
      if(Platform.OS == 'android') {
  
      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION
      );

      setLocationPermission(granted)

      if (granted === 'granted') {
        getLocation()
      } else {
        BottomSheetRef.current?.show()
      }
    }
  
  else {

    Geolocation.requestAuthorization
    // request(PERMISSIONS.IOS.L).then((result) => {
    //   Alert.alert(result);
    // });
  }
  }catch (err) {
      BottomSheetRef.current?.show()
    }

  };

  const getLocation = () => {
    Geolocation.getCurrentPosition(
      position => {
        setLocation(position);
        BottomSheetRef.current?.hide()
      },
      error => {
        // See error code charts below.
        requestLocationPermission();
      },
      { enableHighAccuracy: true, timeout: 15000, maximumAge: 10000 },
    );
  };

  useEffect(() => {
    requestLocationPermission()
  }, [])
  return (
    <GestureHandlerRootView style={{ height: Dimensions.get('window').height }}>
      <Router />
      <LocationBottomSheet ref={BottomSheetRef} requestLocationPermission={requestLocationPermission} locationPermission={locationPermission} />
    </GestureHandlerRootView>
  )
}

export default App

const styles = StyleSheet.create({})