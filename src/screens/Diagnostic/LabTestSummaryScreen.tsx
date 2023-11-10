import { StyleSheet, Text, View, ScrollView } from 'react-native'
import React, { useEffect, useState } from 'react';
import {
    DiagnosticStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';
import TestSummary from '../../components/molecules/TestSummary';
import SampleCollection from '../../components/molecules/SampleCollection';
import Billing from '../../components/organisms/Billing';
import TestDetails from '../../components/organisms/TestDetails';
import AsyncStorage from '@react-native-async-storage/async-storage';

type LabTestSummaryScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'LabTestSummary'
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
type selectTime = {
    id?: number;
    date?: any;
    slot?: string;
    timeZone?: string
};
export type billingData = {
    id?: number;
    value?: {
        name?: string;
        price?: string;
    }
}


const LabTestSummaryScreen: React.FC<LabTestSummaryScreenProps> = ({ route, navigation }) => {

    const [cartItems, setCartItems] = useState<TestItem[]>([]);
    const time: selectTime = route.params?.time;
    console.log(time);
    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressProceedPay = () => {
        navigation.navigate("CongratulationScreen");
    }


    const dateObj = new Date(time.date);

    const dateOptions: Intl.DateTimeFormatOptions = {
        weekday: 'long',
        day: 'numeric',
        month: 'short',
        year: 'numeric',
    };


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

    const formattedDate = dateObj.toLocaleDateString(undefined, dateOptions);

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

    return (
        <SafeAreaView edges={['top']} style={styles.screen} >
            <ScrollView style={{ padding: 20 }} showsVerticalScrollIndicator={false}>
                <Header
                    title='Lab Test Summary'
                    isIcon={false}
                    titleStyle={styles.titleStyle}
                    containerStyle={styles.upperHeader}
                    onBackPress={onPressBack}
                />
                <TestSummary />
                <SampleCollection slot={time.slot} timeZone={time.timeZone} dayAndDate={formattedDate} />
                <TestDetails data={cartItems} title="Test" />
                <View style={{ marginBottom: 50 }}>
                    <Billing data={billingOptions} />
                </View>
            </ScrollView>
            <View style={styles.bottomContainer}>
                <Button
                    title="Proceed To Payment"
                    titleStyle={styles.buttonTextStyle}
                    onPress={onPressProceedPay}
                    buttonStyle={{ marginHorizontal: 10 }}
                />
            </View>

        </SafeAreaView>
    )
}

export default LabTestSummaryScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        marginBottom: 20,
        justifyContent: 'space-between'
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
    bottomContainer: {
        backgroundColor: colors.white,
        paddingHorizontal: 10,
        paddingVertical: 15,
        elevation: 4,
        borderRadius: 12,
        marginBottom: 20
    },
    buttonTextStyle: {
        fontSize: Matrics.s(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
    }
})