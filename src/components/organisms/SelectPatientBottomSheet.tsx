import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';
import { patientItem } from '../../screens/Diagnostic/LabTestCartScreen';

type SelectPatientBottomSheetProps = {
    data: patientItem[];
    onPressAddNew: () => void;
    onPressPatient: (item: string) => void;
}
const SelectPatientBottomSheet: React.FC<SelectPatientBottomSheetProps> = ({
    data,
    onPressAddNew,
    onPressPatient
}) => {

    const renderPatientItem = (item: patientItem, index: number) => {
        return (
            <TouchableOpacity style={styles.patientItem}
                onPress={() => onPressPatient(item.name)}
            >
                <View style={{ flexDirection: "row" }}>
                    <Icons.Person height={28} width={28} />
                    <View style={{ marginLeft: 10 }}>
                        <Text style={styles.patientName}>{item.name}</Text>
                        <Text style={styles.ageEmailAddresstext}>{item.age}</Text>
                        <Text style={styles.ageEmailAddresstext}>{item.emailAddress}</Text>
                    </View>
                </View>
                <View>
                    <Icons.ThreeDot />
                </View>
            </TouchableOpacity>
        )
    }


    return (
        <View style={styles.contentContainer}>
            <View style={{
                paddingHorizontal: 15,
                borderBottomWidth: 0.3,
                borderBottomColor: '#ccc',
                elevation: 0.2
            }}>
                <View style={styles.upperRow}>
                    <Text style={styles.selectAddressTitle}> Select Patient</Text>
                    <TouchableOpacity
                        style={styles.upperSubRow}
                        onPress={onPressAddNew}
                    >
                        <Icons.AddCircle height={16} width={16} />
                        <Text style={styles.addNewText}> Add New</Text>
                    </TouchableOpacity>
                </View>
            </View>
            <View style={styles.belowContainer}>
                {data.map(renderPatientItem)}
            </View>
        </View>
    )
}

export default SelectPatientBottomSheet

const styles = StyleSheet.create({
    contentContainer: {
        flex: 1,
        backgroundColor: colors.white
    },
    selectAddressTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,

    },
    upperRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
        marginBottom: 20,
    },
    upperSubRow: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: "center",
    },
    addNewText: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,

    },
    belowContainer: {
        flex: 1,
        paddingVertical: 10,
        paddingHorizontal: 15,
        backgroundColor: "#f9f9f9"
    },
    patientItem: {
        flexDirection: "row",
        justifyContent: "space-between",
        marginVertical: 7,
        padding: 10,
        borderRadius: 10,
        backgroundColor: "white",
        elevation: 0.1
    },
    patientName: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 7
    },
    ageEmailAddresstext: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginBottom: 5
    }
})