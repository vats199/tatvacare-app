import { StyleSheet, Text, View } from 'react-native';
import { Dimensions } from 'react-native';
import React from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';
type CongratulationScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'CongratulationScreen'
>;

const windowHeight = Dimensions.get('window').height;
const CongratulationScreen: React.FC<CongratulationScreenProps> = ({ route, navigation }) => {

    const onPressContinue = () => {
        navigation.navigate("OrderDetails");
    }

    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <View style={{ marginTop: windowHeight / 2 - 100 }}>
                <View style={{ alignItems: "center" }}>
                    <Icons.Success height={80} width={80} />
                    <Text style={styles.congratulationText}>Congratulations</Text>
                </View>
                <View style={{ paddingHorizontal: 13 }}>
                    <Text style={styles.descriptiontext}>Your payment is successful, and the phlebotomist will be  assigned to you before your sample pickup slot.</Text>
                    <Button
                        title="Continue"
                        buttonStyle={{ marginHorizontal: 0 }}
                        onPress={onPressContinue}
                    />
                </View>
            </View>



        </SafeAreaView>
    )
}

export default CongratulationScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
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
        marginBottom: 10,
        alignContent: 'center'
    }
})