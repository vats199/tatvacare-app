import React, {
  forwardRef,
  SetStateAction,
  useEffect,
  useImperativeHandle,
  useState,
} from 'react';
import {
  BottomSheetModalProvider,
  BottomSheetModal,
  BottomSheetModalProps,
} from '@gorhom/bottom-sheet';
import {
  ActivityIndicator,
  FlatList,
  Platform,
  Pressable,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { Icons } from '../../constants/icons';
import Button from '../atoms/Button';
import { colors } from '../../constants/colors';
import InputField from '../atoms/AnimatedInputField';
import Home from '../../api/home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useApp } from '../../context/app.context';
import { TextInput } from 'react-native-paper';
import { trackEvent } from '../../helpers/TrackEvent';

type LocationBottomSheetProps = {
  requestLocationPermission?: (goToSettings: boolean) => void;
  locationPermission?: string;
  setLocation?: SetStateAction<any>;
  setLocationPermission?: SetStateAction<any>;
};

export type LocationBottomSheetRef = {
  show: () => void;
  hide: () => void;
};

const LocationBottomSheet = forwardRef<
  LocationBottomSheetRef,
  LocationBottomSheetProps
>(
  (
    {
      requestLocationPermission = () => { },
      locationPermission,
      setLocation,
      setLocationPermission,
    },
    ref,
  ) => {


    const bottomSheetModalRef = React.useRef<BottomSheetModal>(null);

    const { setUserLocation } = useApp();

    // Expose methods using useImperativeHandle
    useImperativeHandle(ref, () => ({
      show: () => {
        bottomSheetModalRef.current?.present();
      },
      hide: () => {
        bottomSheetModalRef.current?.dismiss();
      },
    }));

    const [pincodeDetailsShown, setPincodeDetailsShown] =
      useState<boolean>(false);

    const [pincode, setPincode] = useState<string>('');
    const [error, setError] = useState<string>('');


    React.useEffect(() => {
      trackBottomSheetButton()
    }, [pincodeDetailsShown])

    const trackBottomSheetButton = () => {
      let payload = {
        bottom_sheet_name: pincodeDetailsShown ? "add pincode" : "grant location permission"
      }
      trackEvent("SHOW_BOTTOM_SHEET", payload)
    }

    const onPressUseCurrentLocation = () => {
      trackEvent("USE_CURRENT_LOCATION", {
        "bottom_sheet_name": "add pincode"
      })
      trackEvent("CLICK_APPLY", {
        "bottom_sheet_name": "add pincode"
      })
      if (Platform.OS === 'android') {
        requestLocationPermission(
          ['blocked', 'never_ask_again'].includes(locationPermission || '')
            ? true
            : false,
        );
      } else {
        requestLocationPermission(true);
      }
    };

    const onChangePin = (val: string) => {
      if (val?.length <= 6) {
        if (val && val != '') {
          const regEx = /[0-9]$/;
          const check = val.match(regEx);
          if (!check) {
            return;
          }
        }
        setPincode(val.trim());
      }
    };

    const [loading, setLoading] = React.useState<boolean>(false);

    const onApplyPincode = async () => {
      setLoading(true);
      trackEvent("PINCODE_ENTERED", {
        "bottom_sheet_name": "grant location permission"
      })
      const res = await fetch(
        `https://maps.googleapis.com/maps/api/geocode/json?address=${pincode}&key=AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo`,
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
          a?.types.includes('locality'),
        );
        if (!city) {
          setLoading(false);
          setError('No locality found with this pincode.');
          return;
        }
        const state = data?.results[0]?.address_components.find((a: any) =>
          a?.types.includes('administrative_area_level_1'),
        );
        const country = data?.results[0]?.address_components.find((a: any) =>
          a?.types.includes('country'),
        );
        const locationPayload = {
          city: city?.long_name,
          state: state?.long_name,
          country: country?.long_name,
          pincode: pincode,
        };

        setLocation({
          ...locationPayload,
        });
        await Home.updatePatientLocation({}, locationPayload);
        await AsyncStorage.setItem('location', JSON.stringify(locationPayload));
        setUserLocation(locationPayload);
        setLocationPermission('granted');
        setLoading(false);
        bottomSheetModalRef.current?.dismiss();
      } else {
        setLoading(false);
        switch (data.status) {
          case 'ZERO_RESULTS':
            setError('Enter a valid pincode');
            break;
          default:
            setError('Something went wrong!');
        }
      }
    };

    return (
      <BottomSheetModalProvider>
        <BottomSheetModal
          ref={bottomSheetModalRef}
          backdropComponent={() => (
            <Pressable
              style={styles.overlay}
              onPress={() => bottomSheetModalRef.current?.close()}
            />
          )}
          handleIndicatorStyle={{
            backgroundColor: '#E0E0E0',
            width: 45,
            height: 4,
          }}
          index={0}
          snapPoints={[pincodeDetailsShown ? '35%' : '40%', '75%']}
          enablePanDownToClose={true}
          enableContentPanningGesture={false}
          keyboardBehavior={'interactive'}
          backgroundStyle={styles.container}>
          <View
            style={[
              styles.sheetContainer,
              !pincodeDetailsShown ? styles.smallHeight : styles.tallHeight,
            ]}>
            {pincodeDetailsShown ? (
              <>
                <Text style={styles.locationTitleText}>Enter Location</Text>
                <View
                  style={[
                    styles.pincodeInputContainer,
                    {
                      borderColor: pincode?.length
                        ? colors.inputBoxDarkBorder
                        : colors.inputBoxLightBorder,
                    },
                  ]}>
                  {/* <InputField
                    editable={pincode?.length <= 6}
                    value={pincode}
                    showAnimatedLabel={true}
                    maxLength={6}
                    onChangeText={onChangePin}
                    textStyle={styles.inputBoxStyle}
                    placeholder="Enter Pincode"
                    style={styles.pincodeInputStyle}
                    keyboardType="decimal-pad"
                  /> */}
                  <TextInput
                    value={pincode}
                    maxLength={6}
                    label={'Enter Pincode'}
                    onChangeText={onChangePin}
                    keyboardType={'decimal-pad'}
                    underlineStyle={{ width: 0 }}
                    placeholderTextColor={colors.subTitleLightGray}
                    onBlur={() => bottomSheetModalRef.current?.snapToIndex(0)}
                    onFocus={() => bottomSheetModalRef.current?.expand()}
                    style={styles.pincodeInputStyle}
                    theme={{ colors: { primary: colors.subTitleLightGray } }}
                  />
                  {loading ? (
                    <ActivityIndicator
                      size={'small'}
                      color={colors.themePurple}
                    />
                  ) : (
                    <TouchableOpacity
                      onPress={onApplyPincode}
                      disabled={pincode?.length == 6 ? false : true}
                      activeOpacity={0.6}>
                      <Text
                        style={
                          pincode?.length == 6
                            ? styles.activeApplyText
                            : styles.inactiveApplyText
                        }>
                        Apply
                      </Text>
                    </TouchableOpacity>
                  )}
                </View>
                {error.length > 0 && <Text style={styles.error}>{error}</Text>}
                <TouchableOpacity
                  onPress={onPressUseCurrentLocation}
                  style={styles.currentLocationContainer}
                  activeOpacity={0.6}>
                  <Icons.LocationSymbol />
                  <Text style={styles.currentLocationText}>
                    Use Current Location
                  </Text>
                </TouchableOpacity>
              </>
            ) : (
              <>
                <Icons.LocationInactive />
                <View style={styles.textContainer}>
                  <Text style={styles.titleText}>
                    Device location not enabled
                  </Text>
                  <Text style={styles.subText}>
                    Granting location permission will ensure accurate location
                  </Text>
                </View>
                <View style={styles.buttonContainer}>
                  <Button
                    title={'Select Manually'}
                    onPress={() => {
                      trackEvent("CLICKED_SELECT_MANUALLY", {
                        bottom_sheet_name: "grant location permission"
                      })
                      setPincodeDetailsShown(true);
                    }}
                    titleStyle={styles.outlinedButtonText}
                    buttonStyle={styles.outlinedButton}
                    activeOpacity={0.6}
                    loaderColor={colors.themePurple}
                  />
                  <Button
                    title={'Grant'}
                    onPress={() => {
                      trackEvent("CLICKED_GRANT_LOCATION", {
                        bottom_sheet_name: "grant location permission"
                      })
                      Platform.OS == 'android'
                        ? requestLocationPermission(
                          ['blocked', 'never_ask_again'].includes(
                            locationPermission || '',
                          )
                            ? true
                            : false,
                        )
                        : requestLocationPermission(true);
                    }}
                    titleStyle={styles.filledButtonText}
                    buttonStyle={styles.filledButton}
                    activeOpacity={0.6}
                  // disabled={locationPermission === 'never_ask_again' ? true : false}
                  />
                </View>
              </>
            )}
          </View>
        </BottomSheetModal>
      </BottomSheetModalProvider>
    );
  },
);

