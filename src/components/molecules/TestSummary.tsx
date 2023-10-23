import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';

const TestSummary = () => {
    return (
        <View>
            <Text style={[styles.summaryText, {
                marginTop: 15,
                marginBottom: 10
            }]}>Summary</Text>
            <View style={[styles.summaryBox, styles.containerShadow]}>
                <Text style={[styles.summaryText, { fontSize: Matrics.s(14) }]}>User Name</Text>
                <View style={styles.row}>
                    <Icons.Person height={20} width={20} />
                    <Text style={{ marginLeft: 10 }}> Address</Text>
                </View>
                <View style={styles.row}>
                    <Icons.Mail height={20} width={20} />
                    <Text style={{ marginLeft: 10 }}>abc@gmail.com</Text>
                </View>
                <View style={styles.row}>
                    <Icons.Call height={20} width={20} />
                    <Text style={{ marginLeft: 10 }}>+91-9800000000</Text>
                </View>
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
        padding: Matrics.s(10),
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
        marginVertical: 5
    }
})