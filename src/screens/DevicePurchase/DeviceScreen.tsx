import { ScrollView, StyleSheet, View } from 'react-native'
import React, { useEffect, useState } from 'react';
import { DevicePurchaseStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';
import DeviceItems from '../../components/organisms/DeviceItems';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import BottomViewCart from '../../components/molecules/BottomViewCart';
import { Matrics } from '../../constants';
type DeviceScreenProps = StackScreenProps<
    DevicePurchaseStackParamList,
    'DeviceScreen'
>;
type cartItem = {
    id: number;
    quantity: number;
}

export type device = {
    id: number;
    title?: string;
    brand?: string;
    description?: string;
    newPrice?: string;
    oldPrice?: string;
    discount?: number
}
const DeviceScreen: React.FC<DeviceScreenProps> = ({ route, navigation }) => {

    const [addedCartItem, setAddedCartItem] = useState<cartItem[]>([]);
    const [price, setPrice] = useState<number>(0);
    const [numberOfItems, setNumberOfItems] = useState<number>(0);
    const insets = useSafeAreaInsets();

    useEffect(() => {
        options.map(item => {
            addedCartItem.map(cartItem => {
                if (item.id === cartItem.id) {
                    const itemPriceWithoutCommas = item.newPrice?.replace(/,/g, '');
                    let number = price + (Number(itemPriceWithoutCommas) * cartItem.quantity);
                    setPrice(number);
                    setNumberOfItems(numberOfItems + 1);

                }
            })
        })
    }, [addedCartItem])

    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressIcon = () => { }

    const onPressViewCart = () => {
        navigation.navigate("CartScreen");
    }
    const handleAddCartItem = (item: cartItem[]) => {
        setAddedCartItem(item);
    }

    const onPressImage = (id: number) => {
        const selectedItem: device | undefined = options.find((item) => item.id === id);
        navigation.navigate("DeviceDetail", { item: selectedItem });
    }

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
        {
            id: 2,
            title: "Contec Digital Color Spirometer Pulmonary Function Lung Volume Devic...",
            brand: 'brand',
            description: "SPIROMETER is a hand-held equipment for checking lung conditions.",
            newPrice: '1,078',
            oldPrice: '2,695',
            discount: 40,
        },
        {
            id: 3,
            title: "Contec Digital Color Spirometer Pulmonary Function Lung Volume Devic...",
            brand: 'brand',
            description: "SPIROMETER is a hand-held equipment for checking lung conditions.",
            newPrice: '1,078',
            oldPrice: '2,695',
            discount: 40,
        },
    ]

    return (
        <>
            <MyStatusbar />
            <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(46) : insets.bottom }]}  >
                <ScrollView>
                    <Header
                        title="Device"
                        isIcon={true}
                        icon={<Icons.Cart height={24} width={24} />}
                        containerStyle={styles.upperHeader}
                        titleStyle={styles.titleStyle}
                        onIconPress={onPressIcon}
                        onBackPress={onPressBack}
                    />
                    <View style={styles.location}>
                        <Icons.Location height={16} width={16} />
                    </View>
                    <DeviceItems
                        onPressImage={onPressImage}
                        data={options}
                        onAdded={handleAddCartItem}
                    />
                </ScrollView>
                {
                    addedCartItem.length > 0 && (
                        <BottomViewCart
                            price={price}
                            onPressViewCart={onPressViewCart}
                            selectedNumber={numberOfItems}
                        />
                    )
                }
            </SafeAreaView >
        </>
    )
}

export default DeviceScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,

    },
    upperHeader: {
        marginHorizontal: 20,
        marginTop: 30,
        marginBottom: 20
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
    },
    location: {
        backgroundColor: colors.white,
        height: Matrics.vs(36),
        marginBottom: Matrics.s(10),
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: Matrics.s(20),
    },

})