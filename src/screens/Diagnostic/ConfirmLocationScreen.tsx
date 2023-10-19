import { StyleSheet, Text, View, KeyboardAvoidingView, TouchableOpacity, TextInput } from 'react-native'
import React, { useRef, useMemo, useCallback, useEffect, useState } from 'react';
import RadioGroup, { RadioButtonProps } from 'react-native-radio-buttons-group';
import MapView, { Marker } from 'react-native-maps';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import { Container, Screen } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../../components/atoms/Button';
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import Geocoder from 'react-native-geocoding';
import { GooglePlacesAutocomplete } from 'react-native-google-places-autocomplete';

// import MapView from 'react-native-maps';

type ConfirmLocationScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'ConfirmLocation'
>;
type addressItem = {
    id?: number;
    title?: string;
    description?: string;
}
type location = {
    lat?: any;
    lng?: any;
}

const API_KEY = "AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo";
Geocoder.init("AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo");

const ConfirmLocationScreen: React.FC<ConfirmLocationScreenProps> = ({ route, navigation }) => {

    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedButton, setSelectedButton] = useState<string | undefined>('');
    const [selectedBottomsheet, setSelectedBottomsheet] = useState<string>("Location");
    const [selectedLocation, setSelectedLocation] = useState<location>();
    const [selectedAddress, setSelectedAddress] = useState<string>();
    const [searchText, setSearchText] = useState<string>();

    console.log("selected Location::", selectedLocation);

    useEffect(() => {
        console.log("inside the address useeffect");
        if (selectedLocation) {
            console.log("inside the calling the address");
            getAddress(selectedLocation.lat, selectedLocation.lng);
        }
    }, [selectedLocation])

    // useEffect(() => {
    //     console.log("inside the search useeffect");
    //     if (searchText) {
    //         console.log("inside the calling the search");
    //         Geocoder.from(searchText)
    //             .then(json => {
    //                 var location = json.results[0];
    //                 console.log("location", location);

    //                 //setSelectedLocation(location);
    //                 console.log("hry")
    //             })
    //             .catch(error => console.warn(error));
    //     }
    // }, [searchText])

    useEffect(() => {
        if (searchText) {

            getLatitudeLongitude(searchText);

        }

    }, [searchText])

    const getLatitudeLongitude = async (searchText: string) => {
        console.log("inside lattitude");
        const encodedAddress = encodeURIComponent(searchText);
        const geocodingUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}&key=${API_KEY}`;

        try {
            const response = await fetch(geocodingUrl);
            if (!response.ok) {
                throw new Error('Request failed');
            }
            const data = await response.json();
            if (data.status === 'OK') {
                const location = data.results[0].geometry.location;
                const latitude = location.lat;
                const longitude = location.lng;
                console.log(`Latitude: ${latitude}, Longitude: ${longitude}`);
            } else {
                console.error('Geocoding request failed:', data.status);
            }
        } catch (error) {
            console.error('Error fetching geocoding data:', error);
        }
    }


    const getAddress = async (lat: any, lng: any) => {
        console.log("inside the getting the address");
        const uri = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${API_KEY}&enable_address_descriptor=true`;
        const response = await fetch(uri);
        if (!response.ok) {
            throw new Error("failed to fetch");
        }

        const data = await response.json();
        const address = data.results[0].formatted_address;
        console.log(address);
        setSelectedAddress(address);
    }

    // const radioButtons = useMemo(() => ([
    //     {
    //         id: '1',
    //         label: 'Home',
    //         value: 'option1'
    //     },
    //     {
    //         id: '2',
    //         label: 'Office',
    //         value: 'option2'
    //     },
    //     {
    //         id: '3',
    //         label: 'Other',
    //         value: 'option2'
    //     }
    // ]), []);

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


    const snapPoints = (selectedBottomsheet === "Location") ? ["10%", "30%"] : ["10%", '80%'];

    useEffect(() => {
        handlePresentModalPress();
    }, [])
    const handlePresentModalPress = useCallback(() => {
        bottomSheetModalRef.current?.present();
    }, []);
    const handleSheetChanges = useCallback((index: number) => {
        console.log('handleSheetChanges', index);
    }, []);

    const onPressBack = () => {
        navigation.goBack();
    }
    const locationPicker = (event: any) => {
        console.log("inside the location picker");

        const lat = event.nativeEvent.coordinate.latitude;
        const lng = event.nativeEvent.coordinate.longitude;
        console.log(lat, lng);
        setSelectedLocation({ lat: lat, lng: lng })
    }

    const renderAddressItem = (item: addressItem, idex: number) => {
        return (
            <View style={styles.addressItemContainer}>
                <View style={{ flexDirection: "row", width: "70%" }}>
                    <View style={{ marginRight: 5 }}>
                        {
                            (item.title === "Home") ? (
                                <Icons.Home width={28} height={28} />
                            ) : <Icons.Person width={28} height={28} />
                        }
                    </View>
                    <View >
                        <Text style={styles.addressTitleText}>{item.title}</Text>
                        <Text style={styles.addressDescription}>{item.description}</Text>
                    </View>
                </View>
                <View style={{ alignItems: "flex-end" }}>
                    <Icons.ThreeDot width={16} height={16} />
                </View>
            </View>
        );
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
                    initialRegion={selectedLocation ? {
                        latitude: selectedLocation.lat,
                        longitude: selectedLocation.lng,
                        latitudeDelta: 0.0922,
                        longitudeDelta: 0.0421,
                    } : {
                        latitude: 37.78825,
                        longitude: -122.4324,
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
                                // 'details' is provided when fetchDetails = true
                                console.log(data, details);
                            }}
                            query={{
                                key: 'AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo',
                                language: 'en',
                            }}
                        />
                    </TouchableOpacity>
                </View>
                <View style={{ width: "50%", position: "absolute", left: 80, bottom: 160 }}>
                    <View style={styles.useCurrentLocationContainer}>
                        <Icons.LocationColoredSymbol width={16} height={16} />
                        <Text style={styles.useCurrentlocationtext}>use current Location</Text>
                    </View>
                </View>
            </View >


            <BottomSheetModalProvider>
                <BottomSheetModal
                    ref={bottomSheetModalRef}
                    index={1}
                    snapPoints={snapPoints}
                    onChange={handleSheetChanges}
                    keyboardBehavior="interactive"
                >
                    {
                        (selectedBottomsheet === 'Add Address') && (
                            <View style={styles.contentContainer}>
                                <Text style={styles.enterAddressTitle}>Enter Address </Text>
                                <View style={styles.border} />
                                <View style={{ padding: 20 }}>
                                    <View style={styles.disclaimerBox}>
                                        <Text style={styles.disclaimerText}>Disclaimer: We need this information to deliver your product & for
                                            collecting test samples</Text>

                                    </View>
                                    <View style={{ marginVertical: 5 }}>
                                        <AnimatedInputField placeholder='Enter Pincode' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} showAnimatedLabel={true} />
                                    </View>
                                    <View style={{ marginVertical: 5 }}>
                                        <AnimatedInputField placeholder='House number and Building *' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} showAnimatedLabel={true} />
                                    </View>
                                    <View style={{ marginVertical: 5 }}>
                                        <AnimatedInputField placeholder='Street name *' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} showAnimatedLabel={true} />
                                    </View>
                                    <View>
                                        <Text style={styles.addessTypeText}>Address Type</Text>
                                        {/* <RadioGroup
                                            radioButtons={radioButtons}
                                            layout='row'
                                        // containerStyle={{ backgroundColor: 'red' }}

                                        /> */}
                                        <View style={{ flexDirection: "row", alignItems: "center" }}>
                                            <View style={{ flexDirection: "row", alignItems: "center", marginRight: 20 }}>
                                                <TouchableOpacity onPress={() => setSelectedButton("Home")} >
                                                    {
                                                        (selectedButton === 'Home') ?
                                                            <Icons.RadioCheck style={{ marginRight: 10 }} height={20} width={20} /> :
                                                            <Icons.RadioUncheck style={{ marginRight: 10 }} height={20} width={20} />
                                                    }
                                                </TouchableOpacity>
                                                <Text>Home</Text>
                                            </View>
                                            <View style={{ flexDirection: "row", alignItems: "center", marginRight: 20 }}>
                                                <TouchableOpacity onPress={() => setSelectedButton("Office")}>
                                                    {
                                                        (selectedButton === 'Office') ?
                                                            <Icons.RadioCheck style={{ marginRight: 10 }} height={20} width={20} /> :
                                                            <Icons.RadioUncheck style={{ marginRight: 10 }} height={20} width={20} />
                                                    }
                                                </TouchableOpacity>
                                                <Text>Office</Text>
                                            </View>
                                            <View style={{ flexDirection: "row", alignItems: "center", marginRight: 20 }}>
                                                <TouchableOpacity onPress={() => setSelectedButton("Other")}>
                                                    {
                                                        (selectedButton === 'Other') ?
                                                            <Icons.RadioCheck style={{ marginRight: 10 }} height={20} width={20} /> :
                                                            <Icons.RadioUncheck style={{ marginRight: 10 }} height={20} width={20} />
                                                    }
                                                </TouchableOpacity>
                                                <Text>Other</Text>
                                            </View>
                                        </View>
                                    </View>
                                    <View style={{ marginTop: 20 }}>
                                        <Button
                                            title="Save Adddress"
                                            titleStyle={styles.outlinedButtonText}
                                            buttonStyle={styles.outlinedButton}

                                        />
                                    </View>
                                </View>
                            </View>
                        )
                    }
                    {
                        (selectedBottomsheet === 'Location') && (
                            <View style={{ flex: 1, padding: 15 }}>
                                <View style={{ flexDirection: "row", justifyContent: "flex-start" }}>
                                    <Icons.LocationActive height={24} width={24} style={{ marginTop: 5 }} />
                                    <View style={{ marginLeft: 15 }}>
                                        <Text style={styles.locationTitle}>{selectedAddress}</Text>
                                        <Text style={styles.locationDescription}>LBS Marg</Text>
                                    </View>
                                </View>
                                <View style={{ marginTop: 20 }}>
                                    <Button
                                        title="Add Complete Adddress"
                                        titleStyle={styles.outlinedButtonText}
                                        buttonStyle={styles.outlinedButton}
                                        onPress={() => setSelectedBottomsheet("Select Address")}
                                    />
                                </View>
                            </View>
                        )
                    }
                    {
                        (selectedBottomsheet === 'Select Address') && (
                            <View style={styles.contentContainer}>
                                <View style={styles.upperRow}>
                                    <Text style={styles.selectAddressTitle}> Select Address</Text>
                                    <TouchableOpacity style={styles.upperSubRow} onPress={() => setSelectedBottomsheet("Add Address")} >
                                        <Icons.AddCircle height={13} width={13} />
                                        <Text style={styles.addNewText}> Add New</Text>
                                    </TouchableOpacity>
                                </View>
                                <View style={styles.border} />
                                <View style={{ padding: 10 }}>
                                    {options.map(renderAddressItem)}
                                </View>
                            </View>
                        )
                    }
                </BottomSheetModal>

            </BottomSheetModalProvider>
        </View >

    )
}

