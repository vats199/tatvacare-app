import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../atoms/Button';

type BottomAddressLocationButtonProps = {
    location?: string;
    onPressAddAddress?: () => void;
    onPressButtonTitle?: () => void;
    buttonTitle: string;
    buttonColor?: string;
}

const BottomAdddressLocationButton: React.FC<BottomAddressLocationButtonProps> = ({ location, onPressAddAddress, onPressButtonTitle, buttonTitle, buttonColor }) => {

    return (
        <View style={styles.bootomContainer}>
            <View style={[styles.row, { marginVertical: 5 }]}>
                <View style={styles.row}>
                    <Icons.Gps height={24} width={24} />
                    <Text style={styles.locationText}>{location}</Text>
                </View>
                <TouchableOpacity onPress={onPressAddAddress} >
                    <Text style={styles.textAddButton}>Add address</Text>
                </TouchableOpacity>
            </View>
            <View style={styles.border} />
            <Button
                title={buttonTitle}
                onPress={onPressButtonTitle}
                buttonStyle={{ marginHorizontal: 0, backgroundColor: buttonColor, minHeight: 40 }}
                titleStyle={styles.buttonTitleStyle}
            />
        </View>
    )
}

export default BottomAdddressLocationButton

const styles = StyleSheet.create({
    bootomContainer: {
        marginTop: 10,
        padding: 12,
        backgroundColor: colors.white,
        borderTopLeftRadius: 20,
        borderTopRightRadius: 20,
        minHeight: 104,
        width: '100%',
        elevation: 0.3,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
        marginBottom: 50
    },
    textAddButton: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
    row: {
        flexDirection: "row",
        justifyContent: "space-between",
        alignItems: "center"
    },
    locationText: {
        marginLeft: Matrics.s(7),
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: "#D3D3D3",
        marginVertical: Matrics.s(6)
    },
    buttonTitleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
        lineHeight: Matrics.mvs(20),
        textAlign: "center"
    }
})