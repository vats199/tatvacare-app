import { StyleSheet, Text, View, TouchableOpacity } from 'react-native';
import React, { useState } from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../atoms/Button';
import { device } from '../../screens/DevicePurchase/DeviceScreen';
import { Matrics } from '../../constants';

type cartItem = {
    id: number;
    quantity: number;
}

type DeviceItemsProps = {
    onPressImage?: (id: number) => void;
    data: device[];
    onAdded: (item: cartItem[]) => void;
};

const DeviceItems: React.FC<DeviceItemsProps> = ({ onPressImage, data, onAdded }) => {
    const [selectedId, setSelectedId] = useState<cartItem[]>([]);

    const rupee = '\u20B9';

    const imagePressHandler = (id: number) => {
        if (id) {
            onPressImage?.(id);
        }
    };

    const addedCartHandler = (id: number, selectedNumber: number) => {

        if (selectedNumber === 0) {
            const updatedSelectedId = selectedId.filter((item) => item.id !== id);
            setSelectedId(updatedSelectedId);
            onAdded(updatedSelectedId)
        } else {
            const existingItem = selectedId.find((item) => item.id === id);

            if (existingItem) {
                const updatedSelectedId = selectedId.map((item) =>
                    item.id === id
                        ? { id: item.id, quantity: selectedNumber }
                        : item
                );

                setSelectedId(updatedSelectedId);
                onAdded(updatedSelectedId)
            } else {
                const updatedSelectedId = [...selectedId, { id, quantity: selectedNumber }];
                setSelectedId(updatedSelectedId);
                onAdded(updatedSelectedId);
            }
        }
    };



    const renderDeviceItems = (item: device, index: number) => {

        const [abc, setAbc] = useState<number>(1);

        return (
            <View key={index} style={styles.itemContainer}>
                <View style={{ width: '35%' }}>
                    <TouchableOpacity style={styles.box} onPress={() => imagePressHandler(item.id)}>
                    </TouchableOpacity>
                </View>
                <View style={{ width: '65%', marginLeft: 10 }}>
                    <Text style={styles.titleText} numberOfLines={3}>
                        {item.title}
                    </Text>
                    <Text style={styles.brandText}>{item.brand}</Text>
                    <Text style={styles.descriptionText}>{item.description}</Text>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{rupee}{item.newPrice}</Text>
                        <Text style={{ textDecorationLine: 'line-through' }}>{rupee}{item.oldPrice}</Text>
                        <Text style={styles.discount}>{item.discount}% off</Text>
                    </View>
                    {
                        selectedId.find((Item) => Item.id === item.id) ?
                            (
                                <View style={styles.addMinusButton}>
                                    <Icons.Minus
                                        height={16} width={16}
                                        onPress={() => {
                                            const updatedAbc = abc - 1;
                                            setAbc(updatedAbc);
                                            addedCartHandler(item.id, updatedAbc);
                                        }}
                                    />
                                    <Text style={styles.selectedItemstext}>{abc}</Text>
                                    <Icons.Add height={16} width={16}
                                        onPress={() => {
                                            const updatedAbc = abc + 1;
                                            setAbc(updatedAbc);
                                            addedCartHandler(item.id, updatedAbc);
                                        }}
                                    />
                                </View>
                            ) : (
                                <Button
                                    title="Add To Cart"
                                    buttonStyle={styles.buttonStyle}
                                    titleStyle={styles.buttonText}
                                    onPress={() => addedCartHandler(item.id, 1)}
                                />
                            )

                    }
                </View>
            </View>
        );
    };

    return (
        <View style={{ paddingHorizontal: 20 }}>
            {data.map(renderDeviceItems)}
        </View>
    );
};

export default DeviceItems;

const styles = StyleSheet.create({
    itemContainer: {
        width: '100%',
        flexDirection: 'row',
        marginVertical: Matrics.vs(10),
        minHeight: 240,
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 12,
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    box: {
        minWidth: Matrics.s(90),
        minHeight: Matrics.vs(108),
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: "#E0E0E0",
        borderRadius: 12,
        marginVertical: 6,
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    titleText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: 6,
        lineHeight: 18,
    },
    brandText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '300',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    descriptionText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '300',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginVertical: 5,
        lineHeight: 16,
    },
    priceRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: 10,
    },
    price: {
        fontSize: Matrics.mvs(16),
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: 20,
        marginRight: 10,
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
        marginLeft: 10,
        lineHeight: 14.32,
        marginTop: 4,
    },
    buttonStyle: {
        marginHorizontal: 0,
        marginRight: 60,
        marginVertical: 8,
        backgroundColor: 'white',
        borderColor: colors.themePurple,
        borderWidth: 1,
        minHeight: 36,
    },
    buttonText: {
        fontSize: 12,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        lineHeight: 16,
        textAlign: 'center',
    },
    addMinusButton: {
        minWidth: 87,
        minHeight: 38,
        marginRight: 60,
        marginVertical: 8,
        backgroundColor: colors.white,
        flexDirection: 'row',
        justifyContent: "space-around",
        alignItems: "center",
        borderWidth: 1,
        borderColor: colors.themePurple,
        padding: 5,
        borderRadius: 12,
    },
    selectedItemstext: {
        fontSize: Matrics.mvs(14),
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        lineHeight: 18,
        textAlign: "center"
    },
});
