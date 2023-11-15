import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';

type FreeTestProps = {
    onPressAdd: () => void;
    onPressViewFreeTest: () => void;
}

const FreeTest: React.FC<FreeTestProps> = ({ onPressAdd, onPressViewFreeTest }) => {
    return (
        <View style={styles.freeTestBox}>
            <Text style={styles.freeTestText}>
                Free Test Available for you
            </Text>
            <View
                style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                    flex: 1,
                    alignItems: 'center',
                }}>
                <View style={{ flex: 0.85 }}>
                    <Text style={styles.freeText}>
                        Since you are on paid plan you can get free test aslo done
                        accor to your health
                    </Text>
                </View>
                <TouchableOpacity style={{ flex: 0.15 }} onPress={onPressAdd} >
                    <Text style={styles.textAddButton}> Add</Text>
                </TouchableOpacity>
            </View>
            <TouchableOpacity onPress={onPressViewFreeTest} >
                <Text style={styles.textViewButton}>View Free Test</Text>
            </TouchableOpacity>
        </View>
    )
}

export default FreeTest

const styles = StyleSheet.create({
    freeTestBox: {
        marginVertical: 5,
        padding: 12,
        backgroundColor: colors.white,
        borderRadius: 12,
        minHeight: 100,
        width: '100%',
        elevation: 0.5,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    freeTestText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    freeText: {
        color: colors.darkGray,
        fontSize: Matrics.mvs(12),
        fontWeight: '300',
        fontFamily: Fonts.BOLD,
    },
    textAddButton: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        color: colors.themePurple,
        fontFamily: Fonts.BOLD,
        marginLeft: 18,
    },
    textViewButton: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
})