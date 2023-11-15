import { StyleSheet, Text, View } from 'react-native';
import { Dimensions } from 'react-native';
import React, { useEffect } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';
import MyStatusbar from '../../components/atoms/MyStatusBar';
type CongratulationScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'CongratulationScreen'
>;


const CongratulationScreen: React.FC<CongratulationScreenProps> = ({ route, navigation }) => {

    const onPressContinue = () => {
        navigation.navigate("OrderDetails");
    }
    useEffect(() => {
        const timeout = setTimeout(() => {
            navigation.replace('OrderDetails');
        }, 2000);

        return () => clearTimeout(timeout);
    }, [navigation]);

    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <MyStatusbar />
            <View style={{ flex: 0.5 }} />
            <View style={{ flex: 1 }}>
                <View style={{ alignItems: "center" }}>
                    <Icons.Success height={80} width={80} />
                    <Text style={styles.congratulationText}>Congratulations</Text>
                </View>
                <View style={{ paddingHorizontal: 13 }}>
                    <Text style={styles.descriptiontext} numberOfLines={2} >Your payment is successful, and the phlebotomist will be  assigned to you before your sample pickup slot.</Text>
                    <Button
                        title="Continue"
                        buttonStyle={{ marginHorizontal: 0 }}
                        onPress={onPressContinue}
                    />
                </View>
                <View style={{ flex: 1 }} />
            </View>
        </SafeAreaView>
    )
}

export default CongratulationScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.white,
    },
    congratulationText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: 10
    },
    descriptiontext: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginBottom: Matrics.s(20),
        alignContent: 'center',
        textAlign: "center"
    }
})