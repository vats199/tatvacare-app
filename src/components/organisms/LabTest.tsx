import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';

type LabTestProp = {
    title: string,
    onAdded: (item: TestItem) => void,
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
            if (item.id === id) {
                onAdded(item);
                return { ...item, isAdded: true };
            }
            return item;
        });


        setOptions(updatedOptions);
    }



    const renderTestItem = (item: TestItem, index: number) => {


        return (
            <View style={styles.renderItemContainer} key={index}>
                <View style={{ width: "15%", marginLeft: 5 }}>
                    <Icons.LiverTest height={36} width={36} />
                </View>
                <View style={{ width: "85%" }}>
                    <Text style={styles.titleStyle}>{item.title} </Text>
                    <Text style={styles.description}>{item.description}</Text>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{item.newPrice}</Text>
                        <Text style={{ textDecorationLine: 'line-through' }}>{item.oldPrice}</Text>
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
                    <View style={styles.border} />
                </View>
            </View>
        );
    };
    return (
        <View>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 10 }}>
                <Text style={styles.title}> {title}</Text>
                <TouchableOpacity  >
                    <Text style={styles.textViewButton}>View all</Text>
                </TouchableOpacity>
            </View>

            <View style={styles.container}>
                {options.map(renderTestItem)}
            </View>

        </View>
    )
}

export default LabTest

const styles = StyleSheet.create({
    title: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray
    },
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
        marginVertical: 10
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
        color: colors.inactiveGray
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
        marginVertical: 10,
        width: "100%",
        borderWidth: 1,
        borderColor: colors.themePurple,
        padding: 6,
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
        borderBottomWidth: 1,
        borderBottomColor: "#D3D3D3"
    }

})