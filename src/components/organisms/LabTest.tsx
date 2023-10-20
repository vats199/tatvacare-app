import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';

type LabTestProp = {
    title: string,
    onAdded?: (item: TestItem) => void,

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
const LabTest: React.FC<LabTestProp> = ({ title, onAdded }) => {

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
    ]);
    //console.log(options);

    const addCartHandler = (id: number) => {
        const updatedOptions = options.map((item) => {
            if (item.id === id && item.isAdded === false) {
                if (onAdded) {
                    onAdded(item);
                }
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
                    <Text style={styles.titleStyle}>{item.title} </Text>
                    <Text style={styles.description}>{item.description}</Text>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{rupee}{item.newPrice}</Text>
                        <Text style={{ textDecorationLine: 'line-through' }}>{rupee}{item.oldPrice}</Text>
                        <Text style={styles.discount}> {item.discount}% off</Text>
                    </View>
                    <TouchableOpacity
                        style={[styles.addCartButton, item.isAdded && styles.addedButton]}
                        onPress={() => addCartHandler(item?.id)}
                    >
                        {
                            item.isAdded ? (<Text style={styles.addedText}> Added</Text>) : <Text style={styles.addCartText}> Add to Cart</Text>
                        }
                    </TouchableOpacity>
                    {
                        (item.id < options.length) && (
                            <View style={styles.border} />
                        )
                    }
                </View>
            </View>
        );
    };
    return (
        <View style={{ flex: 1 }}>

            <View style={styles.container}>
                {options.map(renderTestItem)}
            </View>

        </View>
    )
}

export default LabTest

const styles = StyleSheet.create({

    textViewButton: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },
    container: {
        flex: 1,
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 10,
        marginVertical: 10,
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    renderItemContainer: {
        width: '100%',
        flexDirection: 'row',
        marginVertical: 10
    },
    titleStyle: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 5
    },
    description: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
        marginBottom: 5
    },
    priceRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: 5
    },
    price: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginRight: 10
    },
    oldPrice: {
        fontSize: 12,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    discount: {
        fontSize: 14,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.green,
        marginLeft: 10
    },
    addCartButton: {
        marginTop: 10,
        marginBottom: 15,
        width: "100%",
        borderWidth: 1,
        borderColor: colors.themePurple,
        paddingHorizontal: 6,
        paddingVertical: 8,
        borderRadius: 12,
        justifyContent: 'center',
        alignItems: 'center'
    },
    addedButton: {
        borderColor: colors.darkGray,
    },
    addCartText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple
    },
    addedText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: "#999999"
    }

})