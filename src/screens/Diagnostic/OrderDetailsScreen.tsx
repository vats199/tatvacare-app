import { StyleSheet, Text, View, ScrollView } from 'react-native'
import React, { useState, useEffect } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';
import Header from '../../components/atoms/Header';
import TestSummary from '../../components/molecules/TestSummary';
import TestDetails from '../../components/organisms/TestDetails';
import Billing from '../../components/organisms/Billing';
import AsyncStorage from '@react-native-async-storage/async-storage';
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
            <ScrollView style={{ padding: 20 }}>
                <Header
                    title='Order Details'
                    isIcon={false}
                    titleStyle={styles.titleStyle}
                    containerStyle={styles.upperHeader}
                    onBackPress={onBackPress}

                />
                <TestSummary showMore={true} />

                <TestDetails data={cartItems} title="Test" />
                <View style={{ marginBottom: 50 }}>
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
        marginVertical: 10
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
})