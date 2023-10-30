import { StyleSheet, Text, View } from 'react-native'
import React, { useRef } from 'react';
import { DevicePurchaseStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import CartItems from '../../components/organisms/CartItems';
import { ScrollView } from 'react-native-gesture-handler';
import OfferAndPromotion from '../../components/molecules/OfferAndPromotion';
import Billing from '../../components/organisms/Billing';
import BottomAdddressLocationButton from '../../components/molecules/BottomAdddressLocationButton';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Matrics } from '../../constants';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import SelectAddressBottomSheet from '../../components/organisms/SelectAddressBottomSheet';

type CartScreenProps = StackScreenProps<
    DevicePurchaseStackParamList,
    'CartScreen'
>;

export type billingData = {
    id?: number;
    value?: {
        name?: string;
        price?: string;
    }
}
export type addressData = {
    id: number;
    address?: string;
}

const CartScreen: React.FC<CartScreenProps> = ({ route, navigation }) => {

    const insets = useSafeAreaInsets();
    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressAddNewAddress = () => {
        bottomSheetModalRef.current?.present();
    }
    const onPressAddAddress = () => {
        // bottomSheetModalRef.current?.close();
        console.log("happeniong");
        navigation.navigate("ConfirmLocationScreen");
    }
    const onPressProceedToCheckout = () => {

    }
    const onPressApplyCoupan = () => {
        // navigation.navigate("ApplyCoupan");
    }

    const billingOptions: billingData[] = [
        {
            id: 1,
            value: {
                name: "Total Amount",
                price: "2,276"
            }
        },
        {
            id: 2,
            value: {
                name: "Sub Total",
                price: "2,276"
            }
        },
        {
            id: 3,
            value: {
                name: "Home Collection Charges",
                price: "2,276"
            }
        },
        {
            id: 4,
            value: {
                name: "Service Charge",
                price: "2,276"
            }
        },
        {
            id: 5,
            value: {
                name: "Discount",
                price: "-"
            }
        },
    ]

    const addressOptions: addressData[] = [
        {
            id: 1,
            address: "Zydus cadila, Hari Om Nagar, Chandralok Society, Ghodasar, Ahmedabad, Gujarat 380050"
        },
        {
            id: 2,
            address: "Zydus cadila, Hari Om Nagar, Chandralok Society, Ghodasar, Ahmedabad, Gujarat 380050"
        }
    ]
    const snapPoints = (addressOptions.length > 0) ? ['48%'] : ['40%']

    return (
        <>
            <MyStatusbar />
            <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]}>
                <View style={{
                    paddingVertical: 5,
                    borderBottomWidth: 0.1,
                    borderBottomColor: '#ccc',
                    shadowColor: colors.black,
                    shadowOffset: { width: 0, height: 3 },
                    shadowOpacity: 0.08,
                    shadowRadius: 8,
                    elevation: 0.5,
                }}>
                    <Header
                        title='Cart'
                        containerStyle={styles.upperHeader}
                        titleStyle={styles.headerTitle}
                        onBackPress={onPressBack}
                    />
                </View>
                <ScrollView >
                    <View style={{ paddingHorizontal: 12 }}>
                        <CartItems />
                        <OfferAndPromotion />
                        <Billing data={billingOptions} />
                    </View>
                    <BottomAdddressLocationButton
                        buttonTitle='Proceed to Payment'
                        location='Thite Nagar,Kharadi,Pune'
                        buttonColor={colors.darkGray}
                        onPressAddAddress={onPressAddNewAddress}
                        onPressButtonTitle={onPressProceedToCheckout}
                    />
                </ScrollView>
                <CommonBottomSheetModal snapPoints={snapPoints} ref={bottomSheetModalRef} >
                    <SelectAddressBottomSheet
                        data={addressOptions}
                        onPressAddAddress={onPressAddAddress}
                        onPressAddNew={onPressAddAddress}
                    />
                </CommonBottomSheetModal>
            </SafeAreaView>
        </>
    )
}


export default CartScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginTop: Matrics.s(25),
        marginBottom: 10,
        marginLeft: 20
    },
    headerTitle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
    },
})