import { StyleSheet, Text, TextInput, TextInputProps, TextStyle, TouchableOpacity, View, ViewStyle } from 'react-native'
import React from 'react'

interface InputFieldProps extends TextInputProps {
    style?: ViewStyle;
    textStyle?: TextStyle;
    label?: string;
    error?: string;
    rightLabel?: string;
    rightValue?: string,
    showErrorText?: boolean,
    quantityButtons?: boolean,
    onPlus?: () => void,
    onMinus?: () => void
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
    rightLabel,
    rightValue,
    numberOfLines,
    multiline,
    secureTextEntry = false,
    showErrorText = true,
    autoFocus = false,
    onFocus = () => { },
    onBlur = () => { },
    quantityButtons = false,
    onMinus = () => { },
    onPlus = () => { }
}) => {

    const [hidden, setHidden] = React.useState<boolean>(secureTextEntry)

    return (
        <>
            <View style={[styles.container, style, (error?.length ?? 0) > 0 && styles.errorContainer]}>
                {label &&
                    <View style={styles.labelContainer}>
                        <Text style={styles.label}>{label}</Text>
                        {rightLabel && <Text style={styles.rightlabel}>{rightLabel} : {rightValue}</Text>}
                    </View>
                }
                <View style={styles.row}>
                    {/* {quantityButtons &&
                        <TouchableOpacity style={styles.qtyBtn} onPress={onMinus}>
                            <Icons.Subtract />
                        </TouchableOpacity>
                    } */}
                    <TextInput
                        placeholder={placeholder}
                        placeholderTextColor={'gray'}
                        value={value}
                        editable={editable}
                        keyboardType={keyboardType}
                        autoCapitalize={autoCapitalize}
                        maxLength={maxLength}
                        numberOfLines={numberOfLines}
                        onChangeText={onChangeText}
                        multiline={multiline}
                        autoFocus={autoFocus}
                        onFocus={onFocus}
                        onBlur={onBlur}
                        secureTextEntry={hidden}
                        style={[editable ? styles.canEdit : styles.cannotEdit, textStyle]}
                    />
                    {/* {quantityButtons &&
                        <TouchableOpacity style={styles.qtyBtn} onPress={onPlus}>
                            <Icons.Add />
                        </TouchableOpacity>
                    } */}
                    {/* {secureTextEntry &&
                        <TouchableOpacity onPress={() => setHidden(!hidden)}>
                            {hidden ?
                                <Icons.EyeOn height={25} width={25} />
                                :
                                <Icons.EyeOff height={25} width={25} />
                            }
                        </TouchableOpacity>
                    } */}
                </View>
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
        color: 'blue',
        fontSize: 14,
    },
    rightlabel: {
        color: 'black',
        fontSize: 10,
    },
    canEdit: {
        color: 'black',
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