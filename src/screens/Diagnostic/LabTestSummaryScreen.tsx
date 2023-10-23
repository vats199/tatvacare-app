import { StyleSheet, Text, View, ScrollView } from 'react-native'
import React from 'react';
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

type LabTestScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'TestDetail'
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


const LabTestSummaryScreen: React.FC<LabTestScreenProps> = ({ route, navigation }) => {

    const data: TestItem[] = route.params?.data;
    console.log(data);
    const onPressBack = () => {
        navigation.goBack();
    }

    return (
        <SafeAreaView edges={['top']} style={styles.screen} >
            <ScrollView style={{ padding: 20 }}>
                <Header
                    title='Lab Test Summary'
                    isIcon={false}
                    titleStyle={styles.titleStyle}
                    containerStyle={styles.upperHeader}
                    onBackPress={onPressBack}
                />
                <TestSummary />
                <SampleCollection />
                <TestDetails data={data} title="Test" />
                <View style={{ marginBottom: 50 }}>
                    <Billing />
                </View>
            </ScrollView>
            <View style={styles.bottomContainer}>
                <Button
                    title="Proceed To Payment"
                    titleStyle={styles.buttonTextStyle}
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
        borderRadius: 12
    },
    buttonTextStyle: {
        fontSize: Matrics.s(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
    }
})