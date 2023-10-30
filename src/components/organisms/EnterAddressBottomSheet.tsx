import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';
import Button from '../atoms/Button';
import AnimatedInputField from '../atoms/AnimatedInputField';

type EnterAddressBottomSheetProps = {
    onPressSaveAddress?: () => void;
    buttonTitle: string
}

const EnterAddressBottomSheet: React.FC<EnterAddressBottomSheetProps> = ({ onPressSaveAddress, buttonTitle }) => {

    const [selectedAddressType, setSelectedAddressType] = useState<string | undefined>('');
    const [enteredPincode, setEnteredPincode] = useState<string>();
    const [enteredStreetName, setEnteredStreetName] = useState<string>();
    const [enteredHouseName, setEnteredHouseName] = useState<string>();

    const handleEnteredPincode = (item: string) => {
        setEnteredPincode(item);
    }
    const handleEnteredHouseName = (item: string) => {
        setEnteredHouseName(item);
    }
    const handleEnteredStreetName = (item: string) => {
        setEnteredStreetName(item);
    }
    const color = (selectedAddressType && enteredPincode && enteredStreetName && enteredHouseName) ? colors.themePurple : colors.darkGray;

    return (
        <View style={styles.contentContainer}>
            <Text style={styles.enterAddressTitle}>Enter Address </Text>
            <View style={styles.border} />
            <View style={{ padding: 20 }}>
                <View style={styles.disclaimerBox}>
                    <Text style={styles.disclaimerText}>Disclaimer: We need this information to deliver your product & for
                        collecting test samples</Text>

                </View>
                <View style={{ marginVertical: 5 }}>
                    <AnimatedInputField
                        placeholder='Enter Pincode'
                        style={styles.inputStyle}
                        textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} showAnimatedLabel={true}
                    />
                </View>
                <View style={{ marginVertical: 5 }}>
                    <AnimatedInputField
                        placeholder='House number and Building *'
                        style={styles.inputStyle}
                        textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} showAnimatedLabel={true}
                        onChangeText={handleEnteredHouseName}
                    />
                </View>
                <View style={{ marginVertical: 5 }}>
                    <AnimatedInputField
                        placeholder='Street name *'
                        style={styles.inputStyle}
                        textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} showAnimatedLabel={true}
                        onChangeText={handleEnteredStreetName}
                    />
                </View>
                <View>
                    <Text style={styles.addessTypeText}>Address Type</Text>

                    <View style={{ flexDirection: "row", alignItems: "center" }}>
                        <View style={{ flexDirection: "row", alignItems: "center", marginRight: 20 }}>
                            <TouchableOpacity onPress={() => setSelectedAddressType("Home")} >
                                {
                                    (selectedAddressType === 'Home') ?
                                        <Icons.RadioCheck style={{ marginRight: 10 }} height={20} width={20} /> :
                                        <Icons.RadioUncheck style={{ marginRight: 10 }} height={20} width={20} />
                                }
                            </TouchableOpacity>
                            <Text>Home</Text>
                        </View>
                        <View style={{ flexDirection: "row", alignItems: "center", marginRight: 20 }}>
                            <TouchableOpacity onPress={() => setSelectedAddressType("Office")}>
                                {
                                    (selectedAddressType === 'Office') ?
                                        <Icons.RadioCheck style={{ marginRight: 10 }} height={20} width={20} /> :
                                        <Icons.RadioUncheck style={{ marginRight: 10 }} height={20} width={20} />
                                }
                            </TouchableOpacity>
                            <Text>Office</Text>
                        </View>
                        <View style={{ flexDirection: "row", alignItems: "center", marginRight: 20 }}>
                            <TouchableOpacity onPress={() => setSelectedAddressType("Other")}>
                                {
                                    (selectedAddressType === 'Other') ?
                                        <Icons.RadioCheck style={{ marginRight: 10 }} height={20} width={20} /> :
                                        <Icons.RadioUncheck style={{ marginRight: 10 }} height={20} width={20} />
                                }
                            </TouchableOpacity>
                            <Text>Other</Text>
                        </View>
                    </View>
                </View>
                <View style={{ marginTop: 20 }}>
                    <Button
                        title={buttonTitle}
                        titleStyle={styles.outlinedButtonText}
                        buttonStyle={[styles.saveAddressButton, { backgroundColor: color }]}
                        onPress={onPressSaveAddress}
                    />
                </View>
            </View>
        </View>
    )
}

export default EnterAddressBottomSheet

const styles = StyleSheet.create({

    contentContainer: {
        flex: 1,
    },
    enterAddressTitle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
        marginBottom: 10
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: "#E9E9E9",
    },
    disclaimerBox: {
        padding: 10,
        borderWidth: 1,
        borderColor: "#F0F0F0",
        borderRadius: 12
    },
    disclaimerText: {
        fontSize: Matrics.mvs(10),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },

    outlinedButtonText: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
    },

    saveAddressButton: {
        padding: 10,
        height: 40,
        borderRadius: 16,
        backgroundColor: colors.inactiveGray,
        marginHorizontal: 0
    },
    inputStyle: {
        backgroundColor: 'white',
        height: Matrics.mvs(44),
        borderColor: '#E0E0E0',
        borderWidth: 1.3,
        borderRadius: 14,
        paddingHorizontal: Matrics.s(8)

    },
    placeholderText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    },
    addessTypeText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: Matrics.mvs(10)
    },


})