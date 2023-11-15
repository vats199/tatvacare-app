import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';
import Button from '../atoms/Button';

type CoupanModalProps = {
    coupanTitle?: string;
    handleModal: () => void;
}

const CoupanModal: React.FC<CoupanModalProps> = ({
    coupanTitle,
    handleModal
}) => {
    return (
        <View style={styles.modalContainer}>
            <View style={styles.modal}>
                <View style={{ padding: 10 }}>
                    <View style={{ marginTop: 20, justifyContent: 'center', alignItems: 'center' }}>
                        <Icons.Success height={30} width={30} />
                    </View>
                    <View style={{ marginTop: 20, justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={styles.orderAppliedText}>{coupanTitle} Applied</Text>
                        <Text style={styles.discountText}>you got 20 % off on your order</Text>
                        <TouchableOpacity onPress={handleModal}>
                            <Text style={styles.gotItText}>Got it, Thanks</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </View>
        </View>
    )
}

export default CoupanModal

const styles = StyleSheet.create({
    modalContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0, 0, 0, 0.8)',
        width: '100%'
    },
    modal: {
        width: 288,
        height: 174,
        borderRadius: 14,
        backgroundColor: 'white',
    },
    orderAppliedText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    discountText: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    gotItText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        marginTop: 10
    },
})