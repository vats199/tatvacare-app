import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Matrics } from '../../constants';

const DeviceDetails: React.FC = () => {
    return (
        <View style={{ flex: 1 }}>
            <Text style={styles.deviceDetailsText}>Device Details</Text>
            <Text style={styles.subTitletext}>Summary</Text>
            <Text style={styles.descriptionText}>Pampers Premium Care Pants is designed to provide the baby with the best skin protection. Approx. one million micropores help baby's skin breathe easily. Made with silky soft materials that keep baby’s skin comfortable, lotion with aloe vera protects the skin. These new pants are superior to ordinary pants and protect the baby’s delicate skin.</Text>
            <Text style={styles.subTitletext}> What is the use of Device ?</Text>
            <Text style={styles.descriptionText}>{'\u2022'}Come with three absorbing channels that distribute wetness evenly and lock it away better to keep the baby dry and comfortable from the very first touch</Text>
            <Text style={styles.descriptionText}>{'\u2022'}S-Curve design follows baby’s movement to protect from friction</Text>
            <Text style={styles.descriptionText}>{'\u2022'}Wetness Indicator turns yellow to blue, indicating when it’s time to change the diape</Text>
            <Text style={styles.descriptionText}>{'\u2022'}The disposable tape helps fold the diaper pants and seal them with the tape for easy disposal</Text>
            <Text style={styles.descriptionText}>{'\u2022'}The channels offer an easy airflow for breathable dryness</Text>
            <View>
                <Text style={styles.subTitletext}>How to Use?</Text>
                <Text style={styles.descriptionText}>{'\u2022'}Place your baby on her back on a changing table, washable pad or thick towel</Text>
                <Text style={styles.descriptionText}>{'\u2022'}Unfold a clean diaper and lay it on one side</Text>
                <Text style={styles.descriptionText}>{'\u2022'}To prevent diaper rash, let the area dry completely before putting on diaper cream and/or a clean diaper</Text>
                <Text style={styles.descriptionText}>{'\u2022'} Lift your baby’s legs and place the clean, unfolded diaper that you set aside earlier under his bottom</Text>
                <Text style={styles.descriptionText}>{'\u2022'}To remove: Tear both sides and pull the pants down</Text>
            </View>
            <View>
                <Text style={styles.subTitletext}>Manufacturer Details</Text>
                <Text style={styles.descriptionText}>Name: Procter & Gamble Hygiene and Health Care Ltd</Text>
                <Text style={styles.descriptionText}>Address: Procter & Gamble, India P&G plaza, Cardinal Gracias Road, Chakala, Andheri (E), Mumbai - 400099</Text>
                <Text style={styles.descriptionText}>Country of origin: India</Text>
                <Text style={styles.descriptionText}>Expires on or after: May, 2025</Text>
            </View>
        </View>
    )
}

export default DeviceDetails

const styles = StyleSheet.create({
    descriptionText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '300',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginVertical: 2,
        marginLeft: 3,
        lineHeight: Matrics.s(18)
    },
    deviceDetailsText: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.dimGray,
        marginTop: Matrics.s(30)
    },
    subTitletext: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginTop: Matrics.s(20),
        marginBottom: 10
    },
})