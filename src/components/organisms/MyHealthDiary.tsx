import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'

type MyHealthDiaryProps = {
    onPressMedicine: () => void,
    onPressDiet: () => void,
    onPressExercise: () => void,
    onPressDevices: () => void,
    onPressMyIncidents: () => void,
    data: any
}

const MyHealthDiary: React.FC<MyHealthDiaryProps> = ({ onPressDevices, onPressDiet, onPressExercise, onPressMedicine, onPressMyIncidents, data }) => {

    // const renderIcon = (title: 'Medicines' | 'Diet' | 'Exercises' | 'Devices' | 'My Incidents') => {
    //     switch (title) {
    //         case 'Medicines':
    //             return <Icons.HealthDiaryMedicines />
    //         case 'Diet':
    //             return <Icons.HealthDiaryDiet />
    //         case 'Exercises':
    //             return <Icons.HealthDiaryExercise />
    //         case 'Devices':
    //             return <Icons.HealthDiaryDevices />
    //         case 'My Incidents':
    //             return <Icons.HealthDiaryMyIncidents />
    //     }
    // }

    const renderHealthDiaryItem = (item: any, idx: number) => {
        return (
            <TouchableOpacity
                key={idx.toString()}
                style={styles.healthDiaryItemContainer}
                // onPress={onPress}
                activeOpacity={0.7}
            >
                <Image resizeMode='contain' source={{ uri: item?.image_url || '' }} style={styles.imageStyle} />
                {/* {renderIcon(title)} */}
                <View style={styles.textContainer}>
                    <Text style={styles.text}>{item?.goal_name || '-'}</Text>
                    <Text style={styles.subText}>{item?.achieved_value || 0} of {item?.goal_value || 0} {item?.goal_measurement}</Text>
                </View>
            </TouchableOpacity>
        )
    }

    return (
        <View style={styles.container}>
            <Text style={styles.title}>My Health Diary</Text>
            {data.map((item: any, idx: number) => { return renderHealthDiaryItem(item, idx) })}
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
    imageStyle: {
        height: 40,
        width: 40,
    }
})