export default LocationBottomSheet;

const styles = StyleSheet.create({
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    ...StyleSheet.absoluteFillObject,
  },
  container: {
    borderTopRightRadius: 20,
    borderTopLeftRadius: 20,
  },
  error: {
    color: colors.red,
    fontSize: 12,
    alignSelf: 'flex-start',
  },
  sheetContainer: {
    padding: 15,
    // flex: 1,
    width: '100%',
    alignItems: 'center',
  },
  smallHeight: {
    height: '40%',
    justifyContent: 'space-between',
  },
  tallHeight: {
    height: '30%',
  },
  textContainer: {
    flexDirection: 'column',
    alignItems: 'center',
  },
  titleText: {
    fontSize: 20,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.labelDarkGray,
    textAlign: 'center',
  },
  subText: {
    fontSize: 12,
    fontFamily: 'SFProDisplay-Semibold',
    color: colors.subTitleLightGray,
    textAlign: 'center',
  },
  buttonContainer: {
    flexDirection: 'row',
    gap: 10,
  },
  outlinedButton: {
    borderWidth: 1,
    borderColor: colors.themePurple,
    backgroundColor: colors.white,
    borderRadius: 16,
    flex: 1,
  },
  outlinedButtonText: {
    fontSize: 16,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.themePurple,
  },
  filledButton: {
    backgroundColor: colors.themePurple,
    borderRadius: 16,
    flex: 1,
  },
  filledButtonText: {
    fontSize: 16,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.white,
  },
  pincodeInputContainer: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    width: '100%',
    height: 60,
    borderWidth: 1,
    borderRadius: 12,
    paddingHorizontal: 10,
    paddingVertical: 0,
    marginVertical: 10,
  },
  locationTitleText: {
    fontSize: 18,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.labelTitleDarkGray,
    alignSelf: 'flex-start',
    marginBottom: 10,
  },
  pincodeInputStyle: {
    flex: 1,
    backgroundColor: colors.white,
    color: colors.black,
    fontFamily: 'SFProDisplay-Bold',
    fontSize: 14,
  },
  activeApplyText: {
    fontSize: 12,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.themePurple,
  },
  inactiveApplyText: {
    fontSize: 12,
    fontFamily: 'SFProDisplay-Bold',
    color: colors.inactiveGray,
  },
  inputBoxStyle: {
    color: colors.inputValueDarkGray,
    fontFamily: 'SFProDisplay-Bold',
    fontSize: 16,
  },
  currentLocationContainer: {
    flexDirection: 'row',
    gap: 10,
    alignSelf: 'flex-start',
    marginTop: 10,
  },
  currentLocationText: {
    color: colors.inputValueDarkGray,
    fontFamily: 'SFProDisplay-Bold',
  },
});
