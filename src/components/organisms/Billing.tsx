import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { billingData } from '../../screens/DevicePurchase/CartScreen';
type BillingProps = {
    data: billingData[]
}

const Billing: React.FC<BillingProps> = ({ data }) => {
    const rupee = '\u20B9';

    const renderBillingItems = (item: billingData, index: number) => {
        const color = (item.value?.name === "Applied Coupan(FIRST25)") ? "green" : colors.subTitleLightGray;
        console.log(color);
        return (

            <View style={styles.row}>
                <Text style={styles.billingProperty}>{item.value?.name} </Text>
                <Text style={[styles.billingProperty, { color: color }]}>{rupee} {item.value?.price}</Text>
            </View>
        );
    }
    return (
        <View>
            <Text style={styles.heading}>Billing</Text>
            <View style={styles.billingContainer}>
                {data.map(renderBillingItems)}
                <View style={styles.border} />
                <View style={styles.row}>
                    <Text style={styles.totalAmount}> Amount to be Paid </Text>
                    <Text style={styles.totalAmount}>{rupee}210</Text>
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
        marginTop: 10
    },

    billingContainer: {
        marginVertical: 10,
        padding: 16,
        backgroundColor: colors.white,
        borderRadius: 12,
        minHeight: 212,
        width: '100%',
        elevation: 0.4
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
    },

})