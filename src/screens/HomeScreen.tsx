import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container } from '../components/styled/Views'

type HomeScreenProps = CompositeScreenProps<
    BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
    NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const HomeScreen: React.FC<HomeScreenProps> = ({ route, navigation }) => {

    return (
        <Container>
            <Text>HomeScreen</Text>
        </Container>
    )
}

export default HomeScreen

const styles = StyleSheet.create({})