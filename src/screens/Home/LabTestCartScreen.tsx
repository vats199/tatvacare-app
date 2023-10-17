import { ScrollView, StyleSheet, Text, View, TouchableOpacity, Modal, StatusBar } from 'react-native'
import React, { useState, useEffect, useRef, useCallback, useMemo } from 'react';
import {
    AppStackParamList,
    DrawerParamList,
    BottomTabParamList,
    HomeStackParamList,
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

type LabTestCartScreenProps = CompositeScreenProps<
    StackScreenProps<HomeStackParamList, 'LabTestCart'>,
    CompositeScreenProps<
        BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
        StackScreenProps<AppStackParamList, 'DrawerScreen'>
    >
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
    const data: TestItem[] = route.params?.item;
    const coupanTitle: string = route.params?.coupan;
    // console.log(coupanTitle);

    const bottomSheetModalRef = useRef<BottomSheetModal>(null);

    const snapPoints = useMemo(() => ['10%', '60%'], []);

    const handlePresentModalPress = useCallback(() => {
        console.log("ggg");
        bottomSheetModalRef.current?.present();
    }, []);

    const onPressApplyCoupan = () => {
        navigation.navigate("ApplyCoupan", {});
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
            id: 1,
            name: "Patient Name",
            age: "Gender | Age",
            emailAddress: "email address",
        },
        {
            id: 1,
            name: "Patient Name",
            age: "Gender | Age",
            emailAddress: "email address",
        },
    ]

    const renderPatientItem = (item: patientItem, index: number) => {
        return (
            <View style={styles.patientItem}>
                <View style={{ flexDirection: "row" }}>
                    <Icons.Person height={28} width={28} />
                    <View style={{ marginLeft: 10 }}>
                        <Text style={styles.patientName}>{item.name}</Text>
                        <Text style={styles.discountText}>{item.age}</Text>
                        <Text style={styles.discountText}>{item.emailAddress}</Text>
                    </View>
                </View>
                <View>
                    <Icons.ThreeDot />
                </View>
            </View>
        )
    }


    return (
        <>
            <Screen>

                <ScrollView style={{ flex: 1 }}>
                    <Header
                        title="Lab Test Cart"
                        containerStyle={styles.upperHeader}
                        titleStyle={styles.titleStyle}
                        onBackPress={onBackPress}
                    />
                    <Container >
                        <TestDetails data={data} />
                        <View >
                            <Text style={styles.heading}>Offer & Promotion</Text>
                            <View style={styles.offerContainer}>
                                <View style={{
                                    flexDirection: 'row',
                                    justifyContent: "space-between",
                                    alignItems: 'center'
                                }}>
                                    <Icons.Offer height={28} width={28} />
                                    {
                                        (coupanTitle?.length > 0) ? (
                                            <Text style={styles.applyCoupanText}>{coupanTitle}  Applied</Text>
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
                            onPress={handlePresentModalPress}
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
                            <View style={styles.upperRow}>
                                <Text style={styles.selectAddressTitle}> Select Patient</Text>
                                <TouchableOpacity style={styles.upperSubRow} onPress={addNewPressHandler}>
                                    <Icons.AddCircle height={13} width={13} />
                                    <Text style={styles.addNewText}> Add New</Text>
                                </TouchableOpacity>
                            </View>
                            <View style={styles.border} />
                            <View>
                                {options.map(renderPatientItem)}
                            </View>
                        </View>
                    </BottomSheetModal>
                </BottomSheetModalProvider>

            </Screen >
        </>
    )
}

export default LabTestCartScreen

const styles = StyleSheet.create({
    upperHeader: {
        marginHorizontal: 10,
        // marginTop:20,
        paddingVertical: 15,
        // marginBottom:5
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
    },
    offerContainer: {
        marginVertical: 10,
        padding: 12,
        backgroundColor: colors.white,
        borderRadius: 12,
        minHeight: 52,
        width: '100%',
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center'
    },
    applyCoupanText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
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
    },
    selectPatientButton: {
        marginVertical: 10,
        width: "100%",
        //borderWidth: 1,
        // borderColor: colors.themePurple,
        backgroundColor: colors.darkGray,
        //padding: 10,
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
        marginTop: 12
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
    container: {
        flex: 1,
        backgroundColor: '#F9F9FF'
    },
    contentContainer: {
        flex: 1,
        backgroundColor: '#F9F9FF'
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
    patientItem: {
        flexDirection: "row",
        justifyContent: "space-between",
        marginVertical: 10,
        marginHorizontal: 15,
        padding: 10,
        borderRadius: 10,
        backgroundColor: 'white',
    },
    patientName: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    }
})