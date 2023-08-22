import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container } from '../components/styled/Views'

type ProgramsScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'ProgramsScreen'>,
  NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const ProgramsScreen: React.FC<ProgramsScreenProps> = ({ route, navigation }) => {
  return (
    <Container>
      <Text>ProgramsScreen</Text>
    </Container>
  )
}

export default ProgramsScreen

const styles = StyleSheet.create({})