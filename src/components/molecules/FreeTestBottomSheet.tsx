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
                <Text style={[styles.bottomSheetTitle, { marginLeft: 20 }]}>Free Tests</Text>
                <View style={styles.border} />
                <View style={{ padding: 10 }}>
                    <Text style={[styles.subTitle, { marginVertical: 5 }]}>Test Name 1</Text>
                    <Text style={[styles.subTitle, { marginVertical: 5 }]}>Test Name 2</Text>
                    <Text style={[styles.subTitle, { marginVertical: 5 }]}>Test Name 3</Text>
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
        elevation: 2
    },
    bottomSheetTitle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginBottom: 10
    },
    subTitle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '500',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginLeft: Matrics.s(10)
    },
    border: {
        borderBottomWidth: 2,
        borderBottomColor: "#D7D7D7",
    },
})