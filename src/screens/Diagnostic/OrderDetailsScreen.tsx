import { StyleSheet, View, ScrollView } from 'react-native'
import React, { useState, useEffect } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { SafeAreaView } from 'react-native-safe-area-context';
import Header from '../../components/atoms/Header';
import TestSummary from '../../components/molecules/TestSummary';
import TestDetails from '../../components/organisms/TestDetails';
import Billing from '../../components/organisms/Billing';
import AsyncStorage from '@react-native-async-storage/async-storage';
import MyStatusbar from '../../components/atoms/MyStatusBar';


type OrderDetailsScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'OrderDetails'
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

export type billingData = {
    id?: number;
    value?: {
        name?: string;
        price?: string;
    }
}


const OrderDetailsScreen: React.FC<OrderDetailsScreenProps> = ({ route, navigation }) => {

    const [cartItems, setCartItems] = useState<TestItem[]>([]);
    const labels = ["Test Booked", "  Phlebo Assigned", "Sample Picked", "Report Generated"];

    const onBackPress = () => {
        navigation.goBack();
    }

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
        <SafeAreaView edges={['top']} style={styles.screen} >
            <MyStatusbar />
            <ScrollView style={{ padding: Matrics.s(16) }} showsVerticalScrollIndicator={false}>
                <Header
                    title='Order Details'
                    isIcon={false}
                    titleStyle={styles.titleStyle}
                    containerStyle={styles.upperHeader}
                    onBackPress={onBackPress}

                />
                <TestSummary showMore={true} labels={labels} stepCount={labels.length} AppointmentOn='VL 39670' Time="09:30-10:30" />

                <TestDetails data={cartItems} title="Test" />
                <View style={{ marginBottom: Matrics.s(50) }}>
                    <Billing data={billingOptions} />
                </View>
            </ScrollView>
        </SafeAreaView>
    )
}

export default OrderDetailsScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue
    },
    upperHeader: {
        marginVertical: Matrics.s(10)
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20)
    },
})