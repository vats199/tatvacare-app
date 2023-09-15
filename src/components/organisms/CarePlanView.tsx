import { Alert, StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
import ProgressBar from '../atoms/ProgressBar'
import { TouchableOpacity } from 'react-native-gesture-handler'


type CarePlanViewProps = {
    onPressCarePlan: () => void
}

const CarePlanView: React.FC<CarePlanViewProps> = ({onPressCarePlan }) => {
    return (
        <TouchableOpacity onPress={onPressCarePlan }>
            <View style={styles.container}>
                    <View style={styles.details}>
                        <Text style={styles.title}>Care Plan Name</Text>
                        <Text style={styles.subTitle}>Bundled with diagnostic tests and monitoring devices.</Text>
                        <ProgressBar progress={30}/>
                        <Text style={styles.expiry}>Expire on July 30th 2023</Text>
                    </View>
                    <Icons.CarePlan />
            </View>
        </TouchableOpacity>
    )
}

export default CarePlanView

const styles = StyleSheet.create({
    container:{
        marginVertical: 10,
        backgroundColor: colors.white,
        borderRadius: 12,
        padding: 10,
        flexDirection:'row'
    },
    details:{
        flex:1,
        marginRight: 5,
    },
    title:{
        color: colors.labelDarkGray,
        fontWeight: '700',
        fontSize: 14
    },
    subTitle:{
        color: colors.subTitleLightGray,
        fontWeight: '400',
        fontSize: 10
    },
    expiry:{
        color: colors.darkGray,
        fontSize: 12,
        fontWeight: '400'
    },
})