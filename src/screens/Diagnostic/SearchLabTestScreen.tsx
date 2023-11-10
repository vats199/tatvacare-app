import { StyleSheet, Text, View, TextInput } from 'react-native'
import React, { useState } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import MyStatusbar from '../../components/atoms/MyStatusBar';

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
    const insets = useSafeAreaInsets();

    const onPressBack = () => {
        navigation.goBack();
    }

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
        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]}>
            <MyStatusbar />
            <View style={styles.header}>
                <Icons.backArrow height={24} width={24} onPress={onPressBack} />
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
        </SafeAreaView>

    )
}

export default SearchLabTestScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    header: {
        width: "100%",
        paddingTop: Matrics.s(20),
        paddingHorizontal: Matrics.s(20),
        flexDirection: 'row',
        alignItems: 'center'
    },
    inputContainer: {
        width: "90%",
        borderWidth: 1,
        backgroundColor: colors.white,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: Matrics.s(12),
        paddingHorizontal: Matrics.mvs(10),
        heighteight: Matrics.vs(44),
        marginLeft: Matrics.s(10)
    },
    searchContainer: {
        marginTop: Matrics.s(30),
        marginHorizontal: Matrics.s(10),

    },
    titletext: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: Matrics.s(10)
    },

    searchItem: {
        flexDirection: "row",
        alignItems: 'center',
        margin: Matrics.s(10)
    },
    circle: {
        width: Matrics.s(35),
        height: Matrics.vs(35),
        borderRadius: Matrics.s(17),
        backgroundColor: colors.white,
        marginRight: Matrics.s(10)
    },
    recentSearchText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    descriptionText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
})