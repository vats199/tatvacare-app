import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';


type FreeTestBottomSheetProps = {

}

const FreeTestBottomSheet: React.FC<FreeTestBottomSheetProps> = ({

}) => {
    return (
        <View style={styles.contentContainer}>
            <View>
                <Text style={styles.bottomSheetTitle}>Free Tests</Text>
                <View style={styles.border} />
                <View style={{ padding: 10 }}>
                    <Text style={styles.subTitle}>Test Name 1</Text>
                    <Text style={styles.subTitle}>Test Name 2</Text>
                    <Text style={styles.subTitle}>Test Name 3</Text>
                </View>
            </View>
        </View>
    )
}

export default FreeTestBottomSheet

const styles = StyleSheet.create({
    contentContainer: {
        flex: 1,
        backgroundColor: colors.white,
        elevation: 2,
        shadowOffset: { width: 0, height: -2 }
    },
    bottomSheetTitle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginBottom: Matrics.s(10),
        marginLeft: Matrics.s(20),
        lineHeight: Matrics.s(26)
    },
    subTitle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '500',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        lineHeight: Matrics.s(18),
        marginLeft: Matrics.s(10),
        marginVertical: Matrics.s(5)
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: colors.lightSilver,
    },
})