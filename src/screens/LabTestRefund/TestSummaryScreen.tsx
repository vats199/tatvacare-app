import { StyleSheet, Text, View, ScrollView } from 'react-native'
import React, { useRef, useState, useEffect } from 'react';
import { LabTestRefundStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Icons } from '../../constants/icons';
import Header from '../../components/atoms/Header';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Billing from '../../components/organisms/Billing';
import TestDetails from '../../components/organisms/TestDetails';
import SampleCollection from '../../components/molecules/SampleCollection';
import Button from '../../components/atoms/Button';
import TestSummary from '../../components/molecules/TestSummary';

type TestSummaryScreenProps = StackScreenProps<
    LabTestRefundStackParamList,
    'TestSummaryScreen'
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

const TestSummaryScreen: React.FC<TestSummaryScreenProps> = ({ route, navigation }) => {

    const [cartItems, setCartItems] = useState<TestItem[]>([]);
    const time: selectTime | undefined = route.params?.time;
    console.log(time);
    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressReschedule = () => {
        navigation.navigate("CongratulationsScreen");
    }


    const dateObj = new Date(time?.date);

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
            <MyStatusbar />
            <ScrollView style={{ padding: 20 }} showsVerticalScrollIndicator={false}>
                <Header
                    title='Lab Test Summary'
                    isIcon={false}
                    titleStyle={styles.titleStyle}
                    containerStyle={styles.upperHeader}
                    onBackPress={onPressBack}
                />
                <TestSummary />
                <SampleCollection slot={time?.slot} timeZone={time?.timeZone} dayAndDate={formattedDate} />
                <TestDetails data={cartItems} title="Test" />
                <View style={{ marginBottom: 50 }}>
                    <Billing data={billingOptions} />
                </View>
            </ScrollView>
            <View style={styles.bottomContainer}>
                <Button
                    title="Reschedule"
                    titleStyle={styles.buttonTextStyle}
                    onPress={onPressReschedule}
                    buttonStyle={{ marginHorizontal: Matrics.s(10) }}
                />
            </View>

        </SafeAreaView>
    )
}

export default TestSummaryScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginVertical: Matrics.s(5)
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20)
    },
    bottomContainer: {
        backgroundColor: colors.white,
        paddingHorizontal: Matrics.s(10),
        paddingVertical: Matrics.vs(15),
        elevation: Matrics.s(4),
        borderRadius: Matrics.s(12),
        marginBottom: Matrics.s(20)
    },
    buttonTextStyle: {
        fontSize: Matrics.s(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
    }
})