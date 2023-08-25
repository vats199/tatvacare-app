import { Animated, StyleSheet, Text, TextInput, TextInputProps, TextStyle, TouchableOpacity, View, ViewStyle } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors';
import { TapGestureHandler } from 'react-native-gesture-handler';

interface InputFieldProps extends TextInputProps {
    style?: ViewStyle;
    textStyle?: TextStyle;
    label?: string;
    error?: string;
    showErrorText?: boolean,
}

const InputField: React.FC<InputFieldProps> = ({
    label,
    textStyle,
    style,
    placeholder,
    value,
    onChangeText,
    editable = true,
    autoCapitalize,
    keyboardType,
    maxLength,
    error,
    numberOfLines,
    multiline,
    secureTextEntry = false,
    showErrorText = true,
    autoFocus = false,
    onFocus = () => { },
    onBlur = () => { },
}) => {

    const [hidden, setHidden] = React.useState<boolean>(secureTextEntry)

    const [isFocused, setIsFocused] = React.useState<boolean>(false);
    const translateY = new Animated.Value(0);

    const handleFocus = (e: any) => {
        onFocus(e)
        setIsFocused(true);
        Animated.timing(translateY, {
            toValue: -15,
            duration: 300,
            useNativeDriver: false,
        }).start();
    };

    const handleBlur = (e: any) => {
        onBlur(e)
        setIsFocused(false);
        Animated.timing(translateY, {
            toValue: 0,
            duration: 300,
            useNativeDriver: false,
        }).start();
    };

    return (
        <>
            <View style={[styles.container, style, (error?.length ?? 0) > 0 && styles.errorContainer]}>
                {/* {label &&
                    <View style={styles.labelContainer}>
                        <Text style={styles.label}>{label}</Text>
                        {rightLabel && <Text style={styles.rightlabel}>{rightLabel} : {rightValue}</Text>}
                    </View>
                } */}
                <TapGestureHandler onHandlerStateChange={handleFocus}>

                    <Animated.View style={[styles.row]}>
                        {(isFocused || (value?.length ?? 0) > 0) && <Animated.Text style={{ position: 'absolute', transform: [{ translateY }] }}>{placeholder}</Animated.Text>}
                        <TextInput
                            placeholder={!isFocused ? placeholder : ''}
                            placeholderTextColor={colors.subTitleLightGray}
                            value={value}
                            editable={editable}
                            keyboardType={keyboardType}
                            autoCapitalize={autoCapitalize}
                            maxLength={maxLength}
                            numberOfLines={numberOfLines}
                            onChangeText={onChangeText}
                            multiline={multiline}
                            autoFocus={autoFocus}
                            onFocus={handleFocus}
                            onBlur={handleBlur}
                            secureTextEntry={hidden}
                            style={[editable ? styles.canEdit : styles.cannotEdit, textStyle, (isFocused || (value?.length ?? 0) > 0) && { paddingTop: 15 }]}
                        />
                    </Animated.View>
                </TapGestureHandler>
            </View>
            {(error?.length ?? 0) > 0 && showErrorText && <Text style={styles.error}>{error}</Text>}
        </>
    )
}

export default InputField

const styles = StyleSheet.create({
    container: {
        borderWidth: 1,
        borderRadius: 5,
        borderColor: 'gray',
        paddingVertical: 5,
        paddingHorizontal: 10,
        marginVertical: 5
    },
    errorContainer: {
        borderColor: 'red',
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    qtyBtn: {
        padding: 5,
        backgroundColor: 'blue',
        borderRadius: 2,
        aspectRatio: 1,
        alignItems: 'center',
        justifyContent: 'center'
    },
    label: {
        color: colors.labelTitleDarkGray,
        fontSize: 14
    },
    rightlabel: {
        color: 'black',
        fontSize: 10,
    },
    canEdit: {
        padding: 0,
        flex: 1,
    },
    cannotEdit: {
        color: 'gray',
        padding: 0,
        flex: 1
    },
    error: {
        color: 'red'
    },
    labelContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    }
})