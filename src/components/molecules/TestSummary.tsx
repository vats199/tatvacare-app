import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import StepIndicator from 'react-native-step-indicator';

const labels = ["Test Booked", "Phlebo Assigned", "Sample Picked", "Report Generated"];

const customStyles = {
    stepIndicatorSize: 20,
    currentStepIndicatorSize: 20,
    stepStrokeCurrentColor: 'green',
    stepStrokeWidth: 0.3
    ,
    stepStrokeFinishedColor: "green",
    stepStrokeUnFinishedColor: "#808080",
    separatorFinishedColor: "green",
    separatorUnFinishedColor: "#808080",
    stepIndicatorFinishedColor: "green",
    stepIndicatorUnFinishedColor: "#808080",
    stepIndicatorCurrentColor: "green",
    stepIndicatorLabelFontSize: 0,
    currentStepIndicatorLabelFontSize: 5,
    stepIndicatorLabelCurrentColor: "green",
    stepIndicatorLabelFinishedColor: "green",
    stepIndicatorLabelUnFinishedColor: "#808080",
    labelSize: 11,
    currentStepLabelColor: "green",
};


type TestSummaryProps = {
    showMore?: boolean;

}

const TestSummary: React.FC<TestSummaryProps> = ({ showMore }) => {

    const [showDetail, setShowDetail] = useState<boolean>(false);
    return (
        <View>
            <Text style={[styles.summaryText, {
                marginTop: 15,
                marginBottom: 10
            }]}>Summary</Text>
            <View style={[styles.summaryBox, styles.containerShadow]}>
                <View style={{ padding: 15 }}>
                    <Text style={[styles.summaryText, { fontSize: Matrics.s(14) }, { marginVertical: 8 }]}>User Name</Text>
                    <View style={styles.row}>
                        <Icons.Person height={20} width={20} />
                        <Text style={[{ marginLeft: 10 }, styles.textStyle]}> Address</Text>
                    </View>
                    <View style={styles.row}>
                        <Icons.Mail height={20} width={20} />
                        <Text style={[{ marginLeft: 10 }, styles.textStyle]}>abc@gmail.com</Text>
                    </View>
                    <View style={styles.row}>
                        <Icons.Call height={20} width={20} />
                        <Text style={[{ marginLeft: 10 }, styles.textStyle]}>+91-9800000000</Text>
                    </View>
                </View>
                {
                    showMore && (
                        <View >
                            <View style={styles.separator} />
                            <View style={{ paddingHorizontal: 15, paddingVertical: 8 }}>
                                <View style={styles.row}>
                                    <Text style={styles.textStyle}>Order ID:</Text>
                                    <Text style={[styles.textStyle, { color: colors.labelDarkGray }, { fontWeight: '700' }]}>VL 39670</Text>
                                </View>
                                <View style={styles.row}>
                                    <Text style={styles.textStyle}>Appointment On:</Text>
                                    <Text style={[styles.textStyle, { color: colors.labelDarkGray }, { fontWeight: '700' }]}>VL 39670</Text>
                                </View>
                                <View style={styles.row}>
                                    <Text style={styles.textStyle}>Time:</Text>
                                    <Text style={[styles.textStyle, { color: colors.labelDarkGray }, { fontWeight: '700' }]}>09:30-10:30</Text>
                                </View>
                                <View style={styles.separator} />
                                <View style={{ flexDirection: 'row', justifyContent: "space-between" }}>
                                    <View style={styles.row}>
                                        <Text style={styles.textStyle}>Status:</Text>
                                        <Text style={[styles.textStyle, { color: colors.labelDarkGray }, { fontWeight: '700' }]}>Phlebo Assignsed</Text>
                                    </View>
                                    <TouchableOpacity style={styles.row} onPress={() => setShowDetail(!showDetail)} >
                                        <Text style={styles.viewText}>View</Text>
                                        {
                                            showDetail ? <Icons.upArrow height={16} width={16} /> : <Icons.dropArrow height={16} width={16} />
                                        }
                                    </TouchableOpacity>
                                </View>
                            </View>
                            {
                                showDetail && (
                                    <View style={{ minHeight: 170, padding: 10 }}>
                                        <StepIndicator
                                            customStyles={customStyles}
                                            currentPosition={1}
                                            labels={labels}
                                            stepCount={4}
                                            direction='vertical'
                                        />
                                    </View>
                                )
                            }
                        </View>
                    )
                }
            </View>
        </View>
    )
}

export default TestSummary;

const styles = StyleSheet.create({
    summaryText: {
        fontSize: Matrics.s(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,

    },
    summaryBox: {
        //padding: Matrics.s(10),
        flex: 1,
        borderRadius: 12,
        backgroundColor: colors.white,

    },
    containerShadow: {
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.08,
        shadowRadius: 8,
        elevation: 0.4,
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: 2
    },
    separator: {
        borderBottomWidth: 1,
        borderBottomColor: '#D7D7D7',
        marginVertical: 5
    },
    textStyle: {
        fontSize: Matrics.s(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    viewText: {
        fontSize: Matrics.s(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    }
})