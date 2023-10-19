import { StyleSheet, Text, View, TextInput } from 'react-native'
import React, { useState } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { Container, Screen } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
type SearchLabTestScreenProps = StackScreenProps<
DiagnosticStackParamList,
'SearchLabTest'
>;

type RecentSearchItem = {
    id?: number;
    title?: string;
    description?: string
}

const SearchLabTestScreen: React.FC<SearchLabTestScreenProps> = ({ route, navigation }) => {
    const [isFocused, setIsFocused] = useState<boolean>(false);
    const [searchItem, setSearchItem] = useState<string>();

    const options: RecentSearchItem[] = [
        {
            id: 1,
            title: 'MRI Brain',
            description: 'Related to brain',

        },
        {
            id: 2,
            title: 'MRI Brain',
            description: 'Related to brain',

        },
        {
            id: 3,
            title: 'MRI Brain',
            description: 'Related to brain',

        },
        {
            id: 4,
            title: 'MRI Brain',
            description: 'Related to brain',

        },
    ];

    const renderRecentSearch = (item: RecentSearchItem, index: number) => {
        return (
            <View style={styles.searchItem} key={index}>
                <View style={styles.circle} />
                <View>
                    <Text style={styles.recentSearchText}> {item.title}</Text>
                    <Text style={styles.descriptionText}>{item.description}</Text>
                </View>
            </View>
        );
    }
    return (
        <>
            <Screen>
                <View style={styles.header}>
                    <Icons.backArrow height={24} width={24} />
                    <View style={[styles.inputContainer, { borderColor: isFocused ? "black" : colors.inputBoxLightBorder }]}>
                        <TextInput placeholder='Search for lab test' onFocus={() => setIsFocused(true)} onBlur={() => setIsFocused(false)}
                            onChangeText={text => setSearchItem(text)}
                            value={searchItem} />
                    </View>
                </View>
                <View style={styles.searchContainer}>
                    <Text style={styles.titletext}> Recent Search</Text>
                    {options.map(renderRecentSearch)}
                </View>
            </Screen>
        </>
    )
}

export default SearchLabTestScreen

const styles = StyleSheet.create({
    header: {

        paddingTop: 30,
        paddingHorizontal: 20,
        flexDirection: 'row',
        alignItems: 'center'
    },
    inputContainer: {
        width: "90%",
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: 12,
        paddingHorizontal: 10,
        minHeight: 40,
        marginLeft: 10
    },
    searchContainer: {
        marginTop: 30,
        marginHorizontal: 10,

    },
    titletext: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 10
    },

    searchItem: {
        flexDirection: "row",
        alignItems: 'center',
        margin: 10
    },
    circle: {
        width: 35,
        height: 35,
        borderRadius: 17,
        backgroundColor: colors.white,
        marginRight: 10
    },
    recentSearchText: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    descriptionText: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
})