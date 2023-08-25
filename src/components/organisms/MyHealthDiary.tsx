import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'

type MyHealthDiaryProps = {
    onPressMedicine: () => void,
    onPressDiet: () => void,
    onPressExercise: () => void,
    onPressDevices: () => void,
    onPressMyIncidents: () => void
}

type HealthDiaryItem = {
    title: 'Medicines' | 'Diet' | 'Exercises' | 'Devices' | 'My Incidents',
    description: string,
    onPress: () => void
}

const MyHealthDiary: React.FC<MyHealthDiaryProps> = ({ onPressDevices, onPressDiet, onPressExercise, onPressMedicine, onPressMyIncidents }) => {

    const options: HealthDiaryItem[] = [
        {
            title: 'Medicines',
            description: 'Log and track your medicines!',
            onPress: onPressMedicine
        },
        {
            title: 'Diet',
            description: 'Log and track your calories!',
            onPress: onPressDiet
        },
        {
            title: 'Exercises',
            description: 'Log your exercise details!',
            onPress: onPressExercise
        },
        {
            title: 'Devices',
            description: 'Connect and monitor your condition!',
            onPress: onPressDevices
        },
        {
            title: 'My Incidents',
            description: 'Log your exercise details!',
            onPress: onPressMyIncidents
        },
    ]

    const renderIcon = (title: 'Medicines' | 'Diet' | 'Exercises' | 'Devices' | 'My Incidents') => {
        switch (title) {
            case 'Medicines':
                return <Icons.HealthDiaryMedicines />
            case 'Diet':
                return <Icons.HealthDiaryDiet />
            case 'Exercises':
                return <Icons.HealthDiaryExercise />
            case 'Devices':
                return <Icons.HealthDiaryDevices />
            case 'My Incidents':
                return <Icons.HealthDiaryMyIncidents />
        }
    }

    const renderHealthDiaryItem = (item: HealthDiaryItem, index: number) => {
        const { title, description, onPress } = item
        return (
            <TouchableOpacity
                key={index.toString()}
                style={styles.healthDiaryItemContainer}
                onPress={onPress}
                activeOpacity={0.7}
            >
                {renderIcon(title)}
                <View style={styles.textContainer}>
                    <Text style={styles.text}>{title}</Text>
                    <Text style={styles.subText}>{description}</Text>
                </View>
            </TouchableOpacity>
        )
    }

    return (
        <View style={styles.container}>
            <Text style={styles.title}>My Health Diary</Text>
            {options.map(renderHealthDiaryItem)}
        </View>
    )
}

export default MyHealthDiary

const styles = StyleSheet.create({
    container: {
        marginVertical: 10,
    },
    title: {
        fontSize: 16,
        fontWeight: '700',
        color: colors.black
    },
    healthDiaryItemContainer: {
        marginVertical: 5,
        padding: 10,
        backgroundColor: colors.white,
        borderRadius: 12,
        flexDirection: 'row',
        alignItems: 'center',
        minHeight: 70
    },
    textContainer: {
        marginLeft: 10,
        minHeight: 38
    },
    text: {
        fontSize: 16,
        fontWeight: '700',
        color: colors.labelDarkGray,
        lineHeight: 20
    },
    subText: {
        fontSize: 12,
        fontWeight: '300',
        lineHeight: 16,
        color: colors.subTitleLightGray
    },
})