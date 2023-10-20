import { StyleSheet, Text, View, KeyboardAvoidingView, TouchableOpacity } from 'react-native'
import React, { useRef, useCallback, useEffect, useState } from 'react';
import MapView, { Marker } from 'react-native-maps';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../../components/atoms/Button';
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import { GooglePlacesAutocomplete } from 'react-native-google-places-autocomplete';

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
type address = {
    streetName?: string;
    cityName?: string;
}


const API_KEY = "AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo";


const ConfirmLocationScreen: React.FC<ConfirmLocationScreenProps> = ({ route, navigation }) => {

    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedButton, setSelectedButton] = useState<string | undefined>('');
    const [selectedBottomsheet, setSelectedBottomsheet] = useState<string>("Location");
    const [selectedLocation, setSelectedLocation] = useState<location>({ lat: 37.78825, lng: -122.4324 });
    const [selectedAddress, setSelectedAddress] = useState<address>({});

    useEffect(() => {

        if (selectedLocation) {
            getAddress(selectedLocation.lat, selectedLocation.lng);
        }
    }, [selectedLocation])

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


    const snapPoints = (selectedBottomsheet === "Location") ? ["20%", "40%"] : ["20%", '80%'];

    useEffect(() => {
        handlePresentModalPress();
    }, [])
    const handlePresentModalPress = useCallback(() => {
        bottomSheetModalRef.current?.present();
    }, []);
    const handleSheetChanges = useCallback((index: number) => {
        // console.log('handleSheetChanges', index);
    }, []);

    const onPressBack = () => {
        navigation.goBack();
    }
    const locationPicker = (event: any) => {
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
                            //ref={ref}
                            placeholder='Search for area,stree name...'
                            onPress={(data, details = null) => {
                                // 'details' is provided when fetchDetails = true
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


            <BottomSheetModalProvider>
                <BottomSheetModal
                    ref={bottomSheetModalRef}
                    index={1}
                    snapPoints={snapPoints}
                    onChange={handleSheetChanges}
                    keyboardBehavior="interactive"
                    overDragResistanceFactor={3.8}
                // enableDynamicSizing={true}

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
                                            buttonStyle={styles.saveAddressButton}
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
                                        <Text style={styles.locationTitle}>{selectedAddress.streetName}</Text>
                                        <Text style={styles.locationDescription}>{selectedAddress.cityName}</Text>
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
                            <KeyboardAvoidingView style={styles.contentContainer} behavior="padding">
                                <View >
                                    <View style={styles.upperRow}>
                                        <Text style={styles.selectAddressTitle}> Select Address</Text>
                                        <TouchableOpacity style={styles.upperSubRow} onPress={() => setSelectedBottomsheet("Add Address")} >
                                            <Icons.AddCircle height={13} width={13} />
                                            <Text style={styles.addNewText}> Add New</Text>
                                        </TouchableOpacity>
                                    </View>
                                    <View style={styles.border} />
                                </View>
                                <View style={styles.belowContainer}>
                                    {options.map(renderAddressItem)}
                                </View>
                            </KeyboardAvoidingView>
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
    saveAddressButton: {
        padding: 10,
        height: 40,
        borderRadius: 16,
        backgroundColor: colors.inactiveGray,
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
        marginLeft: 10
    },
    belowContainer: {
        flex: 1,
        paddingVertical: 10,
        paddingHorizontal: 15,
        backgroundColor: "#f9f9f9"
    },
    upperRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
        marginBottom: 20,
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
        marginRight: 10
    },
    addressItemContainer: {
        flexDirection: "row",
        justifyContent: "space-between",
        padding: 10,
        backgroundColor: colors.white,
        borderRadius: 10,
        marginVertical: 10,
        elevation: 0.1
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