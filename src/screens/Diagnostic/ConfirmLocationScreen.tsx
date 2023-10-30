import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useRef, useCallback, useEffect, useState } from 'react';
import MapView, { Marker } from 'react-native-maps';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import { GooglePlacesAutocomplete } from 'react-native-google-places-autocomplete';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import BottomSheetLocation from '../../components/molecules/BottomSheetLocation';
import EnterAddressBottomSheet from '../../components/organisms/EnterAddressBottomSheet';
import BottomSheetSelectAddress from '../../components/molecules/BottomSheetSelectAddress';

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

    useEffect(() => {

        if (selectedLocation) {
            getAddress(selectedLocation.lat, selectedLocation.lng);
        }
    }, [selectedLocation]);

    useEffect(() => {
        handlePresentModalPress();
    }, [])
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
        const street = data.results[0].address_components[1].long_name;
        console.log("new", street);
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


    const snapPoints = (selectedBottomsheet === "Location") ? ["40%"] : ['80%'];

    const onPressBack = () => {
        navigation.goBack();
    }
    const locationPicker = (event: any) => {
        const lat = event.nativeEvent.coordinate.latitude;
        const lng = event.nativeEvent.coordinate.longitude;
        console.log(lat, lng);
        setSelectedLocation({ lat: lat, lng: lng })
    }
    return (
        <View style={{ flex: 1 }}>
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
                            <Marker title="Picked Location" coordinate={{ latitude: selectedLocation.lat, longitude: selectedLocation.lng }} />
                        )
                    }
                </MapView >
                <View style={{ width: "90%", position: 'absolute', top: 20, left: 20, right: 20 }}>
                    <TouchableOpacity
                        style={styles.searchContainer}
                        activeOpacity={1}
                    >
                        <Icons.Search />
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
                <View style={{ width: "50%", position: "absolute", left: 80, bottom: 200 }}>
                    <View style={styles.useCurrentLocationContainer}>
                        <Icons.LocationColoredSymbol width={16} height={16} />
                        <Text style={styles.useCurrentlocationtext}>use current Location</Text>
                    </View>
                </View>
            </View >
            <CommonBottomSheetModal snapPoints={snapPoints} ref={bottomSheetModalRef} >
                {
                    (selectedBottomsheet === 'Location') && (
                        <BottomSheetLocation
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
                        />
                    )
                }
            </CommonBottomSheetModal>
        </View >

    )
}

export default ConfirmLocationScreen

const styles = StyleSheet.create({
    headerContainer: {
        paddingTop: 30,
        paddingBottom: 20,
        paddingLeft: 20,
        backgroundColor: "white",
    },
    headerRow: {
        flexDirection: "row",
        alignItems: 'center',
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        width: "100%",
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: 12,
        paddingHorizontal: 10,
        minHeight: 44
    },
    useCurrentLocationContainer: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        borderWidth: 1,
        borderColor: colors.themePurple,
        borderRadius: 12,
        padding: 8,
        backgroundColor: colors.white
    },
    useCurrentlocationtext: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        marginLeft: 8
    },


})