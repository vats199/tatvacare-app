import { StyleSheet, Text, View, ButtonProps, TouchableOpacity, ViewStyle, TextStyle, ActivityIndicator } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'

interface MyButtonProps extends ButtonProps {
    buttonStyle?: ViewStyle,
    titleStyle?: TextStyle,
    activeOpacity?: number,
    loading?: boolean,
    loaderColor?: string
}

const Button: React.FC<MyButtonProps> = ({ title, onPress, buttonStyle, titleStyle, activeOpacity, disabled, loading = false, loaderColor = 'white' }) => {
    return (
        <TouchableOpacity style={[styles.container, buttonStyle]} onPress={onPress} activeOpacity={activeOpacity} disabled={disabled || loading}>
            {loading ?
                <ActivityIndicator size={'small'} color={loaderColor} />
                :
                <Text style={[styles.title, titleStyle]}>{title}</Text>
            }
        </TouchableOpacity>
    )
}

export default Button

const styles = StyleSheet.create({
    container: {
        padding: 15,
        backgroundColor: colors.themePurple,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: 5
    },
    title: {
        color: 'white',
        fontSize: 16,
    }
})