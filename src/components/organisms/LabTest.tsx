import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts, Matrics } from '../../constants';
import AsyncStorage from '@react-native-async-storage/async-storage';

type LabTestProp = {
    title: string,
    onAdded?: (item: TestItem) => void,
    onPressTest?: () => void,
}
type TestItem = {
    id: number;
    title: string;
    description: string;
    newPrice: number;
    oldPrice: number;
    discount: number;
    isAdded: boolean;
};
const LabTest: React.FC<LabTestProp> = ({ title, onAdded, onPressTest }) => {

    const rupee = '\u20B9';

    const [options, setOptions] = useState<TestItem[]>([
        {
            id: 1,
            title: 'Fitgen',
            description: 'Also known as Genetic Risk assessment for obesity',
            newPrice: 1078,
            oldPrice: 2695,
            discount: 40,
            isAdded: false,
        },
        {
            id: 2,
            title: 'Fitgen',
            description: 'Also known as Genetic Risk assessment for obesity',
            newPrice: 1078,
            oldPrice: 2695,
            discount: 40,
            isAdded: false,
        },
        {
            id: 3,
            title: 'Fitgen',
            description: 'Also known as Genetic Risk assessment for obesity',
            newPrice: 1078,
            oldPrice: 2695,
            discount: 40,
            isAdded: false,
        },
        {
            id: 4,
            title: 'Fitgen',
            description: 'Also known as Genetic Risk assessment for obesity',
            newPrice: 1078,
            oldPrice: 2695,
            discount: 40,
            isAdded: false,
        },
        {
            id: 5,
            title: 'Fitgen',
            description: 'Also known as Genetic Risk assessment for obesity',
            newPrice: 1078,
            oldPrice: 2695,
            discount: 40,
            isAdded: false,
        },

    ]);


    const handleCartItem = async (item: TestItem) => {
        try {
            const cart = await AsyncStorage.getItem('cartItems');
            let cartItems: TestItem[] = [];
            if (cart !== null) {
                cartItems = JSON.parse(cart) || [];
            }
            const existingItem = cartItems.find((cartItem: TestItem) => cartItem.id === item.id);
            if (!existingItem) {
                cartItems.push(item);
            }
            await AsyncStorage.setItem('cartItems', JSON.stringify(cartItems));
        } catch (error) {
            console.error('Error handling cart item:', error);
        }
    }

    const addCartHandler = (id: number) => {
        const updatedOptions = options.map((item) => {
            if (item.id === id && item.isAdded === false) {
                if (onAdded) {
                    onAdded(item);
                }
                handleCartItem(item);
                return { ...item, isAdded: true };
            }
            return item;
        });
        setOptions(updatedOptions);
    }

    const renderTestItem = (item: TestItem, index: number) => {
        return (
            <View style={styles.renderItemContainer} key={index}>
                <View style={{ width: "15%" }}>
                    {
                        title === 'Liver Test' ? <Icons.Liver /> : <Icons.Kidney />
                    }
                </View>
                <View style={{ width: "85%" }}>
                    <TouchableOpacity onPress={onPressTest}>
                        <Text style={styles.titleStyle}>{item.title} </Text>
                    </TouchableOpacity>
                    <Text style={styles.description}>{item.description}</Text>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{rupee}{item.newPrice}</Text>
                        <Text style={[styles.oldPrice, { textDecorationLine: 'line-through' }]}>{rupee}{item.oldPrice}</Text>
                        <Text style={styles.discount}> {item.discount}% off</Text>
                    </View>
                    <TouchableOpacity
                        style={[styles.addCartButton, item.isAdded && styles.addedButton]}
                        onPress={() => addCartHandler(item?.id)}
                    >
                        {
                            item.isAdded ? (<Text style={styles.addedText}> Added</Text>) : <Text style={styles.addCartText}> Add To Cart</Text>
                        }
                    </TouchableOpacity>
                    <View style={{ width: '100%' }}>
                        {
                            (index < options.length - 1) && (
                                <View style={styles.border} />
                            )
                        }
                    </View>
                </View>
            </View>
        );
    };
    return (
        <View style={styles.container}>
            {options.map(renderTestItem)}
        </View>
    );
}

export default LabTest;

const styles = StyleSheet.create({
    textViewButton: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
    container: {
        // flex: 1,
        backgroundColor: 'white',
        borderRadius: Matrics.s(12),
        padding: Matrics.s(10),
        marginVertical: Matrics.s(10),
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    renderItemContainer: {
        width: '100%',
        flexDirection: 'row',
        marginVertical: Matrics.s(10)
    },
    titleStyle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: Matrics.s(18),
        marginBottom: Matrics.s(5)
    },
    description: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
        marginBottom: Matrics.s(5)
    },
    priceRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: Matrics.s(5)
    },
    price: {
        fontSize: Matrics.mvs(16),
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginRight: Matrics.s(10)
    },
    oldPrice: {
        fontSize: Matrics.mvs(12),
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    discount: {
        fontSize: Matrics.mvs(14),
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.green,
        marginLeft: Matrics.s(10)
    },
    addCartButton: {
        marginTop: Matrics.s(10),
        marginBottom: Matrics.s(15),
        width: "100%",
        borderWidth: 1,
        borderColor: colors.themePurple,
        paddingHorizontal: Matrics.s(6),
        paddingVertical: Matrics.vs(8),
        borderRadius: Matrics.s(12),
        justifyContent: 'center',
        alignItems: 'center'
    },
    addedButton: {
        borderColor: colors.darkGray,
    },
    addCartText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple
    },
    addedText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: colors.secondaryLabel
    }
})