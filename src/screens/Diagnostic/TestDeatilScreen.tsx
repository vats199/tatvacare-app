import { ScrollView, StyleSheet, Text, View } from 'react-native'
import React from 'react'
import {
    DiagnosticStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';
import TestIncluded from '../../components/molecules/TestIncluded';

type TestDetailScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'TestDetail'
>;


const TestDetailScreen: React.FC<TestDetailScreenProps> = ({ route, navigation }) => {

    const rupee = '\u20B9';
    const onPressBack = () => {
        navigation.goBack();
    }
    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <ScrollView style={{ padding: 20, flex: 1 }}>
                <Header
                    isIcon={true}
                    icon={<Icons.Cart height={24} width={24} />}
                    containerStyle={styles.upperHeader}
                    onBackPress={onPressBack}
                />
                <View style={styles.testDetailBox}>
                    <Text style={styles.title}> Fitgon</Text>
                    <Text style={[styles.description, { marginVertical: 5 }]}>The AP view examines the lungs, bony thoracic cavity, mediastinum, and great vessels. This particular projection is often used frequently to aid diagnosis of acute and chronic conditions in intensive care units and wards.</Text>
                    <View style={styles.row}>
                        <Text style={styles.description}>Sample Required:</Text>
                        <Text style={[styles.description, { color: colors.inputValueDarkGray }]}>Text Will Go Here</Text>
                    </View>
                    <View style={styles.row}>
                        <Text style={styles.description}>Preparations:</Text>
                        <Text style={[styles.description, { color: colors.inputValueDarkGray }]}>Text Will Go Here</Text>
                    </View>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{rupee}1078</Text>
                        <Text style={{ textDecorationLine: 'line-through' }}>{rupee} 2695</Text>
                        <Text style={styles.discount}> 40% off</Text>
                    </View>
                    <Button title="Add" buttonStyle={styles.buttonStyle} titleStyle={styles.buttonTitleStyle} />
                </View>

                <View>
                    <Text style={[styles.title, { marginTop: 10 }]}>Test Included</Text>
                    <TestIncluded />
                </View>

            </ScrollView>
        </SafeAreaView>
    )
}

export default TestDetailScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,

    },
    upperHeader: {
        // marginHorizontal: 20,
        marginTop: 10,
        marginBottom: 10
    },
    testDetailBox: {
        padding: 15,
        backgroundColor: colors.white,
        marginVertical: 15,
        minHeight: 272,
        borderRadius: 12,
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 }
    },
    title: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: 5
    },
    description: {
        fontSize: 12,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: 5
    },
    priceRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: 10
    },
    price: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginRight: 10
    },
    oldPrice: {
        fontSize: 12,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    discount: {
        fontSize: 14,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.green,
        marginLeft: 10
    },
    buttonStyle: {
        backgroundColor: 'white',
        borderWidth: 1,
        borderColor: colors.themePurple,
        marginHorizontal: 0,
        height: 36,
        marginVertical: 5
    },
    buttonTitleStyle: {
        color: colors.themePurple,
        fontSize: 12,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
    }
})