import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';

const Billing: React.FC = () => {


    return (
        <View>
            <Text style={styles.heading}>Billing</Text>
            <View style={styles.billingContainer}>
                <View style={styles.row}>
                    <Text style={styles.billingProperty}> Item Total</Text>
                    <Text style={styles.billingProperty}> 2250</Text>
                </View>
                <View style={styles.row}>
                    <Text style={styles.billingProperty}> Home Collection charge</Text>
                    <Text style={styles.billingProperty}> 50</Text>
                </View>
                <View style={styles.row}>
                    <Text style={styles.billingProperty}> Service charge</Text>
                    <Text style={styles.billingProperty}> 10</Text>
                </View>
                <View style={styles.row}>
                    <Text style={styles.billingProperty}> Discount of item(s)</Text>
                    <Text style={styles.billingProperty}> -25</Text>
                </View>
                <View style={styles.row}>
                    <Text style={styles.billingProperty}> Applied Coupan(FIRST25) </Text>
                    <Text style={styles.billingProperty}>-25</Text>
                </View>
                <View style={styles.border} />
                <View style={styles.row}>
                    <Text style={styles.totalAmount}> Amount to be Paid </Text>
                    <Text style={styles.totalAmount}>210</Text>
                </View>
            </View>
        </View>
    )
}

export default Billing;

const styles = StyleSheet.create({
    heading: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },

    billingContainer: {
        marginVertical: 10,
        padding: 16,
        backgroundColor: colors.white,
        borderRadius: 12,
        minHeight: 212,
        width: '100%',
    },
    row: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
        marginVertical: 4
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: "#D3D3D3",
        marginVertical: 10
    },
    billingProperty: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    totalAmount: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    }
})