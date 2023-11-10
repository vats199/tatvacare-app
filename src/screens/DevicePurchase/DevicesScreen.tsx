import { ScrollView, StyleSheet, View, Text, TouchableOpacity } from 'react-native'
import React from 'react';
import { DevicePurchaseStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Matrics } from '../../constants';
import Header from '../../components/atoms/Header';
import TestSummary from '../../components/molecules/TestSummary';
import WhatsNext from '../../components/molecules/WhatsNext';

type DevicesScreenProps = StackScreenProps<
    DevicePurchaseStackParamList,
    'DevicesScreen'
>;

const DevicesScreen: React.FC<DevicesScreenProps> = ({ route, navigation }) => {
    const insets = useSafeAreaInsets();

    const onPressContactUs = () => { }
    const onPressConnect = () => { }
    const onPressBack = () => {
        navigation.goBack();
    }
    const labels = ["Yet To Assign", "Assigned", "Device dispatched", "Device on it's way", 'Device received', 'Done'];
    return (
        <SafeAreaView
            edges={['top']}
            style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(25) : insets.bottom }]}
        >
            <MyStatusbar />
            <ScrollView style={{ padding: 15 }} showsVerticalScrollIndicator={false} >
                <Header
                    title='Devices'
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.headerTitle}
                    onBackPress={onPressBack}
                />
                <TestSummary showMore={true} labels={labels} stepCount={labels.length} />

                <View style={[styles.bottomContainer, { marginTop: Matrics.ms(20) }]}>
                    <View style={{ flexDirection: "row", alignItems: "center" }}>
                        <Icons.SmartAnalyser height={28} width={28} />
                        <Text style={styles.smartAnalyser}>Smart Analyser</Text>
                    </View>
                    <TouchableOpacity onPress={onPressConnect}>
                        <Text style={styles.contactUs}>Connect </Text>
                    </TouchableOpacity>
                </View>
                <WhatsNext />
                <View style={styles.bottomContainer}>
                    <Text> Need Help with something</Text>
                    <TouchableOpacity onPress={onPressContactUs}>
                        <Text style={styles.contactUs}>Contact Us </Text>
                    </TouchableOpacity>
                </View>
            </ScrollView>
        </SafeAreaView>
    )
}

export default DevicesScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginVertical: Matrics.vs(15)
    },
    headerTitle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.vs(22),
        marginLeft: Matrics.s(15),
    },
    needHelpText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        lineHeight: Matrics.ms(18)
    },
    bottomContainer: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: 'space-between',
        paddingHorizontal: Matrics.s(15),
        paddingVertical: Matrics.s(15),
        backgroundColor: colors.white,
        borderRadius: Matrics.s(12),
        elevation: 0.8,
        marginVertical: Matrics.vs(10)
    },
    contactUs: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        lineHeight: Matrics.ms(18),
    },
    smartAnalyser: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.ms(18),
        marginLeft: Matrics.s(15)
    }
})