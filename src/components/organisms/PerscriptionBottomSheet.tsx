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
            <View style={{ padding: 15 }}>
                <Text style={styles.bottomSheetTitle}>Upload Perscription</Text>
                <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                    <Icons.Camera />
                    <TouchableOpacity
                        onPress={onPressClickAPhoto}
                    >
                        <Text style={styles.subTitle}>Click a Photo</Text>
                    </TouchableOpacity>
                </View>
                <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                    <Icons.Gallery />
                    <TouchableOpacity
                        onPress={onPressChooseFromGallery}
                    >
                        <Text style={styles.subTitle}>Choose from Gallery</Text>
                    </TouchableOpacity>
                </View>
                <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                    <Icons.File />
                    <TouchableOpacity
                        onPress={onPressUploadaFile}
                    >
                        <Text style={styles.subTitle}>Upload File</Text>
                    </TouchableOpacity>
                </View>
                <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                    <Icons.Article />
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
        elevation: 2
    },
    bottomSheetTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginBottom: 10
    },
    subTitle: {
        fontSize: 14,
        fontWeight: '500',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginLeft: 10
    },
    guidePerscriptionTitle: {
        fontSize: 15,
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: 25,
        marginBottom: 5
    },
    guideSubtitle: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
        marginLeft: 4
    },
    border: {
        borderBottomWidth: 2,
        borderBottomColor: "#D7D7D7",
    },
})
