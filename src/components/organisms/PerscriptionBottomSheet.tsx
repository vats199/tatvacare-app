import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';
import { Fonts } from '../../constants';

type PerscriptionBottomSheetProps = {
    onPressChooseFromGallery: () => void;
    onPressClickAPhoto: () => void;
    onPressUploadaFile: () => void;
}

const PerscriptionBottomSheet: React.FC<PerscriptionBottomSheetProps> = ({
    onPressChooseFromGallery,
    onPressClickAPhoto,
    onPressUploadaFile
}) => {
    return (
        <View style={styles.contentContainer}>
            <View style={{ padding: Matrics.s(15) }}>
                <Text style={styles.bottomSheetTitle}>Upload Perscription</Text>
                <View style={styles.rowStyle}>
                    <Icons.Camera width={24} height={24} />
                    <TouchableOpacity
                        onPress={onPressClickAPhoto}
                    >
                        <Text style={styles.subTitle}>Click a Photo</Text>
                    </TouchableOpacity>
                </View>
                <View style={styles.rowStyle}>
                    <Icons.Gallery width={24} height={24} />
                    <TouchableOpacity
                        onPress={onPressChooseFromGallery}
                    >
                        <Text style={styles.subTitle}>Choose From Gallery</Text>
                    </TouchableOpacity>
                </View>
                <View style={styles.rowStyle}>
                    <Icons.File width={24} height={24} />
                    <TouchableOpacity
                        onPress={onPressUploadaFile}
                    >
                        <Text style={styles.subTitle}>Upload a File</Text>
                    </TouchableOpacity>
                </View>
                <View style={styles.rowStyle}>
                    <Icons.Article width={24} height={24} />
                    <TouchableOpacity
                    // onPress={() => navigation.navigate("MyPerscription", { data: uploadedPerscription })}
                    >
                        <Text style={styles.subTitle}>My Prescriptions</Text>
                    </TouchableOpacity>
                </View>

                <View>
                    <Text style={styles.guidePerscriptionTitle}>Guide for a valid prescription</Text>

                    <Text style={styles.guideSubtitle}>{'\u2022'}  Don't crop out any part of the image</Text>
                    <Text style={styles.guideSubtitle}>{'\u2022'}  Avoid blurred image</Text>
                    <Text style={styles.guideSubtitle}>{'\u2022'}  Include details of doctor and patient + clinic visit date</Text>
                    <Text style={styles.guideSubtitle}>{'\u2022'}  Medicines will be dispensed as per prescription</Text>
                    <Text style={styles.guideSubtitle}>{'\u2022'}  Supported files type: jpeg, jpg, png, pdf</Text>
                    <Text style={styles.guideSubtitle}>{'\u2022'}  Maximum allowed file size: 5MB</Text>
                </View>
            </View>
        </View>
    )
}

export default PerscriptionBottomSheet

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
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(26),
        marginBottom: Matrics.s(15)
    },
    rowStyle: {
        flexDirection: 'row',
        alignItems: "center",
        marginVertical: Matrics.s(5)
    },
    subTitle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '500',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginLeft: Matrics.s(10)
    },
    guidePerscriptionTitle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(18),
        marginTop: Matrics.s(20),
        marginBottom: Matrics.s(10)
    },
    guideSubtitle: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
        marginLeft: Matrics.s(4)
    },

})
