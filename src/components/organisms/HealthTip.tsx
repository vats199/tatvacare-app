import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'

const HealthTip = () => {
    return (
        <View style={styles.container}>
            <Icons.LightBulb />
            <Text style={styles.text}>Being overweight or obese can lead to health conditions, such as type 2 diabetes, certain cancers, heart disease and stroke.</Text>
        </View>
    )
}

export default HealthTip

const styles = StyleSheet.create({
    container:{
        marginVertical: 10,
        backgroundColor: colors.purple,
        borderRadius:12,
        padding: 10,
        flexDirection:'row'
    },
    text:{
        color: colors.white,
        flex:1,
        fontSize:12,
        fontWeight: '400',
        marginLeft: 10
    },
})