import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import { device } from '../../screens/DevicePurchase/DeviceScreen';

const CartItems: React.FC = () => {
    const rupee = '\u20B9';
    const options: device[] = [
        {
            id: 1,
            title: "Contec Digital Color Spirometer Pulmonary Function Lung Volume Devic...",
            brand: 'brand',
            description: "SPIROMETER is a hand-held equipment for checking lung conditions.",
            newPrice: '1,078',
            oldPrice: '2,695',
            discount: 40,
        },


    ]
    const renderCartItem = (item: device, index: number) => {
        return (
            <View key={index} style={styles.itemContainer} >
                <View style={{ width: '25%' }}>
                    <View style={styles.box} />
                </View>
                <View style={{ width: '45%', marginHorizontal: 7 }}>
                    <Text numberOfLines={3} style={styles.title} >{item.title} </Text>
                    <Text style={styles.brandText}>{item.brand} </Text>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{rupee}{item.newPrice}</Text>
                        <Text style={[{ textDecorationLine: 'line-through' }, styles.oldPrice]}>{rupee}{item.oldPrice}</Text>

                    </View>
                </View>
                <View style={{ width: '30%' }}>
                    <View style={styles.addMinusButton}>
                        <Icons.Minus height={16} width={16} />
                        <Text>1</Text>
                        <Icons.Add height={16} width={16} />
                    </View>
                </View>
            </View>
        );
    }

    return (
        <View>
            {options.map(renderCartItem)}
        </View>
    )
}

export default CartItems

const styles = StyleSheet.create({
    itemContainer: {
        width: '100%',
        flexDirection: 'row',
        marginVertical: 14,
        minHeight: 120,
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 10,
        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    title: {
        fontSize: 12,
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: 16
    },
    box: {
        minWidth: 40,
        minHeight: 58,
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: "#E0E0E0",
        borderRadius: 12,

        elevation: 0.4,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    addMinusButton: {
        minWidth: 87,
        minHeight: 38,
        marginRight: 60,
        marginTop: 15,
        backgroundColor: colors.white,
        flexDirection: 'row',
        justifyContent: "space-around",
        alignItems: "center",
        borderWidth: 1,
        borderColor: colors.themePurple,
        padding: 5,
        borderRadius: 12,

    },
    priceRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: 10,
    },
    price: {
        fontSize: 14,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: 18,
        marginRight: 10,
    },
    oldPrice: {
        fontSize: 10,
        fontWeight: "300",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    brandText: {
        fontSize: 12,
        fontWeight: '300',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
})