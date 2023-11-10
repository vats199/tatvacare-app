import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import StepIndicator from 'react-native-step-indicator';

const customStyles = {
    stepIndicatorSize: 10,
    currentStepIndicatorSize: 10,
    separatorStrokeWidth: 3,
    currentStepStrokeWidth: 3,
    stepStrokeCurrentColor: 'green',
    stepStrokeWidth: 0.3,
    stepStrokeFinishedColor: "green",
    stepStrokeUnFinishedColor: "#E0E0E0",
    separatorFinishedColor: "green",
    separatorUnFinishedColor: "#E0E0E0",
    stepIndicatorFinishedColor: "green",
    stepIndicatorUnFinishedColor: "#ffffff",
    stepIndicatorCurrentColor: "green",
    stepIndicatorLabelFontSize: 0,
    currentStepIndicatorLabelFontSize: 0,
    stepIndicatorLabelCurrentColor: colors.darkGray,
    stepIndicatorLabelFinishedColor: colors.darkGray,
    stepIndicatorLabelUnFinishedColor: colors.darkGray,
    labelSize: 11,
    currentStepLabelColor: colors.black,

};

type TestSummaryProps = {
    showMore?: boolean;
    labels?: string[];
    stepCount?: number;
    AppointmentOn?: string;
    Time?: string
}

const TestSummary: React.FC<TestSummaryProps> = ({ showMore, labels, stepCount, AppointmentOn, Time }) => {

    const [showDetail, setShowDetail] = useState<boolean>(false);
    return (
        <View>
            <Text style={[styles.summaryText, {
                marginVertical: Matrics.s(15)
            }]}>Summary</Text>
            <View style={[styles.summaryBox, styles.containerShadow]}>
                <View style={{ padding: 15 }}>
                    <Text style={[styles.summaryText, { fontSize: Matrics.s(14) }, { marginBottom: Matrics.s(8) }]}>User Name</Text>
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
                                    <Text style={styles.valueStyle}>VL 39670</Text>
                                </View>
                                {
                                    (AppointmentOn && Time) && (
                                        <View>
                                            <View style={styles.row}>
                                                <Text style={styles.textStyle}>Appointment On:</Text>
                                                <Text style={styles.valueStyle}>{AppointmentOn}</Text>
                                            </View>
                                            <View style={styles.row}>
                                                <Text style={styles.textStyle}>Time:</Text>
                                                <Text style={styles.valueStyle}>{Time} </Text>
                                            </View>
                                        </View>
                                    )
                                }
                                <View style={styles.separator} />
                                <View style={{ flexDirection: 'row', justifyContent: "space-between" }}>
                                    <View style={styles.row}>
                                        <Text style={styles.textStyle}>Status:</Text>
                                        <Text style={styles.valueStyle}>Phlebo Assignsed</Text>
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
                                    <View style={{ minHeight: Matrics.s(216), padding: Matrics.s(10) }}>
                                        <StepIndicator
                                            customStyles={customStyles}
                                            currentPosition={1}
                                            labels={labels}
                                            stepCount={stepCount}
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
        lineHeight: Matrics.s(20)
    },
    summaryBox: {
        flex: 1,
        borderRadius: Matrics.s(12),
        backgroundColor: colors.white,
    },
    containerShadow: {
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.08,
        shadowRadius: Matrics.s(8),
        elevation: 0.4,
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: Matrics.s(2)
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
        lineHeight: Matrics.s(18),
    },
    valueStyle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(18),
    },
    viewText: {
        fontSize: Matrics.s(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    }
})