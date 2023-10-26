import { ScrollView, StyleSheet, Text, View, TouchableOpacity, Modal, StatusBar } from 'react-native'
import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { Container, Screen } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { CompositeScreenProps } from '@react-navigation/native';
import Header from '../../components/atoms/Header';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import TestDetails from '../../components/organisms/TestDetails';
import { Icons } from '../../constants/icons';
import Billing from '../../components/organisms/Billing';
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import { SafeAreaView } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';

type LabTestCartScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'LabTestCart'
>;
type TestItem = {
    id: number;
    title: string;
    description: string;
    newPrice: number;
    oldPrice: number;
    discount: number;
    isAdded: boolean;
};

type patientItem = {
    id: number;
    name: string;
    age: string;
    emailAddress: string;
}

const LabTestCartScreen: React.FC<LabTestCartScreenProps> = ({ route, navigation }) => {
    const [isClicked, setIsClicked] = useState(false);
    const [cartItems, setCartItems] = useState<TestItem[]>([]);

    const coupanTitle: string = route.params?.coupan;


    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedPatient, setSelectedPatient] = useState<string>();
    const [selecetedCoupan, setSelectedCoupan] = useState<string>();

    console.log("cartItems in lab Test Cart>>>", cartItems);

    useEffect(() => {

        const fetchData = async () => {
            try {
                const storedData = await AsyncStorage.getItem('cartItems');
                if (storedData) {
                    const cartData = JSON.parse(storedData);
                    setCartItems(cartData);
                }
            } catch (error) {
                console.error('Error retrieving data:', error);
            }
        };

        fetchData();
    }, []);

    useEffect(() => {
        if (coupanTitle?.length > 0) {
            setSelectedCoupan(coupanTitle);
        }
    }, [coupanTitle])
    console.log(selectedPatient);

    const snapPoints = useMemo(() => ['10%', '65%'], []);

    const handlePresentModalPress = useCallback(() => {
        //console.log("ggg");
        bottomSheetModalRef.current?.present();
    }, []);

    const onPressApplyCoupan = () => {
        navigation.navigate("ApplyCoupan");
    }
    const onBackPress = () => {
        navigation.goBack();
    }
    const handleModal = () => {
        setIsClicked(!isClicked);
    }

    const onPressAddAddress = () => {
        navigation.navigate("ConfirmLocation");
    }

    const addNewPressHandler = () => {
        navigation.navigate("AddPatientDetails");
    }
    const onPressPatient = (item: string) => {
        // navigation.navigate("LabTestSummary", { data: data })
        bottomSheetModalRef.current?.close();
        setSelectedPatient(item);
    }
    const handleSelectPatient = () => {
        if (selectedPatient && selecetedCoupan) {
            navigation.navigate("SelectTestSlot")
        } else {
            handlePresentModalPress();
        }
    }

    useEffect(() => {
        if (coupanTitle?.length > 0) {
            setIsClicked(true);
        }

    }, [coupanTitle]);

    const options: patientItem[] = [
        {
            id: 1,
            name: "Patient Name",
            age: "Gender | Age",
            emailAddress: "email address",
        },
        {
            id: 2,
            name: "Patient Name",
            age: "Gender | Age",
            emailAddress: "email address",
        },
        {
            id: 3,
            name: "Patient Name",
            age: "Gender | Age",
            emailAddress: "email address",
        },
    ]

    const renderPatientItem = (item: patientItem, index: number) => {
        return (
            <TouchableOpacity style={styles.patientItem}
                onPress={() => onPressPatient(item.name)}
            >
                <View style={{ flexDirection: "row" }}>
                    <Icons.Person height={28} width={28} />
                    <View style={{ marginLeft: 10 }}>
                        <Text style={styles.patientName}>{item.name}</Text>
                        <Text style={styles.ageEmailAddresstext}>{item.age}</Text>
                        <Text style={styles.ageEmailAddresstext}>{item.emailAddress}</Text>
                    </View>
                </View>
                <View>
                    <Icons.ThreeDot />
                </View>
            </TouchableOpacity>
        )
    }


    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <ScrollView style={{ flex: 1, marginBottom: 20 }}>
                <Header
                    title="Lab Test Cart"
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.titleStyle}
                    onBackPress={onBackPress}
                />
                <Container >
                    <TestDetails data={cartItems} title='Test Details' />
                    <View >
                        <Text style={styles.heading}>Offer & Promotions</Text>
                        <View style={styles.offerContainer}>
                            <View style={{
                                flexDirection: 'row',
                                justifyContent: "space-between",
                                alignItems: 'center'
                            }}>
                                {
                                    (coupanTitle?.length > 0) ? (
                                        <Icons.Success height={28} width={28} />
                                    ) : (
                                        <Icons.Offer height={28} width={28} />
                                    )
                                }
                                {
                                    (coupanTitle?.length > 0) ? (
                                        <Text style={styles.applyCoupanText}>{selecetedCoupan}  Applied</Text>
                                    ) : (<Text style={styles.applyCoupanText}> Apply Coupan</Text>)
                                }
                            </View>
                            <View>
                                <Icons.forwardArrow height={16} width={16} onPress={onPressApplyCoupan} />
                            </View>
                        </View>
                    </View>
                    <Billing />
                </Container>
                <View style={styles.bootomContainer}>
                    <View style={styles.row}>
                        <View style={styles.row}>
                            <Icons.Gps height={24} width={24} />
                            <Text style={styles.locationText}>Thite nagar, Kharadi,Pune</Text>
                        </View>
                        <TouchableOpacity onPress={onPressAddAddress} >
                            <Text style={styles.textAddButton}>Add address</Text>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.border} />
                    <TouchableOpacity
                        style={styles.selectPatientButton}
                        onPress={handleSelectPatient}
                    >
                        <Text style={styles.selectPatientText}> Select Patient</Text>

                    </TouchableOpacity>
                </View>
            </ScrollView>
            <View>
                <Modal transparent={true} animationType='slide' visible={isClicked} >
                    <View style={styles.modalContainer}>
                        <View style={styles.modal}>
                            <View style={{ padding: 10 }}>
                                <View style={{ marginTop: 20, justifyContent: 'center', alignItems: 'center' }}>
                                    <Icons.Success height={30} width={30} />
                                </View>
                                <View style={{ marginTop: 20, justifyContent: 'center', alignItems: 'center' }}>
                                    <Text style={styles.orderAppliedText}>{coupanTitle} Applied</Text>
                                    <Text style={styles.discountText}>you got 20 % off on your order</Text>
                                    <TouchableOpacity onPress={handleModal}>
                                        <Text style={styles.gotItText}>Got it, Thanks</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        </View>
                    </View>

                </Modal>

            </View>

            <BottomSheetModalProvider>
                <BottomSheetModal
                    ref={bottomSheetModalRef}
                    index={1}
                    snapPoints={snapPoints}>
                    <View style={styles.contentContainer}>
                        <View style={{
                            paddingHorizontal: 15,
                            borderBottomWidth: 0.3,
                            borderBottomColor: '#ccc',
                            elevation: 0.2
                        }}>
                            <View style={styles.upperRow}>
                                <Text style={styles.selectAddressTitle}> Select Patient</Text>
                                <TouchableOpacity style={styles.upperSubRow} onPress={addNewPressHandler}>
                                    <Icons.AddCircle height={16} width={16} />
                                    <Text style={styles.addNewText}> Add New</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={styles.belowContainer}>
                            {options.map(renderPatientItem)}
                        </View>
                    </View>
                </BottomSheetModal>
            </BottomSheetModalProvider>

        </SafeAreaView>
    );
}

