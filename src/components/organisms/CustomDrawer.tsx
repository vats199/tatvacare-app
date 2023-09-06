import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { DrawerContentComponentProps, DrawerContentScrollView, DrawerItemList } from '@react-navigation/drawer'
import { colors } from '../../constants/colors'
import DrawerUserInfo from '../molecules/DrawerUserInfo'
import DrawerMyHealthDiary from '../molecules/DrawerMyHealthDiary'
import DrawerBookings from '../molecules/DrawerBookings'
import DrawerMore from '../molecules/DrawerMore'

const CustomDrawer = (props: DrawerContentComponentProps) => {
    return (
        <View style={styles.screen}>
            <DrawerContentScrollView {...props} contentContainerStyle={styles.container}>
                <DrawerUserInfo />
                <DrawerMyHealthDiary />
                <DrawerBookings />
                <DrawerMore />
                <Text style={styles.version}>Version 1.0</Text>
            </DrawerContentScrollView>
        </View>
    )
}

export default CustomDrawer

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: '#F9F9FF'
    },
    container: {
        backgroundColor: '#F9F9FF',
    },
    version: {
        color: colors.inactiveGray,
        textAlign: 'center',
        paddingVertical: 10
    },
})