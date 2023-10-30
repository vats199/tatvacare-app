import { ScrollView, StyleSheet, View } from 'react-native'
import React from 'react';
import { DevicePurchaseStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Matrics } from '../../constants';
import Header from '../../components/atoms/Header';
import TestSummary from '../../components/molecules/TestSummary';
import OfferAndPromotion from '../../components/molecules/OfferAndPromotion';
import Billing from '../../components/organisms/Billing';
import BottomAdddressLocationButton from '../../components/molecules/BottomAdddressLocationButton';
import CartItems from '../../components/organisms/CartItems';
import { useApp } from '../../context/app.context';


type OrderSummaryScreenProps = StackScreenProps<
    DevicePurchaseStackParamList,
    'OrderSummary'
>;
export type billingData = {
    id?: number;
    value?: {
        name?: string;
        price?: string;
    }
}

const OrderSummaryScreen: React.FC<OrderSummaryScreenProps> = ({ route, navigation }) => {

    const insets = useSafeAreaInsets();
    const { coupan } = useApp();
    const onPressProceedToCheckout = () => {
        navigation.navigate("PaymentDone");
    }
    const onPressBack = () => {
        navigation.goBack();
    }

    const billingOptions: billingData[] = [
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
                name: "Sub Total",
                price: "200"
            }
        },
        {
            id: 3,
            value: {
                name: "Home Collection Charges",
                price: "50"
            }
        },
        {
            id: 4,
            value: {
                name: "Service Charge",
                price: "10"
            }
        },

    ]

    return (
        <SafeAreaView
            edges={['top']}
            style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]}
        >
            <MyStatusbar />
            <View style={styles.headerContainer}>
                <Header
                    title='Order Summary'
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.headerTitle}
                    onBackPress={onPressBack}
                    icon={false}
                />
            </View>
            <ScrollView style={styles.scrollviewContainer} showsVerticalScrollIndicator={false}>
                <TestSummary />
                <CartItems showAddMinus={false} />
                <OfferAndPromotion coupanTitle={coupan} />
                <Billing data={billingOptions} />
            </ScrollView>
            <BottomAdddressLocationButton
                buttonTitle='Proceed to Payment'
                location='Thite Nagar,Kharadi,Pune'
                buttonColor={colors.themePurple}
                onPressButtonTitle={onPressProceedToCheckout}
            />
        </SafeAreaView>
    )
}

export default OrderSummaryScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    headerContainer: {
        paddingVertical: 5,
        borderBottomWidth: 0.1,
        borderBottomColor: '#ccc',
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.08,
        shadowRadius: 8,
        elevation: 2,
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
    scrollviewContainer: {
        flex: 1,
        paddingHorizontal: Matrics.s(15),
        paddingVertical: Matrics.vs(10)
    }
})