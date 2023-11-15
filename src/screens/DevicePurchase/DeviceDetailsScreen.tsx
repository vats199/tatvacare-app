import { ScrollView, StyleSheet, Text, View, Dimensions, Image } from 'react-native'
import React, { useState, useRef } from 'react';
import { DevicePurchaseStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';
import { device } from './DeviceScreen';
import DeviceDetails from '../../components/molecules/DeviceDetails';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Matrics } from '../../constants';
import BottomViewCart from '../../components/molecules/BottomViewCart';
import CarouselShow from '../../components/molecules/CarouselShow';
import Button from '../../components/atoms/Button';


type DeviceDetailScreenProps = StackScreenProps<
    DevicePurchaseStackParamList,
    'DeviceDetail'
>;

const DeviceDetailsScreen: React.FC<DeviceDetailScreenProps> = ({ route, navigation }) => {

    const insets = useSafeAreaInsets();
    const [selectedItemsNumber, setSelectedItemsNumber] = useState<number>(1);
    const rupee = '\u20B9';
    const item: device | undefined = route.params?.item;

    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressIcon = () => { }
    const onPressViewCart = () => {
        navigation.navigate("CartScreen");
    }
    const itemPriceWithoutCommas = item?.newPrice?.replace(/,/g, '');
    const price = (Number(itemPriceWithoutCommas) * selectedItemsNumber);

    return (


        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]}  >
            <MyStatusbar />
            <ScrollView
                showsVerticalScrollIndicator={false}
                style={{ paddingHorizontal: 20 }}
            >
                <Header
                    isIcon={true}
                    icon={<Icons.Cart height={24} width={24} />}
                    containerStyle={styles.upperHeader}
                    onBackPress={onPressBack}
                    onIconPress={onPressIcon}
                />
                <CarouselShow />
                <Text style={styles.titleText}>{item?.title}</Text>
                <Text style={styles.brandText}>{item?.brand}</Text>
                <View style={styles.priceButtonRow}>
                    <View style={styles.priceRow}>
                        <Text style={styles.price}>{rupee}{item?.newPrice}</Text>
                        <Text style={{ textDecorationLine: 'line-through' }}>{rupee}{item?.oldPrice}</Text>
                        <Text style={styles.discount}> {item?.discount}% off</Text>
                    </View>
                    <View>
                        {
                            (selectedItemsNumber > 0) ? (
                                <View style={styles.addMinusButton}>
                                    <Icons.Minus height={16} width={16}
                                        onPress={() => setSelectedItemsNumber(selectedItemsNumber - 1)}
                                    />
                                    <Text style={styles.selectedItemstext}>{selectedItemsNumber}</Text>
                                    <Icons.Add height={16} width={16}
                                        onPress={() => setSelectedItemsNumber(selectedItemsNumber + 1)}
                                    />
                                </View>
                            ) : (
                                <Button
                                    title="Add To Cart"
                                    buttonStyle={styles.buttonStyle}
                                    titleStyle={styles.buttonText}
                                    onPress={() => setSelectedItemsNumber(selectedItemsNumber + 1)}
                                />
                            )
                        }

                    </View>
                </View>
                <DeviceDetails />
            </ScrollView>
            {
                selectedItemsNumber > 0 && (
                    <BottomViewCart
                        price={price}
                        selectedNumber={selectedItemsNumber}
                        onPressViewCart={onPressViewCart}
                    />
                )
            }
        </SafeAreaView>

    )
}

export default DeviceDetailsScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,

    },
    upperHeader: {
        marginTop: 10,
        marginBottom: 20
    },
    titleText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: 6,
        lineHeight: 20
    },
    brandText: {
        fontSize: 12,
        fontWeight: '300',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    priceButtonRow: {
        width: "100%",
        flexDirection: 'row',
        justifyContent: "space-between",
        marginTop: Matrics.vs(10)
    },
    priceRow: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    price: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        lineHeight: 20,
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
        marginLeft: 10,
        lineHeight: 14.32,
        marginTop: 4
    },
    addMinusButton: {
        minWidth: 97,
        minHeight: 38,
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
    buttonStyle: {
        marginHorizontal: 0,
        paddingHorizontal: 10,
        paddingVertical: 10,
        marginVertical: 8,
        backgroundColor: 'white',
        borderColor: colors.themePurple,
        borderWidth: 1,
        minHeight: 36,
        minWidth: 97
    },
    buttonText: {
        fontSize: 12,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        lineHeight: 16,
        textAlign: 'center',
    },

})