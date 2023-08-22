import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container } from '../components/styled/Views'

type LearnScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'LearnScreen'>,
  NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const LearnScreen: React.FC<LearnScreenProps> = ({ route, navigation }) => {
  return (
    <Container>
      <Text>LearnScreen</Text>
    </Container>
  )
}

export default LearnScreen

const styles = StyleSheet.create({})