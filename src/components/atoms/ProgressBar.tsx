import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'

type ProgressBarProps = {
    progress: number
}

const ProgressBar: React.FC<ProgressBarProps> = ({ progress }) => {
    return (
        <View style={styles.container}>
            <View style={[styles.progress, { width: `${progress}%` }]}/>
        </View>
    )
}

export default ProgressBar

const styles = StyleSheet.create({
    container:{
        marginVertical: 10,
        width: '100%',
        height: 4,
        borderRadius: 2,
        backgroundColor: colors.lightGrey
    },
    progress:{
        height: 4,
        borderRadius: 2,
        backgroundColor: colors.green
    }
})