import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../atoms/Button';

export type labTest = {
    id: number;
    amountPaid?: string;
    title?: string;
    orderId?: string;
    appointmentOn?: string;
    time?: string;
    status?: "finished" | "unfinished" | "cancelled";
}

type ScheduleLabTestProps = {
    data: labTest[];
    onPressCancel: (item: number) => void;
    onPressItem: () => void;
    onPressReschedule: () => void;
}



const ScheduleLabTest: React.FC<ScheduleLabTestProps> = ({ data, onPressCancel, onPressItem, onPressReschedule }) => {

    const onCancel = (id: number) => {
        onPressCancel(id)
    }

    const renderLabTestItem = (item: labTest, index: number) => {
        return (
            <View style={styles.container}>
                <TouchableOpacity onPress={onPressItem}>
                    <View style={{ flexDirection: "row" }}>
                        <Icons.LabTestIcon height={36} width={36} />
                        <View style={{ marginLeft: 10 }}>
                            <Text style={styles.title}>{item.title}</Text>
                            <View style={{ width: "75%", flexDirection: "row", justifyContent: "space-between" }}>
                                <Text style={styles.amountPaid}>Amount Paid</Text>
                                <Text style={styles.amountPaid}>{item.amountPaid}</Text>
                            </View>
                        </View>
                    </View>
                    <View style={styles.separator} />
                    <View style={{ flexDirection: "row" }}>
                        <Text style={styles.keyStyle}>Order ID:</Text>
                        <Text style={styles.valueStyle}>{item.orderId} </Text>
                    </View>
                    <View style={{ flexDirection: "row", marginVertical: 5 }}>
                        <Text style={styles.keyStyle}>Appointment On:</Text>
                        <Text style={styles.valueStyle}>{item.appointmentOn} </Text>
                    </View>
                    <View style={{ flexDirection: "row", marginVertical: 5 }}>
                        <Text style={styles.keyStyle}>Time:</Text>
                        <Text style={styles.valueStyle}>{item.time} </Text>
                    </View>
                </TouchableOpacity>
                {
                    (item.status === "unfinished") && (
                        <View style={{ flexDirection: "row", marginVertical: 5 }}>
                            <Button
                                title="Cancel"
                                buttonStyle={{ width: "50%", marginHorizontal: 0, backgroundColor: colors.white, borderWidth: 1, borderColor: colors.themePurple }}

                                titleStyle={{ ...styles.buttontitle, color: colors.themePurple }}
                                onPress={() => onCancel(item.id)}
                            />
                            <Button
                                title="Reschedule"
                                buttonStyle={{ width: "50%", marginHorizontal: 10 }}
                                titleStyle={styles.buttontitle}
                                onPress={onPressReschedule}
                            />
                        </View>
                    )
                }
                {
                    (item.status === "finished") &&
                    (
                        <View style={{ marginVertical: 5 }}>
                            <Button
                                title="Download Report "
                                buttonStyle={{ marginHorizontal: 0 }}
                                titleStyle={styles.buttontitle}
                            />
                        </View>
                    )
                }
                {
                    (item.status === "cancelled") && (

                        <View>
                            <View style={styles.separator} />
                            <Text style={styles.cancelledText}>Cancelled</Text>
                        </View>
                    )
                }

            </View>
        );
    }
    return (
        <View style={{ padding: 10 }}>
            {data?.map(renderLabTestItem)}
        </View>
    )
}

export default ScheduleLabTest

const styles = StyleSheet.create({
    container: {
        minHeight: Matrics.vs(216),
        backgroundColor: 'white',
        borderRadius: Matrics.s(12),
        padding: 15,
        marginVertical: 10,
        elevation: 0.7,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
        width: "100%"
    },
    separator: {
        borderBottomWidth: 0.5,
        borderBottomColor: "#999999",
        marginVertical: Matrics.vs(10)
    },
    title: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(18),
    },
    amountPaid: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
        lineHeight: Matrics.s(16),
    },
    keyStyle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        lineHeight: Matrics.s(18),
    },
    valueStyle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(18),
    },
    buttontitle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
        lineHeight: Matrics.s(18),
        textAlign: "center"
    },
    cancelledText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: "#FF3333",
        lineHeight: Matrics.s(18),

    }
})