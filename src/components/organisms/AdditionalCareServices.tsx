import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
type AdditionalServicesProps = {
    onPressConsultNutritionist: () => void,
    onPressConsultPhysio: () => void,
    onPressBookDiagnostic: () => void,
    onPressBookDevices: () => void
}

type AdditionalServicesItem = {
    title: 'Consult Nutritionist' | 'Consult Physio' | 'Book Diagnostic' | 'Book Devices',
    onPress: () => void
}

const AdditionalCareServices: React.FC<AdditionalServicesProps> = ({ onPressConsultNutritionist, onPressConsultPhysio, onPressBookDiagnostic, onPressBookDevices }) => {

    const options: AdditionalServicesItem[] = [
        {
            title: 'Consult Nutritionist',
            onPress: onPressConsultNutritionist
        },
        {
            title: 'Consult Physio',
            onPress: onPressConsultPhysio
        },
        {
            title: 'Book Diagnostic',
            onPress: onPressBookDiagnostic
        },
        {
            title: 'Book Devices',
            onPress: onPressBookDevices
        },
    ]

    const renderIcon = (title: 'Consult Nutritionist' | 'Consult Physio' | 'Book Diagnostic' | 'Book Devices') => {
        switch (title) {
            case 'Consult Nutritionist':
                return <Icons.ServicesNutritionist />
            case 'Consult Physio':
                return <Icons.ServicesPhysio />
            case 'Book Diagnostic':
                return <Icons.ServicesDiagnostic />
            case 'Book Devices':
                return <Icons.ServicesDevices />
        }
    }

    const renderServiceItem = (item: AdditionalServicesItem, index: number) => {
        const { title, onPress } = item
        return (
            <TouchableOpacity
                key={index.toString()}
                onPress={onPress}
                activeOpacity={0.7}
                style={styles.serviceItemContainer}
            >
                <View style={styles.iconContainer}>
                    {renderIcon(title)}
                </View>
                <Text style={styles.text}>{title}</Text>
            </TouchableOpacity>
        )
    }

    return (
        <View style={styles.container}>
            <Text style={styles.title}>Additional Care Services</Text>
            <View style={styles.itemsContainer}>
                {options.map(renderServiceItem)}
            </View>
        </View>
    )
}

export default AdditionalCareServices

const styles = StyleSheet.create({
    container: {
        marginVertical: 10,
    },
    title: {
        fontSize: 16,
        fontWeight: '700',
        color: colors.black
    },
    itemsContainer: {
        marginTop: 10,
        display: 'flex',
        flexDirection: 'row',
        gap: 15
    },
    serviceItemContainer: {
        flex: 1,
        gap: 5
    },
    iconContainer: {
        backgroundColor: colors.white,
        borderRadius: 12,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: 70
    },
    text: {
        fontSize: 14,
        fontWeight: '500',
        color: colors.inputValueDarkGray,
        lineHeight: 16.71,
        textAlign: 'center'
    },
})