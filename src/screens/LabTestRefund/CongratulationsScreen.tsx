import { StyleSheet, Text, View } from 'react-native'
import React, { useEffect } from 'react';
import { LabTestRefundStackParamList } from '../../interface/Navigation.interface';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import Button from '../../components/atoms/Button';
import { SafeAreaView } from 'react-native-safe-area-context';
import { StackScreenProps } from '@react-navigation/stack';
import MyStatusbar from '../../components/atoms/MyStatusBar';


type CongratulationsScreenProps = StackScreenProps<
    LabTestRefundStackParamList,
    'CongratulationsScreen'
>;


const CongratulationsScreen: React.FC<CongratulationsScreenProps> = ({ route, navigation }) => {

    useEffect(() => {
        const timeout = setTimeout(() => {
            navigation.replace('LabTestScreen');
        }, 5000);

        return () => clearTimeout(timeout);
    }, [navigation]);
    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <MyStatusbar />
            <View style={{ flex: 0.5 }} />
            <View style={{ flex: 1 }}>
                <View style={{ alignItems: "center" }}>
                    <Icons.Success height={80} width={80} />
                    <Text style={styles.congratulationText}>Congratulations!</Text>
                </View>
                <View style={{ paddingHorizontal: 13 }}>
                    <Text style={styles.descriptiontext}>Your booking has been rescheduled.</Text>
                    <Button
                        title="Continue"
                        buttonStyle={{ marginHorizontal: 0 }}
                        titleStyle={styles.buttonText}
                    />
                </View>
                <View style={{ flex: 1 }} />
            </View>



        </SafeAreaView>
    )
}

export default CongratulationsScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    congratulationText: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginVertical: Matrics.s(10),
        lineHeight: Matrics.s(20),
        textAlign: "center"
    },
    descriptiontext: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginBottom: Matrics.s(20),
        alignContent: 'center',
        textAlign: "center"
    },
    buttonText: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.white,
        lineHeight: Matrics.s(20)
    }
})