import { StyleSheet, Text, View } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../atoms/Button';



type CancelLabTestBottomSheetProps = {
    id: number;
    onCancel: (id: number) => void;
}

const CancelLabTestBottomSheet: React.FC<CancelLabTestBottomSheetProps> = ({ onCancel, id }) => {

    const [selectedReason, setSelectedReason] = useState<number>(0);
    const color = selectedReason ? colors.themePurple : colors.inactiveGray;

    const onPressCancel = () => {
        if (selectedReason) {
            onCancel(id);
        } else {
            onCancel(0);
        }
    }
    return (
        <View>
            <Text style={styles.title}>Cancel Lab Test Reason</Text>
            <View style={styles.separator} />
            <View style={{ paddingHorizontal: Matrics.s(10) }}>
                <View style={styles.rowStyle}>
                    <Text style={styles.reasonTitle}>Found better deal elsewhere</Text>
                    {
                        (selectedReason === 1) ?
                            <Icons.RadioCheck style={{ marginRight: Matrics.s(10) }} height={20} width={20} onPress={() => setSelectedReason(0)} /> :
                            <Icons.RadioUncheck style={{ marginRight: Matrics.s(10) }} height={20} width={20} onPress={() => setSelectedReason(1)} />
                    }
                </View>
                <View style={styles.separator} />
                <View style={styles.rowStyle}>
                    <Text style={styles.reasonTitle}>Test not required</Text>
                    {
                        (selectedReason === 2) ?
                            <Icons.RadioCheck style={{ marginRight: Matrics.s(10) }} height={20} width={20} onPress={() => setSelectedReason(0)} /> :
                            <Icons.RadioUncheck style={{ marginRight: Matrics.s(10) }} height={20} width={20} onPress={() => setSelectedReason(2)} />
                    }
                </View>
                <View style={styles.separator} />
                <View style={styles.rowStyle}>
                    <Text style={styles.reasonTitle}>Order placed by mistake</Text>
                    {
                        (selectedReason === 3) ?
                            <Icons.RadioCheck style={{ marginRight: Matrics.s(10) }} height={20} width={20} onPress={() => setSelectedReason(0)} /> :
                            <Icons.RadioUncheck style={{ marginRight: Matrics.s(10) }} height={20} width={20} onPress={() => setSelectedReason(3)} />
                    }
                </View>
            </View>
            <View style={styles.buttonContainer}>
                <Button
                    title="Cancel"
                    buttonStyle={{ marginHorizontal: 0, backgroundColor: color }}
                    titleStyle={styles.buttontitle}
                    onPress={onPressCancel}
                />
            </View>
        </View>
    )
}

export default CancelLabTestBottomSheet;

const styles = StyleSheet.create({
    title: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20),
    },
    separator: {
        borderBottomWidth: 0.5,
        borderBottomColor: colors.secondaryLabel,
        marginVertical: Matrics.s(10)
    },
    rowStyle: {
        flexDirection: 'row',
        justifyContent: "space-between",
        marginVertical: Matrics.s(5)
    },
    reasonTitle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    buttonContainer: {
        backgroundColor: colors.white,
        padding: Matrics.s(12),
        elevation: Matrics.s(8),
        marginTop: Matrics.s(10)
    },
    buttontitle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
        lineHeight: Matrics.s(20)
    }
})