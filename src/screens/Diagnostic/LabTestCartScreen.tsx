import { ScrollView, StyleSheet, View, Modal } from 'react-native'
import React, { useState, useEffect, useRef, useCallback } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { Container } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import TestDetails from '../../components/organisms/TestDetails';
import Billing from '../../components/organisms/Billing';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import OfferAndPromotion from '../../components/molecules/OfferAndPromotion';
import BottomAdddressLocationButton from '../../components/molecules/BottomAdddressLocationButton';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import SelectPatientBottomSheet from '../../components/organisms/SelectPatientBottomSheet';
import CoupanModal from '../../components/molecules/CoupanModal';
import { useApp } from '../../context/app.context';
import MyStatusbar from '../../components/atoms/MyStatusBar';

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

export type patientItem = {
    id: number;
    name: string;
    age: string;
    emailAddress: string;
}
type billingData = {
    id?: number;
    value?: {
        name?: string;
        price?: string;
    }
}

const LabTestCartScreen: React.FC<LabTestCartScreenProps> = ({ route, navigation }) => {
    const [isClicked, setIsClicked] = useState(false);
    const [cartItems, setCartItems] = useState<TestItem[]>([]);
    const { coupan } = useApp();
    const insets = useSafeAreaInsets();
    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedPatient, setSelectedPatient] = useState<string>();
    const [selecetedCoupan, setSelectedCoupan] = useState<string>();

    const buttonTitle = (selecetedCoupan && selectedPatient) ? "Select TimeSlot" : "Select Patient";
    const backColor = (buttonTitle === 'Select Patient') ? colors.darkGray : colors.themePurple;

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

    const deleteCartItem = async (itemId: number) => {
        try {
            const cart = await AsyncStorage.getItem('cartItems');
            let cartItems: TestItem[] = [];
            if (cart !== null) {
                cartItems = JSON.parse(cart) || [];
            }
            const itemIndex = cartItems.findIndex((item: TestItem) => item.id === itemId);
            if (itemIndex !== -1) {
                cartItems.splice(itemIndex, 1);
                await AsyncStorage.setItem('cartItems', JSON.stringify(cartItems));
                setCartItems(cartItems);
            }
        } catch (error) {
            console.error('Error deleting cart item:', error);
        }

    }


    useEffect(() => {
        if (coupan?.length > 0) {
            setSelectedCoupan(coupan);
            setIsClicked(true);
        }
    }, [coupan]);

    const handlePresentModalPress = useCallback(() => {
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
        bottomSheetModalRef.current?.close();
        navigation.navigate("AddPatientDetails");
    }
    const onPressPatient = (item: string) => {
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


    const PatientOptions: patientItem[] = [
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

    const billing: billingData[] = [
        {
            id: 1,
            value: {
                name: "Item total",
                price: "200"
            }
        },
        {
            id: 2,
            value: {
                name: "Home Collection Charges",
                price: "50"
            }
        },
        {
            id: 3,
            value: {
                name: "Service Charge",
                price: "10"
            }
        },
        {
            id: 4,
            value: {
                name: "Discount on  Item(s)",
                price: "25"
            }
        },
        {
            id: 5,
            value: {
                name: "Applied Coupan(FIRST25)",
                price: "25"
            }
        },
    ]


    return (
        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]} >
            <MyStatusbar />
            <ScrollView style={{ flex: 1 }} showsVerticalScrollIndicator={false}>
                <Header
                    title="Lab Test Cart"
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.titleStyle}
                    onBackPress={onBackPress}
                />
                <Container >
                    <TestDetails data={cartItems} title='Test Details' onPressDelete={deleteCartItem} />
                    <OfferAndPromotion
                        onPressApplyCoupan={onPressApplyCoupan}
                        coupanTitle={coupan}
                    />
                    <Billing data={billing} />
                </Container>
                <BottomAdddressLocationButton
                    location="Thite Nagar,Kharadi,Pune"
                    buttonTitle={buttonTitle}
                    onPressAddAddress={onPressAddAddress}
                    onPressButtonTitle={handleSelectPatient}
                    buttonColor={backColor}
                />
            </ScrollView>
            <Modal transparent={true} animationType='slide' visible={isClicked} backdropOpacity={0.7} >
                <CoupanModal
                    coupanTitle={selecetedCoupan}
                    handleModal={handleModal}
                />
            </Modal>
            <CommonBottomSheetModal snapPoints={['70%']} ref={bottomSheetModalRef} >
                <SelectPatientBottomSheet
                    data={PatientOptions}
                    onPressAddNew={addNewPressHandler}
                    onPressPatient={onPressPatient}
                />
            </CommonBottomSheetModal>

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
        marginHorizontal: Matrics.s(20),
        marginTop: Matrics.s(20),
        marginBottom: Matrics.s(10)
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20)
    },
    heading: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: Matrics.s(10)
    },
    offerContainer: {
        marginVertical: Matrics.s(10),
        padding: Matrics.s(12),
        backgroundColor: colors.white,
        borderRadius: Matrics.s(12),
        elevation: 0.3,
        minHeight: Matrics.vs(52),
        width: '100%',
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center',
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    applyCoupanText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(10)
    },

})