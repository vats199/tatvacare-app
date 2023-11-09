import { StyleSheet, Text, View, ScrollView } from 'react-native'
import React, { useRef, useState, useEffect } from 'react';
import { LabTestRefundStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Icons } from '../../constants/icons';
import AsyncStorage from '@react-native-async-storage/async-storage';
import TestSummary from '../../components/molecules/TestSummary';
import Billing from '../../components/organisms/Billing';
import TestDetails from '../../components/organisms/TestDetails';

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

type OrderDetailsScreenProps = StackScreenProps<
    LabTestRefundStackParamList,
    'OrderDetails'
>;

const DetailsOrderScreen: React.FC<OrderDetailsScreenProps> = ({ route, navigation }) => {
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
            <MyStatusbar />
            <ScrollView style={{ padding: 20 }}>
                <View style={styles.header}>
                    <Icons.Close height={24} width={24} onPress={onBackPress} />
                    <Text style={styles.titleStyle}>Order Details</Text>
                </View>
                <TestSummary showMore={true} />

                <TestDetails data={cartItems} title="Test" />
                <View style={{ marginBottom: 50 }}>
                    <Billing data={billingOptions} />
                </View>
            </ScrollView>
        </SafeAreaView>
    )
}

export default DetailsOrderScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue
    },
    header: {
        marginVertical: Matrics.s(15),
        flexDirection: 'row',
        alignItems: "center"
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(15),
        lineHeight: Matrics.s(20)
    },
})