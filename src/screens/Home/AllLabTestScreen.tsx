import { StyleSheet, Text, View, TouchableOpacity, TextInput, ScrollView } from 'react-native'
import React, { useState } from 'react';
import { Container, Screen } from '../../components/styled/Views';
import {
    AppStackParamList,
    DrawerParamList,
    BottomTabParamList,
    HomeStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { CompositeScreenProps } from '@react-navigation/native';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import LabTest from '../../components/organisms/LabTest';
import { Fonts } from '../../constants';
import { useApp } from '../../context/app.context';

type AllLabTestProps = CompositeScreenProps<
    StackScreenProps<HomeStackParamList, 'AllLabTest'>,
    CompositeScreenProps<
        BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
        StackScreenProps<AppStackParamList, 'DrawerScreen'>
    >
>;
type TestItem = {
    id: number;
    title: string;
    description: string;
    newPrice: number;
    oldPrice: number;
    discount: number;
    isAdded: boolean;
};

const AllLabTestScreen: React.FC<AllLabTestProps> = ({ route, navigation }) => {
    const [addedCartItem, setAddedCartItem] = useState<TestItem[]>([]);

    const { location } = useApp();
    console.log(location);

    const handleItemAdded = (item: TestItem) => {

        setAddedCartItem((prevAddedItems) => [...prevAddedItems, item]);
    };
    console.log(addedCartItem);

    const addedItem = addedCartItem.length;
    console.log(addedItem);
    const iconPress = () => { };
    const onPressUploadPerscription = () => { };
    const onPressViewFreeTests = () => { };
    const onPressAdd = () => { };
    const onPressViewAll = () => { };
    const onBackPress = () => {
        navigation.goBack();
    }
    const onPressViewCart = () => {
        navigation.navigate("LabTestCart", { item: addedCartItem });
    }
    return (
        <>
            <View style={styles.screen}>
                <ScrollView>
                    <Header
                        title="All Lab test"
                        isIcon={true}
                        icon={<Icons.Cart height={24} width={24} />}
                        containerStyle={styles.upperHeader}
                        titleStyle={styles.titleStyle}
                        onIconPress={iconPress}
                        onBackPress={onBackPress}
                    />
                    <View style={styles.location}>
                        <Icons.Location />
                    </View>

                    <View style={{ flex: 1, paddingHorizontal: 15 }}>
                        <TouchableOpacity
                            style={styles.searchContainer}
                            activeOpacity={1}
                            onPress={() => {
                                navigation.navigate("SearchLabTest");
                            }}>
                            <Icons.Search />
                            {/* <TextInput placeholder='Search for Tests, Health Packages' /> */}
                            <Text> Search for Tests, Health Packages</Text>
                        </TouchableOpacity>
                        <View style={styles.perscription}>
                            <View style={{ flexDirection: "row", justifyContent: "space-between", alignItems: 'center' }}>
                                <Icons.MedicineBlack height={36} width={36} />
                                <View style={styles.textBox}>
                                    <Text style={styles.uploadPerscription}>Upload Prescription</Text>
                                    <Text style={styles.arrangeMedicine}>We Will Arrange Medicine For you</Text>
                                </View>
                            </View>
                            <View>
                                <Icons.forwardArrow height={12} width={12} onPress={onPressUploadPerscription} />
                            </View>
                        </View>
                        <View style={styles.freeTestBox}>

                            <Text style={styles.freeTestText}> Free Test Available for you</Text>
                            <View style={{ flexDirection: 'row', justifyContent: "space-between", flex: 1, alignItems: 'center' }}>
                                <View style={{ flex: 0.85 }}>
                                    <Text style={styles.freeText}>Since you are on paid plan you can get free test aslo done accor to your health</Text>
                                </View>
                                <TouchableOpacity style={{ flex: 0.15 }} onPress={onPressAdd} >
                                    <Text style={styles.textAddButton}> Add</Text>
                                </TouchableOpacity>
                            </View>
                            <TouchableOpacity onPress={onPressViewFreeTests} >
                                <Text style={styles.textViewButton}>View Free Test</Text>
                            </TouchableOpacity>

                        </View>

                        <LabTest title="Liver Test" onAdded={handleItemAdded} />
                        <LabTest title="Kindney Test" onAdded={handleItemAdded} />

                    </View>

                </ScrollView>
                {
                    (addedCartItem.length > 0) && (
                        <View style={styles.belowContainer}>
                            <View>
                                <Text>{addedItem} test added</Text>
                                <Text style={styles.textViewButton}> View Details</Text>
                            </View>
                            <TouchableOpacity style={styles.viewCartButton} onPress={onPressViewCart}>
                                <Text style={styles.viewCartText}>View cart</Text>
                            </TouchableOpacity>
                        </View>
                    )
                }

            </View>
        </>
    )
}

export default AllLabTestScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: "F9F9FF"
    },
    upperHeader: {
        marginHorizontal: 20,
        // marginTop:20,
        paddingVertical: 15,
        // marginBottom:5
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
    location: {
        backgroundColor: colors.white,
        height: 32,
        marginVertical: 15,
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 20
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: 12,
        paddingHorizontal: 10,
        marginBottom: 10,
        minHeight: 44

    },
    searchText: {
        color: colors.subTitleLightGray,
        marginLeft: 10,
    },
    perscription: {
        marginVertical: 5,
        padding: 10,
        backgroundColor: colors.white,
        borderRadius: 12,
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center',
        minHeight: 70,
    },
    textBox: {
        marginLeft: 10
    },
    uploadPerscription: {
        fontSize: 14,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray
    },
    arrangeMedicine: {
        color: colors.darkGray,
        fontSize: 12,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
    },
    freeTestBox: {
        marginVertical: 5,
        padding: 12,
        backgroundColor: colors.white,
        borderRadius: 12,
        minHeight: 110,
        width: '100%'

    },
    freeTestText: {
        fontSize: 14,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray
    },
    freeText: {
        color: colors.darkGray,
        fontSize: 12,
        fontWeight: "300",
        fontFamily: Fonts.BOLD,
        //marginVertical:5,
    },
    textAddButton: {
        fontSize: 12,
        fontWeight: '700',
        color: colors.themePurple,
        fontFamily: Fonts.BOLD,
        marginLeft: 18
    },
    textViewButton: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
    belowContainer: {
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center',
        paddingHorizontal: 15,
        paddingVertical: 10,
        backgroundColor: colors.white,

    },
    viewCartButton: {
        padding: 16,
        backgroundColor: colors.themePurple,
        borderRadius: 16,
    },
    viewCartText: {
        fontFamily: Fonts.BOLD,
        fontWeight: '700',
        fontSize: 16,
        color: colors.white
    },
    testAddedText: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray
    }

})