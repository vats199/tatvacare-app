import { Dimensions, Image, ScrollView, StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
import ProgressBar from '../atoms/ProgressBar'
import moment from 'moment'

type CarePlanViewProps = {
    data?: any
}

const CarePlanView: React.FC<CarePlanViewProps> = ({ data }) => {
    const getPlanProgress = (plan: any) => {
        if (plan?.plan_end_date && plan?.plan_start_date) {
            const planDuration = moment(plan?.plan_end_date).diff(plan?.plan_start_date, 'days') //duration of plan in days

            const completedPlanDuration = moment(new Date()).diff(plan?.plan_start_date, 'days') //completed plan duration in days

            if (completedPlanDuration >= 0 && planDuration > 0) {
                return (completedPlanDuration / planDuration) * 100
            } else {
                return 0
            }

        } else {
            return 0
        }
    }
    return (
        <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            bounces={false}
        >
            {
                data?.patient_plans?.length > 0 && data?.patient_plans?.map((plan: any, planIdx: number) => {

                    return (
                        <View key={planIdx} style={styles.container}>
                            <View style={styles.details}>
                                <Text style={styles.title}>{plan?.plan_name || '-'}</Text>
                                <Text style={styles.subTitle}>{plan?.sub_title || '-'}</Text>
                                <ProgressBar progress={getPlanProgress(plan) || 0} />
                                <Text style={styles.expiry}>Expires on {plan?.plan_end_date ? moment(plan?.plan_end_date).format('MMMM Do yyyy') : '-'}</Text>
                            </View>
                            {
                                plan?.image_url ?
                                    <Image resizeMode='contain' style={styles.image} source={{ uri: plan?.image_url }} />
                                    :
                                    <Icons.CarePlan />
                            }
                        </View>

                    )
                })

            }
        </ScrollView>
    )
}

export default CarePlanView

const styles = StyleSheet.create({
    container: {
        marginVertical: 10,
        backgroundColor: colors.white,
        borderRadius: 12,
        padding: 10,
        display: 'flex',
        flexDirection: 'row',
        alignItems: 'center',
        minWidth: Dimensions.get('screen').width - 45
    },
    details: {
        marginRight: 5,
        display: 'flex',
        flexDirection: 'column',
        flex: 1,
    },
    title: {
        color: colors.labelDarkGray,
        fontWeight: '700',
        fontSize: 14
    },
    subTitle: {
        color: colors.subTitleLightGray,
        fontWeight: '400',
        fontSize: 10,
    },
    expiry: {
        color: colors.darkGray,
        fontSize: 12,
        fontWeight: '400'
    },
    image: {
        width: 80,
        height: 60,
    }
})