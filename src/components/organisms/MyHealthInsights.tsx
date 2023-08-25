import { ScrollView, StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'

type MyHealthInsightsProps = {}

const MyHealthInsights: React.FC<MyHealthInsightsProps> = ({ }) => {

    return (
        <View style={styles.container}>
            <Text style={styles.title}>My Health Insights</Text>
            <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.scrollContainer}
                bounces={false}
            >
                <View style={styles.columnContainer}>
                    <View style={styles.hiItemContainerTop}>
                        <View style={styles.row}>
                            <Icons.RedLung />
                            <Text style={styles.hiItemTitle}>FEV1</Text>
                        </View>

                    </View>
                    <View style={styles.hiItemContainerBottom}>
                        <View style={styles.row}>
                            <Icons.GreenMoon />
                            <Text style={styles.hiItemTitle}>Sleep</Text>
                        </View>
                    </View>
                </View>
                <View style={styles.columnContainer}>
                    <View style={styles.hiItemContainerTop}>
                        <View style={styles.row}>
                            <Icons.GreenWalking />
                            <Text style={styles.hiItemTitle}>Six-Min Walk</Text>
                        </View>
                    </View>
                    <View style={styles.hiItemContainerBottom}>
                        <View style={styles.row}>
                            <Icons.GreenWalking />
                            <Text style={styles.hiItemTitle}>Steps</Text>
                        </View>
                    </View>
                </View>
                <View style={styles.columnContainer}>
                    <View style={styles.hiItemContainerTop}>
                        <View style={styles.row}>
                            <Icons.PEF />
                            <Text style={styles.hiItemTitle}>PEF</Text>
                        </View>
                    </View>
                    <View style={styles.hiItemContainerBottom}>
                        <View style={styles.row}>
                            <Icons.WaterGlass />
                            <Text style={styles.hiItemTitle}>Water</Text>
                        </View>
                    </View>
                </View>
            </ScrollView>
        </View>
    )
}

export default MyHealthInsights

const styles = StyleSheet.create({
    container: {
        marginVertical: 10,
    },
    title: {
        color: colors.black,
        fontWeight: '700',
        fontSize: 16
    },
    scrollContainer: {
        paddingVertical: 10
    },
    hiItemContainerTop: {
        marginBottom: 5,
        backgroundColor: colors.white,
        borderRadius: 12,
        padding: 10,
        minWidth: 150,
        minHeight: 86
    },
    hiItemContainerBottom: {
        marginTop: 5,
        backgroundColor: colors.white,
        borderRadius: 12,
        padding: 10,
        minWidth: 150,
        minHeight: 86
    },
    columnContainer: {
        marginRight: 10
    },
    row: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    hiItemTitle: {
        flex: 1,
        color: colors.black,
        fontWeight: '700',
        fontSize: 12,
        marginLeft: 5
    },
})