import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React, { useEffect, useRef, useState } from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container } from '../components/styled/Views'
import { Icons } from '../constants/icons'

type HomeScreenProps = CompositeScreenProps<
    BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
    NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {

    return (
        <Container style={styles.headerContainer}>
            <View>
                <Icons.MyTatvaLogo />
                <TouchableOpacity activeOpacity={0.6} style={styles.locationContainer}>
                    <Text>Location</Text>
                    <Icons.Dropdown />
                </TouchableOpacity>
            </View>
        </Container>
    )
}

export default HomeScreen

const styles = StyleSheet.create({
    headerContainer: {
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    locationContainer: {
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        gap: 5
    }
})