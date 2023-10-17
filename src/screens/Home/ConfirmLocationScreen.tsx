import { StyleSheet, Text, View, KeyboardAvoidingView, TouchableOpacity, TextInput } from 'react-native'
import React, { useRef, useMemo, useCallback, useEffect, useState } from 'react';
import RadioGroup, { RadioButtonProps } from 'react-native-radio-buttons-group';
import MapView from 'react-native-maps';
import {
    AppStackParamList,
    DrawerParamList,
    BottomTabParamList,
    HomeStackParamList,
} from '../../interface/Navigation.interface';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import { Container, Screen } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { CompositeScreenProps } from '@react-navigation/native';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../../components/atoms/Button';
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import { FloatingLabelInput } from 'react-native-floating-label-input';
// import MapView from 'react-native-maps';

type ConfirmLocationScreenProps = CompositeScreenProps<
    StackScreenProps<HomeStackParamList, 'ConfirmLocation'>,
    CompositeScreenProps<
        BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
        StackScreenProps<AppStackParamList, 'DrawerScreen'>
    >
>;

const ConfirmLocationScreen: React.FC<ConfirmLocationScreenProps> = ({ route, navigation }) => {

    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedId, setSelectedId] = useState<string | undefined>();
    const radioButtons = useMemo(() => ([
        {
            id: '1',
            label: 'Home',
            value: 'option1'
        },
        {
            id: '2',
            label: 'Office',
            value: 'option2'
        },
        {
            id: '3',
            label: 'Other',
            value: 'option2'
        }
    ]), []);

    const handleRadioPress = (radio: string) => {

        setSelectedId(radio.id);
    };


    const normalRadioStyle = {
        backgroundColor: 'white',
    };

    const pressedRadioStyle = {
        backgroundColor: 'red',
    };


    const snapPoints = useMemo(() => ['10%', '75%'], []);

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
                    initialRegion={{
                        latitude: 37.78825,
                        longitude: -122.4324,
                        latitudeDelta: 0.0922,
                        longitudeDelta: 0.0421,
                    }}
                />
                <View style={{ width: "90%", position: 'absolute', top: 20, left: 20, right: 20 }}>
                    <TouchableOpacity
                        style={styles.searchContainer}
                        activeOpacity={1}
                    >
                        <Icons.Search />
                        <TextInput placeholder='Search for area, street name...' />
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
                    <View style={styles.contentContainer}>
                        <Text style={styles.enterAddressTitle}>Enter Address </Text>
                        <View style={styles.border} />
                        <View style={{ padding: 20 }}>
                            <View style={styles.disclaimerBox}>
                                <Text style={styles.disclaimerText}>Disclaimer: We need this information to deliver your product & for
                                    collecting test samples</Text>

                            </View>
                            <View style={{ marginVertical: 5 }}>
                                <AnimatedInputField placeholder='Enter Pincode' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} />
                            </View>
                            <View style={{ marginVertical: 5 }}>
                                <AnimatedInputField placeholder='House number and Building *' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} />
                            </View>
                            <View style={{ marginVertical: 5 }}>
                                <AnimatedInputField placeholder='Street name *' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} />
                            </View>
                            <View>
                                <Text>Address Type</Text>
                                <RadioGroup
                                    radioButtons={radioButtons}
                                    selectedId={selectedId}
                                    layout='row'
                                    onPress={handleRadioPress}
                                    radioStyle={(radio, selected) => ({

                                        ...normalRadioStyle,
                                        ...(selected && pressedRadioStyle),
                                    })}
                                />
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
                    {/* <View style={{ flex: 1, padding: 15 }}>
                        <View style={{ flexDirection: "row", justifyContent: "flex-start" }}>
                            <Icons.LocationActive height={24} width={24} style={{ marginTop: 5 }} />
                            <View style={{ marginLeft: 15 }}>
                                <Text style={styles.locationTitle}>Lower Parel</Text>
                                <Text style={styles.locationDescription}>LBS Marg</Text>
                            </View>
                        </View>
                        <View style={{ marginTop: 20 }}>
                            <Button
                                title="Add Complete Adddress"
                                titleStyle={styles.outlinedButtonText}
                                buttonStyle={styles.outlinedButton}

                            />
                        </View>
                    </View> */}
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
        borderBottomColor: "#7D7D7D"
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
        backgroundColor: colors.themePurple
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
    }
})