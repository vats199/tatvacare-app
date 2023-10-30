import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';
import Button from '../atoms/Button';
import { addressData } from '../../screens/DevicePurchase/CartScreen';

type SelectAddressBottomSheetProps = {
    data: addressData[];
    onPressAddNew?: () => void;
    onPressAddAddress?: () => void;
    onPressProceedToCheckout?: () => void;
}

const SelectAddressBottomSheet: React.FC<SelectAddressBottomSheetProps> = ({
    data,
    onPressProceedToCheckout,
    onPressAddNew,
    onPressAddAddress
}) => {
    const length: number = data.length;
    const [selectedAddress, setSelectedAddress] = useState<addressData>();

    const handleSelectedAddress = (item: addressData) => {
        if (item.id === selectedAddress?.id) {
            setSelectedAddress({});
        } else {
            setSelectedAddress(item)
        }
    }

    const renderAddressItem = (item: addressData, index: number) => {
        return (
            <View>
                <View style={styles.addressItemContainer}>
                    <View style={{ width: '10%' }}>
                        <Icons.Person width={28} height={28} />
                    </View>
                    <View style={{ width: '80%' }}>
                        <Text style={styles.addressText}>{item.address}</Text>
                    </View>
                    <View style={{ width: '10%' }}>
                        {
                            (item.id === selectedAddress?.id) ?
                                <Icons.RadioCheck
                                    width={18} height={18}
                                    onPress={() => handleSelectedAddress(item)}
                                    style={{ marginTop: 10 }}
                                /> :
                                <Icons.RadioUncheck
                                    width={18} height={18}
                                    onPress={() => handleSelectedAddress(item)}
                                    style={{ marginTop: 10 }}
                                />
                        }
                    </View>

                </View>
                {
                    (item.id < data.length) && (
                        <View style={styles.separator} />
                    )
                }
            </View>
        );
    }
    return (
        <View style={styles.container}>
            {
                (length === 0) ? (
                    <View>
                        <Text
                            style={[styles.selectAddressTitle, { marginLeft: Matrics.s(15) }]}>
                            Select Address
                        </Text>
                        <View style={styles.border} />
                        <View style={styles.belowContainer}>
                            <View style={styles.noAddressContainer}>
                                <Icons.NoAddress height={36} width={36} style={styles.iconStyle} />
                                <Text>No Address Present.</Text>
                                <Text>Please add an address to continue.</Text>
                            </View>
                            <Button
                                title="Add Address"
                                buttonStyle={{ marginHorizontal: 0 }}
                                titleStyle={styles.buttonText}
                                onPress={onPressAddAddress}
                            />
                        </View>
                    </View>
                ) : (
                    <View>
                        <View style={styles.upperRow}>
                            <Text style={styles.selectAddressTitle}> Select Address</Text>
                            <TouchableOpacity
                                style={styles.upperSubRow}
                                onPress={onPressAddNew}
                            >
                                <Icons.AddCircle height={16} width={16} />
                                <Text style={styles.addNewText}> Add New</Text>
                            </TouchableOpacity>
                        </View>
                        <View style={styles.border} />
                        <View style={{ paddingHorizontal: 15, marginVertical: 20 }}>
                            {data.map(renderAddressItem)}
                        </View>
                        <View style={styles.buttonContainer}>
                            <Button
                                title='Proceed to Checkout'
                                buttonStyle={{ marginHorizontal: 0 }}
                                titleStyle={styles.buttonText}
                                onPress={onPressProceedToCheckout}
                            />
                        </View>
                    </View>
                )
            }



        </View>
    )
}

export default SelectAddressBottomSheet

const styles = StyleSheet.create({
    container: {
        flex: 1
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: colors.lightSilver,
    },
    belowContainer: {
        padding: Matrics.vs(16)
    },
    iconStyle: {
        marginBottom: Matrics.vs(10)
    },
    noAddressContainer: {
        justifyContent: 'center',
        alignItems: "center",
        marginBottom: Matrics.vs(16)
    },
    addressItemContainer: {
        width: "100%",
        flexDirection: 'row',

    },
    separator: {
        borderBottomWidth: 1,
        borderBottomColor: colors.lightSilver,
        marginVertical: Matrics.vs(10)
    },
    addressText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkLightGray,
        lineHeight: Matrics.vs(16.71),
    },
    buttonContainer: {
        width: "100%",
        minHeight: 56,
        backgroundColor: colors.white,
        padding: 10,
        elevation: 7
    },
    upperRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
        marginHorizontal: Matrics.s(10),

    },
    upperSubRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
    },
    selectAddressTitle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.vs(26),
        marginLeft: Matrics.s(10),
        marginVertical: Matrics.vs(10),
    },
    addNewText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
    buttonText: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
        lineHeight: Matrics.vs(22),
        textAlign: 'center'
    }
})