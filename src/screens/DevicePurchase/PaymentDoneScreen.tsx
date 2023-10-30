import { StyleSheet, Text, View } from 'react-native'
import React, { useEffect } from 'react';
import { DevicePurchaseStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Matrics } from '../../constants';

type PaymentDoneScreenProps = StackScreenProps<
    DevicePurchaseStackParamList,
    'PaymentDone'
>;

const PaymentDoneScreen: React.FC<PaymentDoneScreenProps> = ({ route, navigation }) => {
    const insets = useSafeAreaInsets();

    useEffect(() => {
        const timeout = setTimeout(() => {
            navigation.replace('DevicesScreen');
        }, 2000);

        return () => clearTimeout(timeout);
    }, [navigation]);
    return (
        <SafeAreaView edges={['top']}
            style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]}
        >
            <MyStatusbar />
            <View style={styles.centerStyle}>
                <Icons.Success height={80} width={80} />
                <Text style={styles.textStyle}>Payment Done Successful ! </Text>
            </View>
        </SafeAreaView>
    )
}

export default PaymentDoneScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        justifyContent: 'center',
        alignItems: "center"
    },
    centerStyle: {
        justifyContent: 'center',
        alignItems: "center"
    },
    textStyle: {
        fontSize: Matrics.mvs(20),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        lineHeight: Matrics.vs(28),
        marginTop: Matrics.s(10)
    }
})