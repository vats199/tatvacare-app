import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';

type SampleCollectionProps = {
    slot?: string;
    timeZone?: string;
    dayAndDate?: string;
}

const SampleCollection: React.FC<SampleCollectionProps> = ({ slot, timeZone, dayAndDate }) => {
    return (
        <View>
            <Text style={styles.sampleText}>Sample Collection</Text>
            <View style={[styles.sampleBox, styles.containerShadow]}>
                <View style={styles.row}>
                    <Icons.Event height={20} width={20} />
                    <Text style={{ marginLeft: 10 }}>{dayAndDate} </Text>
                </View>
                <View style={styles.row}>
                    <Icons.Schedule height={20} width={20} />
                    <Text style={{ marginLeft: 10 }}>{timeZone}, {slot} </Text>
                </View>
            </View>
        </View>
    )
}

export default SampleCollection

const styles = StyleSheet.create({
    sampleText: {
        fontSize: Matrics.s(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: 20,
        marginBottom: 10
    },
    sampleBox: {
        padding: Matrics.s(10),
        borderRadius: 12,
        backgroundColor: colors.white,

    },
    containerShadow: {
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.08,
        shadowRadius: 8,
        elevation: 0.4,
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: 5
    }
})