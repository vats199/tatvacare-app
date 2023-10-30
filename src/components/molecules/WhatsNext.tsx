import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';

type WhatsNextProps = {

}

const WhatsNext: React.FC<WhatsNextProps> = () => {
    return (
        <View>
            <Text style={styles.titleText}>What's Next?</Text>
            <View style={styles.textContainer}>
                <Text style={styles.textStyle}> 1. Once you receive your device connect it with MyTatva account</Text>
                <Text style={styles.textStyle}>2. Test/Use regularly to measure your health</Text>

            </View>
        </View>
    )
}

export default WhatsNext;

const styles = StyleSheet.create({
    titleText: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(19),
        marginTop: Matrics.s(20)
    },
    textContainer: {
        marginVertical: Matrics.vs(10),
        padding: Matrics.vs(12),
        backgroundColor: colors.white,
        borderRadius: Matrics.vs(12),
        elevation: 0.3,
        minHeight: Matrics.vs(52),
        width: '100%',
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    textStyle: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        lineHeight: Matrics.s(17),
    }
})