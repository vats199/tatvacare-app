import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
import { navigateTo } from '../../routes/Router'

type DrawerMoreProps = {}

const DrawerMore: React.FC<DrawerMoreProps> = ({ }) => {

    const onAccountSettingsPress = () => {
        navigateTo('AccountSettingVC')
     }
    const onHelpAndSupportPress = () => {
        navigateTo('HelpAndSupportVC')
     }

     


    return (
        <View style={styles.container}>
            <Text style={styles.headerText}>More</Text>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7} onPress={onAccountSettingsPress}>
                <View style={styles.icon}><Icons.DrawerAccountSettings /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Account Settings</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7} onPress={onHelpAndSupportPress}>
                <View style={styles.icon}><Icons.DrawerHelpSupport /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Help & Support</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7}>
                <View style={styles.icon}><Icons.DrawerAboutUs /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>About Us</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7}>
                <View style={styles.icon}><Icons.DrawerShareApp /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Share App</Text>
                </View>
            </TouchableOpacity>
            <TouchableOpacity style={styles.itemContainer} activeOpacity={0.7}>
                <View style={styles.icon}><Icons.DrawerRateApp /></View>
                <View style={styles.mhdItemTextContainer}>
                    <Text style={styles.mhdItemText}>Rate App</Text>
                </View>
            </TouchableOpacity>
        </View>
    )
}

export default DrawerMore

const styles = StyleSheet.create({
    container: {
        marginHorizontal: 10,
        marginVertical: 5,
        paddingVertical: 10,
        backgroundColor: colors.white,
        borderRadius: 12
    },
    headerText: {
        color: colors.black,
        fontSize: 14,
        fontWeight: '700',
        marginHorizontal: 10
    },
    itemContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: 5
    },
    icon: {
        marginVertical: 5,
        marginHorizontal: 10
    },
    mhdItemTextContainer: {
        flex: 1,
        borderBottomWidth: 0.5,
        borderBottomColor: colors.lightGrey,
        padding: 10,
    },
    mhdItemText: {

    },
})