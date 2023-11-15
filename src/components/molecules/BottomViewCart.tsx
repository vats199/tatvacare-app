import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Matrics } from '../../constants';

type BottomViewCartProps = {
    selectedNumber?: number;
    price?: number;
    onPressViewCart?: () => void;
}

const BottomViewCart: React.FC<BottomViewCartProps> = ({ selectedNumber, price, onPressViewCart }) => {
    const rupee = '\u20B9';
    return (
        <View style={styles.cartContainer}>
            <View>
                <Text style={styles.itemText}>{selectedNumber} item in cart</Text>
                <Text style={styles.price}>{rupee} {price} </Text>
            </View>
            <TouchableOpacity
                style={styles.viewCartButton}
                onPress={onPressViewCart}
            >
                <Text style={styles.viewCartText}>View cart</Text>
            </TouchableOpacity>
        </View>
    )
}

export default BottomViewCart

const styles = StyleSheet.create({
    cartContainer: {
        minHeight: 70,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 20,
        paddingVertical: 5,
        backgroundColor: colors.white,
        elevation: 7,
        shadowColor: '#313131',
        shadowOffset: { width: 0, height: 1 },

    },
    viewCartButton: {
        paddingHorizontal: 16,
        paddingVertical: 12,
        backgroundColor: colors.themePurple,
        borderRadius: 16,
    },
    viewCartText: {
        fontFamily: Fonts.BOLD,
        fontWeight: '700',
        fontSize: 16,
        color: colors.white,
    },
    price: {
        fontSize: Matrics.mvs(16),
        fontFamily: Fonts.BOLD,
        fontWeight: '700',
        lineHeight: 22,
        color: colors.inputValueDarkGray
    },
    itemText: {
        fontSize: Matrics.mvs(12),
        fontFamily: Fonts.BOLD,
        fontWeight: '400',
        lineHeight: 14,
        color: colors.darkGray
    }
})