export default LabTestCartScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginHorizontal: 20,
        marginTop: 30,
        marginBottom: 10
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
    heading: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: 10
    },
    offerContainer: {
        marginVertical: 10,
        padding: 12,
        backgroundColor: colors.white,
        borderRadius: 12,
        elevation: 0.3,
        minHeight: 52,
        width: '100%',
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center',
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    applyCoupanText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 10
    },
    billingContainer: {
        marginVertical: 10,
        padding: 12,
        backgroundColor: colors.white,
        borderRadius: 12,
        minHeight: 212,
        width: '100%',
    },
    bootomContainer: {
        marginVertical: 10,
        padding: 18,
        backgroundColor: colors.white,
        borderRadius: 20,
        minHeight: 104,
        width: '100%',
        elevation: 0.3,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    selectPatientButton: {
        marginVertical: 10,
        width: "100%",
        backgroundColor: colors.darkGray,
        minHeight: 40,
        borderRadius: 18,
        justifyContent: 'center',
        alignItems: 'center'
    },
    selectPatientText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white
    },
    textAddButton: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
    row: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center"
    },
    locationText: {
        marginLeft: 15,
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: "#D3D3D3",
        // marginTop: 12
    },
    modalContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        width: '100%'
    },
    modal: {
        width: 288,
        height: 174,
        borderRadius: 14,
        backgroundColor: 'white',
    },
    orderAppliedText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    discountText: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    gotItText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        marginTop: 10
    },
    contentContainer: {
        flex: 1,
        backgroundColor: colors.white
    },
    selectAddressTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,

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

    },
    belowContainer: {
        flex: 1,
        paddingVertical: 10,
        paddingHorizontal: 15,
        backgroundColor: "#f9f9f9"
    },
    patientItem: {
        flexDirection: "row",
        justifyContent: "space-between",
        marginVertical: 7,
        padding: 10,
        borderRadius: 10,
        backgroundColor: "white",
        // borderWidth: 0.7,
        // borderColor: '#f9f9f9',
        elevation: 0.1
    },
    patientName: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 7
    },
    ageEmailAddresstext: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginBottom: 5
    }
})