export default ConfirmLocationScreen

const styles = StyleSheet.create({
    headerContainer: {
        paddingTop: 40,
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
    container: {
        flex: 1,
        padding: 24,
        justifyContent: 'center',
        backgroundColor: 'grey',
    },
    contentContainer: {
        flex: 1,
    },
    enterAddressTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
        marginBottom: 10
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: "#E9E9E9",
        marginTop: 10
    },
    disclaimerBox: {
        padding: 10,
        borderWidth: 1,
        borderColor: "#F0F0F0",
        borderRadius: 12
    },
    disclaimerText: {
        fontSize: 10,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    locationTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    locationDescription: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginTop: 5
    },
    outlinedButtonText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
    },
    outlinedButton: {
        padding: 10,
        height: 40,
        borderRadius: 16,
        backgroundColor: colors.themePurple,
        marginHorizontal: 0
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
    inputStyle: {
        backgroundColor: 'white',
        height: 44,
        borderColor: '#E0E0E0',
        borderWidth: 1.3,
        borderRadius: 14,
        paddingHorizontal: 8,

    },
    placeholderText: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    },
    addessTypeText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: 10
    },
    selectAddressTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,

    },
    // border: {
    //     borderBottomWidth: 1,
    //     borderBottomColor: "#7D7D7D"
    // },
    upperRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
        paddingHorizontal: 15
    },
    upperSubRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
    },
    addNewText: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,

    },
    addressItemContainer: {
        flexDirection: "row",
        justifyContent: "space-between",
        padding: 10,
        backgroundColor: colors.white,
        borderRadius: 10,
        marginVertical: 10,
        // marginHorizontal: 15,
        borderWidth: 1,
        borderColor: colors.white,
        elevation: 2
    },
    addressTitleText: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    addressDescription: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    }
})