import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';
import { addressItem } from '../../screens/Diagnostic/ConfirmLocationScreen';

type BottomSheetSelectAddressProps = {
    data?: addressItem[];
    onPressAddNew: () => void;
    onPressAdddressItem?: () => void;
}


const BottomSheetSelectAddress: React.FC<BottomSheetSelectAddressProps> = ({ data, onPressAddNew, onPressAdddressItem }) => {

    const renderAddressItem = (item: addressItem, idex: number) => {
        return (
            <TouchableOpacity style={styles.addressItemContainer}
                onPress={onPressAdddressItem}
            >
                <View style={{ flexDirection: "row", width: "70%" }}>
                    <View style={{ marginRight: 5 }}>
                        {
                            (item.title === "Home") ? (
                                <Icons.Home width={28} height={28} />
                            ) : <Icons.Person width={28} height={28} />
                        }
                    </View>
                    <View >
                        <Text style={styles.addressTitleText}>{item.title}</Text>
                        <Text style={styles.addressDescription}>{item.description}</Text>
                    </View>
                </View>
                <View style={{ alignItems: "flex-end" }}>
                    <Icons.ThreeDot width={16} height={16} />
                </View>
            </TouchableOpacity>
        );
    }
    return (
        <View style={styles.contentContainer} >
            <View >
                <View style={styles.upperRow}>
                    <Text style={styles.selectAddressTitle}> Select Address</Text>
                    <TouchableOpacity style={styles.upperSubRow} onPress={onPressAddNew}  >
                        <Icons.AddCircle height={13} width={13} />
                        <Text style={styles.addNewText}> Add New</Text>
                    </TouchableOpacity>
                </View>
                <View style={styles.border} />
            </View>
            <View style={styles.belowContainer}>
                {data?.map(renderAddressItem)}
            </View>
        </View>
    )
}

export default BottomSheetSelectAddress

const styles = StyleSheet.create({
    contentContainer: {
        flex: 1,
    },
    upperRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
        marginBottom: Matrics.s(20),
    },
    upperSubRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
    },
    addNewText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        marginRight: 10
    },
    selectAddressTitle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 10
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: "#E9E9E9",
    },
    belowContainer: {
        flex: 1,
        paddingVertical: 10,
        paddingHorizontal: 15,
        backgroundColor: "#f9f9f9"
    },
    addressItemContainer: {
        flexDirection: "row",
        justifyContent: "space-between",
        padding: 10,
        backgroundColor: colors.white,
        borderRadius: 10,
        marginVertical: 10,
        elevation: 0.1
    },
    addressTitleText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    addressDescription: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    }
})