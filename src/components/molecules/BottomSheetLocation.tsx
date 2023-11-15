import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';
import Button from '../atoms/Button';

type BottomSheetLocationProps = {
    onPressAddCompleteAddress: () => void;
    locationTitle?: string;
    locationDescription?: string;
}

const BottomSheetLocation: React.FC<BottomSheetLocationProps> = ({ onPressAddCompleteAddress, locationTitle, locationDescription }) => {
    return (
        <View style={{ flex: 1, padding: 15 }}>
            <View style={{ flexDirection: "row", justifyContent: "flex-start" }}>
                <Icons.LocationActive height={24} width={24} style={{ marginTop: 5 }} />
                <View style={{ marginLeft: 15 }}>
                    <Text style={styles.locationTitle}>{locationTitle}</Text>
                    <Text style={styles.locationDescription}>{locationDescription}</Text>
                </View>
            </View>
            <View style={{ marginTop: 20 }}>
                <Button
                    title="Add Complete Adddress"
                    titleStyle={styles.outlinedButtonText}
                    buttonStyle={styles.outlinedButton}
                    onPress={onPressAddCompleteAddress}
                />
            </View>
        </View>
    )
}

export default BottomSheetLocation

const styles = StyleSheet.create({
    locationTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    locationDescription: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginTop: 5
    },
    outlinedButtonText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
    },
    outlinedButton: {
        padding: 10,
        height: 40,
        borderRadius: 16,
        backgroundColor: colors.themePurple,
        marginHorizontal: 0
    },
})