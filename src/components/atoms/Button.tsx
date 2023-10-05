import { StyleSheet, Text, View, ButtonProps, TouchableOpacity, ViewStyle, TextStyle, ActivityIndicator } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Fonts, Matrics } from '../../constants'

interface MyButtonProps extends ButtonProps {
    buttonStyle?: ViewStyle,
    titleStyle?: TextStyle,
    activeOpacity?: number,
    loading?: boolean,
    loaderColor?: string
}

const Button: React.FC<MyButtonProps> = ({ title, onPress, buttonStyle, titleStyle, activeOpacity, disabled, loading = false, loaderColor = 'white' }) => {
    return (
        <TouchableOpacity style={[styles.container, { backgroundColor: disabled ? colors.disableButton : colors.themePurple }, buttonStyle]} onPress={onPress} activeOpacity={activeOpacity ?? 0.7} disabled={disabled || loading}>
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
        borderRadius: Matrics.mvs(16)
    },
    title: {
        color: 'white',
        fontSize: Matrics.mvs(16),
        fontFamily: Fonts.BOLD
    }
})