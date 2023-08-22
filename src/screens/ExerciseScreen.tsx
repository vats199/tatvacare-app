import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { CompositeScreenProps } from '@react-navigation/native'
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs'
import { AppStackParamList, BottomTabParamList } from '../interface/Navigation.interface'
import { NativeStackScreenProps } from '@react-navigation/native-stack'
import { Container } from '../components/styled/Views'

type ExerciseScreenProps = CompositeScreenProps<
  BottomTabScreenProps<BottomTabParamList, 'ExerciseScreen'>,
  NativeStackScreenProps<AppStackParamList, 'BottomTabs'>
>

const ExerciseScreen: React.FC<ExerciseScreenProps> = ({ route, navigation }) => {
  return (
    <Container>
      <Text>ExerciseScreen</Text>
    </Container>
  )
}

export default ExerciseScreen

const styles = StyleSheet.create({})