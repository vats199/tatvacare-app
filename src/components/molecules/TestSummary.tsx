import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';


type TestSummaryProps = {
    showMore?: boolean;
}

const TestSummary: React.FC<TestSummaryProps> = ({ showMore }) => {
    return (
        <View>
            <Text style={[styles.summaryText, {
                marginTop: 15,
                marginBottom: 10
            }]}>Summary</Text>
            <View style={[styles.summaryBox, styles.containerShadow]}>
                <View style={{ padding: 15 }}>
                    <Text style={[styles.summaryText, { fontSize: Matrics.s(14) }]}>User Name</Text>
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
                            <View style={{ padding: 15 }}>
                                <View style={styles.row}>
                                    <Text style={[{ marginLeft: 10 }, styles.textStyle]}>Order ID:</Text>
                                    <Text style={[{ marginLeft: 10 }, styles.textStyle]}>VL 39670</Text>
                                </View>
                                <View style={styles.row}>
                                    <Text style={[{ marginLeft: 10 }, styles.textStyle]}>Appointment On:</Text>
                                    <Text style={[{ marginLeft: 10 }, styles.textStyle]}>VL 39670</Text>
                                </View>
                                <View style={styles.row}>
                                    <Text style={[{ marginLeft: 10 }, styles.textStyle]}>Time:</Text>
                                    <Text style={[{ marginLeft: 10 }, styles.textStyle]}>VL 39670</Text>
                                </View>
                                <View style={styles.separator} />
                                <View style={{ flexDirection: 'row', justifyContent: "space-between" }}>
                                    <View style={styles.row}>
                                        <Text style={[{ marginLeft: 10 }, styles.textStyle]}>Status:</Text>
                                        <Text style={[{ marginLeft: 10 }, styles.textStyle]}>Phlebo Assignsed</Text>
                                    </View>
                                    <TouchableOpacity style={styles.row}>
                                        <Text>View</Text>
                                        <Icons.upArrow />
                                    </TouchableOpacity>
                                </View>
                            </View>
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
    }
})