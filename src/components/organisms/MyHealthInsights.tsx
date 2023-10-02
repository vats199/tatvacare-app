import { Image, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React, { useEffect } from 'react'
import { colors } from '../../constants/colors'
import { Icons } from '../../constants/icons'
import { getEncryptedText } from '../../api/base'

type MyHealthInsightsProps = {
    data: any,
    onPressRow1: (filteredData:any, firstRow : any) => void
}

const MyHealthInsights: React.FC<MyHealthInsightsProps> = ({ data , onPressRow1 }) => {
    console.log(data?.readings_response,'data?.readings_responsedata?.readings_response');
    
    const [originalData, setOriginalData] =  React.useState<any>(data)
    const [filteredData, setFilteredData] = React.useState<any>([])

    useEffect(() => {
        filterData()
    }, [data])

    const filterData = () => {
        const combinedData = [ ...(data?.readings_response || []), ...(data?.goal_data || []), ]
console.log(data?.readings_response,'readings_responsereadings_response');

        let filteredArray = []
        console.log(combinedData,'combinedDatacombinedData-->>');
        
        for (let i = 0; i < combinedData.length; i = i + 2) {
            const firstElement = combinedData[i];
            const secondElement = combinedData[i + 1];
            filteredArray.push([firstElement, secondElement])
        }

        setFilteredData(filteredArray)
    }

    const getValue = (val: any) => {

        if (val || val == 0 && val !== '') {
            return parseInt(val);
        } else {
            return '-'
        }
    }


    return (
        <View style={styles.container}>
            <Text style={styles.title}>My Health Insights</Text>
            <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.scrollContainer}
                bounces={false}
            >
                {
                    filteredData?.length > 0 && filteredData.map((Orgdata: any, idx: number) => {
                        console.log();
                        
                        const firstRow = Orgdata[0];
                        const secondRow = Orgdata[1];
                        console.log(typeof filteredData,'filteredData');
                        
                        return (
                            <View style={styles.columnContainer} key={idx}>
                                <TouchableOpacity style={styles.hiItemContainerTop} onPress={()=>  { console.log(Orgdata[0],'readings_responsereadings_response=====+>');
                                 onPressRow1(data?.readings_response, firstRow.keys)}}>
                                    <View style={styles.row}>
                                        <Image resizeMode='contain' style={styles.imageStyle} source={{ uri: firstRow?.image_url || '' }} />
                                        <Text style={styles.hiItemTitle}>{firstRow?.goal_name || firstRow?.reading_name || '-'}</Text>
                                    </View>
                                    <View style={styles.valuesRow}>
                                        <Text style={styles.hiItemValue}>{getValue(firstRow?.goal_value || firstRow?.reading_value)}</Text>
                                        <Text style={styles.hiItemKey}>{firstRow?.keys}</Text>
                                    </View>
                                </TouchableOpacity>
                                {
                                    secondRow &&
                                    <TouchableOpacity style={styles.hiItemContainerBottom} onPress={() => onPressRow1(data?.readings_response, secondRow.keys)}>
                                        <View style={styles.row}>
                                            <Image resizeMode='contain' style={styles.imageStyle} source={{ uri: secondRow?.image_url || '' }} />
                                            <Text style={styles.hiItemTitle}>{secondRow?.goal_name || secondRow?.reading_name || '-'}</Text>
                                        </View>
                                        <View style={styles.valuesRow}>
                                            <Text style={styles.hiItemValue}>{getValue(secondRow?.goal_value || secondRow?.reading_value)}</Text>
                                            <Text style={styles.hiItemKey}>{secondRow?.keys}</Text>
                                        </View>
                                    </TouchableOpacity>
                                }
                            </View>
                        )
                    })
                }
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
    valuesRow: {
        flexDirection: 'row',
        alignItems: 'baseline',
        marginTop: 10,
        gap: 5
    },
    hiItemValue: {
        color: colors.black,
        fontWeight: '700',
        fontSize: 20,
    },
    hiItemKey: {
        color: colors.secondaryLabel,
        fontWeight: '400',
        fontSize: 12,
    },
    imageStyle: {
        height: 25,
        width: 25
    }
})