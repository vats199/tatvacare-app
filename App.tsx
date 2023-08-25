import 'react-native-gesture-handler';
import { Dimensions, PermissionsAndroid, StatusBar, StyleSheet, Text, View } from 'react-native'
import React, { useEffect, useRef, useState } from 'react'
import Router from './src/routes/Router';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import LocationBottomSheet, { LocationBottomSheetRef } from './src/components/molecules/LocationBottomSheet';
import Geolocation from 'react-native-geolocation-service';

const App = () => {
  const [location, setLocation] = useState<Geolocation.GeoPosition | null>(null)

  const BottomSheetRef = useRef<LocationBottomSheetRef>(null)

  const requestLocationPermission = async () => {
    try {

      const granted = await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION
      );

      if (granted === 'granted') {
        getLocation()
      } else if (granted !== 'never_ask_again') {
        BottomSheetRef.current?.show()
      }
    } catch (err) {
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
    <GestureHandlerRootView style={{ height: Dimensions.get('window').height - (StatusBar.currentHeight ?? 0) }}>
      <Router />
      <LocationBottomSheet ref={BottomSheetRef} requestLocationPermission={requestLocationPermission} />
    </GestureHandlerRootView>
  )
}

export default App

const styles = StyleSheet.create({})