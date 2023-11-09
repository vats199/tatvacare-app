import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Matrics } from '../../constants';

type UploadPerscriptionProps = {
    onPressUpload: () => void
}

const UploadPrescription: React.FC<UploadPerscriptionProps> = ({ onPressUpload }) => {
    return (
        <View style={styles.perscription}>
            <View
                style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                }}>
                <Icons.MedicineBlack height={36} width={36} />
                <View style={styles.textBox}>
                    <Text style={styles.uploadPerscription}>
                        Upload Prescription
                    </Text>
                    <Text style={styles.arrangeMedicine}>
                        We Will Arrange Medicine For you
                    </Text>
                </View>
            </View>
            <View>
                <Icons.forwardArrow height={12} width={12} onPress={onPressUpload} />
            </View>
        </View>
    )
}

export default UploadPrescription

const styles = StyleSheet.create({
    perscription: {
        marginVertical: Matrics.s(12),
        padding: Matrics.s(14),
        backgroundColor: colors.white,
        borderRadius: Matrics.s(12),
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        minHeight: Matrics.vs(60),
        elevation: 0.5,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    textBox: {
        marginLeft: Matrics.s(10),
    },
    uploadPerscription: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(18)
    },
    arrangeMedicine: {
        color: colors.darkGray,
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        lineHeight: Matrics.s(16)
    },
})