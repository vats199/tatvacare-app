import { StyleSheet, Text, View } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';

type testInclude = {
    id?: number;
    title?: string;
}

const TestIncluded: React.FC = () => {

    const options: testInclude[] = [
        {
            id: 1,
            title: "HBA"
        },
        {
            id: 2,
            title: "Total Cholesterol"
        },
        {
            id: 3,
            title: "Total Cholesterol"
        },
        {
            id: 4,
            title: "Total Cholesterol"
        },
        {
            id: 5,
            title: "Total Cholesterol"
        },
        {
            id: 6,
            title: "Total Cholesterol"
        },
        {
            id: 7,
            title: "Total Cholesterol"
        },
        {
            id: 8,
            title: "Total Cholesterol"
        },
        {
            id: 9,
            title: "Total Cholesterol"
        },
        {
            id: 10,
            title: "Total Cholesterol"
        },
        {
            id: 11,
            title: "Total Cholesterol"
        },
        {
            id: 12,
            title: "Total Cholesterol"
        },
        {
            id: 13,
            title: "Total Cholesterol"
        },
    ]

    const renderTestInclude = (item: testInclude, index: number) => {
        return (
            <Text style={styles.testTitle}>{'\u2022'}  {item.title}</Text>
        );
    }
    return (
        <View style={styles.container} >
            {options.map(renderTestInclude)}
        </View>
    )
}

export default TestIncluded

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: colors.white,
        padding: 10,
        borderRadius: 12,
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
        marginTop: 10,

    },
    testTitle: {
        fontSize: 14,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginVertical: 5,
        marginLeft: 10
    }
})