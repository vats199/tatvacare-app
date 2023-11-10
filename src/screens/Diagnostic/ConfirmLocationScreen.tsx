import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useRef, useCallback, useEffect, useState } from 'react';
import MapView, { Marker } from 'react-native-maps';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import {
    BottomSheetBackdrop,
    BottomSheetBackdropProps,
    BottomSheetModal,
    BottomSheetModalProvider,
} from '@gorhom/bottom-sheet';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { GooglePlacesAutocomplete } from 'react-native-google-places-autocomplete';
import BottomSheetLocation from '../../components/molecules/BottomSheetLocation';
import EnterAddressBottomSheet from '../../components/organisms/EnterAddressBottomSheet';
import BottomSheetSelectAddress from '../../components/molecules/BottomSheetSelectAddress';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import AsyncStorage from '@react-native-async-storage/async-storage';

type ConfirmLocationScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'ConfirmLocation'
>;
export type addressItem = {
    id?: number;
    title?: string;
    description?: string;
}
export type location = {
    lat?: any;
    lng?: any;
}
export type address = {
    streetName?: string;
    cityName?: string;
}


const API_KEY = "AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo";


const ConfirmLocationScreen: React.FC<ConfirmLocationScreenProps> = ({ route, navigation }) => {

    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedBottomsheet, setSelectedBottomsheet] = useState<string>("Location");
    const [selectedLocation, setSelectedLocation] = useState<location>({ lat: 37.78825, lng: -122.4324 });
    const [selectedAddress, setSelectedAddress] = useState<address>({});
    const snapPoints = (selectedBottomsheet === "Location") ? ["30%"] : (selectedBottomsheet === "Enter Address") ? ['75%'] : ['65%'];
    const insets = useSafeAreaInsets();

    useEffect(() => {

        if (selectedLocation) {
            getAddress(selectedLocation.lat, selectedLocation.lng);
        }
    }, [selectedLocation]);

    useEffect(() => {
        handlePresentModalPress();
    }, [selectedAddress, selectedLocation, selectedBottomsheet]);

    const handlePresentModalPress = useCallback(() => {
        bottomSheetModalRef.current?.present();
    }, []);

    const getAddress = async (lat: any, lng: any) => {
        const uri = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${API_KEY}&enable_address_descriptor=true`;
        const response = await fetch(uri);
        if (!response.ok) {
            throw new Error("failed to fetch");
        }
        const data = await response.json();
        console.log("data", data.results[0]);
        const street = data.results[0].address_components[1].long_name;
        const city = data.results[0].address_components[0].long_name;
        setSelectedAddress({ streetName: street, cityName: city });
    }

    const options: addressItem[] = [
        {
            id: 1,
            title: 'Office',
            description: 'Zydus cadila, Hari Om Nagar, Chandralok society, Ghodsar,Ahmdabad,Gujrat 380050'
        },
        {
            id: 2,
            title: 'Home',
            description: 'Zydus cadila, Hari Om Nagar, Chandralok society, Ghodsar,Ahmdabad,Gujrat 380050'
        },
        {
            id: 3,
            title: 'Other',
            description: 'Zydus cadila, Hari Om Nagar, Chandralok society, Ghodsar,Ahmdabad,Gujrat 380050'
        }
    ]

    const onPressCurrentLocation = async () => {
        const currentLocation = await AsyncStorage.getItem('location');
        if (currentLocation) {
            const location = JSON.parse(currentLocation);
            setSelectedAddress({ streetName: location.city, cityName: location.country })
        }
    }

    const onPressBack = () => {
        navigation.goBack();
    }
    const locationPicker = (event: any) => {
        const lat = event.nativeEvent.coordinate.latitude;
        const lng = event.nativeEvent.coordinate.longitude;
        console.log(lat, lng);
        setSelectedLocation({ lat: lat, lng: lng })
    }
    const renderBackdrop = React.useCallback(
        (props: BottomSheetBackdropProps) => (
            <BottomSheetBackdrop
                {...props}
                opacity={1}
                appearsOnIndex={0}
                disappearsOnIndex={-1}
                style={(selectedBottomsheet === 'Location') ? styles.overlay : styles.overlayBlur}
            // pressBehavior={(selectedBottomsheet === 'Location') ? "none" : "close"}
            />
        ),
        [selectedBottomsheet],
    );


    return (
        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(16) : insets.bottom }]}>
            <MyStatusbar />
            <View style={styles.headerContainer}>
                <View style={styles.headerRow}>
                    <Icons.backArrow height={20} width={20} onPress={onPressBack} />
                    <Text style={styles.titleStyle}> Confirm Location</Text>
                </View>

            </View>
            <View style={{ flex: 1, position: 'relative' }}>
                <MapView
                    style={{ height: '100%', width: "100%" }}
                    region=
                    {{
                        latitude: selectedLocation.lat,
                        longitude: selectedLocation.lng,
                        latitudeDelta: 0.0922,
                        longitudeDelta: 0.0421,
                    }}
                    onPress={locationPicker}
                >
                    {
                        selectedLocation && (
                            <Marker title="Picked Location" coordinate={{ latitude: selectedLocation.lat, longitude: selectedLocation.lng }}>
                                <Icons.Marker width={48} height={51} />
                            </Marker>
                        )
                    }
                </MapView >
                <View style={{ width: "90%", position: 'absolute', top: Matrics.s(20), left: Matrics.s(20), right: Matrics.s(20) }}>
                    <TouchableOpacity
                        style={styles.searchContainer}
                        activeOpacity={1}
                    >
                        <Icons.Search width={20} height={20} />
                        <GooglePlacesAutocomplete
                            placeholder='Search for area,stree name...'
                            onPress={(data, details = null) => {
                                setSelectedLocation({ lat: details?.geometry?.location.lat, lng: details?.geometry?.location.lng })
                            }}
                            fetchDetails
                            query={{
                                key: 'AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo',
                                language: 'en',
                            }}
                        />
                    </TouchableOpacity>
                </View>
                <View style={{ width: "50%", position: "absolute", left: Matrics.s(80), bottom: Matrics.s(200) }}>
                    <TouchableOpacity style={styles.useCurrentLocationContainer} onPress={onPressCurrentLocation}>
                        <Icons.LocationColoredSymbol width={16} height={16} />
                        <Text style={styles.useCurrentlocationtext}>use current Location</Text>
                    </TouchableOpacity>
                </View>
            </View >

            <BottomSheetModalProvider>
                <BottomSheetModal
                    ref={bottomSheetModalRef}
                    backdropComponent={renderBackdrop}
                    index={0}
                    snapPoints={snapPoints}
                    handleIndicatorStyle={styles.handleIndicator}
                    backgroundStyle={styles.sheetBackGround}
                    onDismiss={() => setSelectedBottomsheet("Location")}
                >
                    <View style={{ flex: 1 }}>
                        {
                            (selectedBottomsheet === 'Location') && (
                                <BottomSheetLocation
                                    locationTitle={selectedAddress.cityName}
                                    locationDescription={selectedAddress.streetName}
                                    onPressAddCompleteAddress={() => setSelectedBottomsheet('Select Address')}
                                />
                            )
                        }
                        {
                            (selectedBottomsheet === 'Enter Address') && (
                                <EnterAddressBottomSheet
                                    buttonTitle="Add Address"
                                    onPressSaveAddress={() => {
                                        bottomSheetModalRef.current?.close();
                                        navigation.goBack();
                                    }}
                                />
                            )
                        }
                        {
                            (selectedBottomsheet === 'Select Address') && (
                                <BottomSheetSelectAddress
                                    data={options}
                                    onPressAddNew={() => setSelectedBottomsheet('Enter Address')}
                                    onPressAdddressItem={() => navigation.goBack()}
                                />
                            )
                        }
                    </View>
                </BottomSheetModal>
            </BottomSheetModalProvider>
        </SafeAreaView >

    )
}

export default ConfirmLocationScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
    },
    overlay: {
        backgroundColor: 'transparent',
        ...StyleSheet.absoluteFillObject,
    },
    overlayBlur: {
        backgroundColor: 'rgba(0,0,0,0.5)',
        ...StyleSheet.absoluteFillObject,
    },
    headerContainer: {
        paddingTop: Matrics.s(30),
        paddingBottom: Matrics.s(20),
        paddingLeft: Matrics.s(20),
        backgroundColor: "white",
    },
    headerRow: {
        flexDirection: "row",
        alignItems: 'center',
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20)
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        width: "100%",
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: Matrics.s(12),
        paddingHorizontal: Matrics.s(10),
        minHeight: Matrics.vs(44)
    },
    useCurrentLocationContainer: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        borderWidth: 1,
        borderColor: colors.themePurple,
        borderRadius: Matrics.s(12),
        padding: Matrics.s(8),
        backgroundColor: colors.white
    },
    useCurrentlocationtext: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        marginLeft: Matrics.s(8)
    },
    sheetBackGround: {
        backgroundColor: colors.white,
        borderRadius: Matrics.s(16)
    },
    handleIndicator: {
        backgroundColor: colors.lightGrey,
        width: Matrics.s(40),
        height: Matrics.vs(3.5),
    },

})