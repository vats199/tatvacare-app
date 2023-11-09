import { ScrollView, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native'
import React, { useState, useEffect } from 'react';
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { Container, Screen } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import CoupansForYou from '../../components/organisms/CoupansForYou';
import { Matrics } from '../../constants';
import { useApp } from '../../context/app.context';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import MyStatusbar from '../../components/atoms/MyStatusBar';


type ApplyCoupanScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'ApplyCoupan'
>;

const ApplyCoupanScreen: React.FC<ApplyCoupanScreenProps> = ({ route, navigation }) => {

    const [isFocused, setIsFocused] = useState<boolean>(false);
    const { setCoupan } = useApp();
    const insets = useSafeAreaInsets();
    const handleSelectedCoupan = (title: string) => {
        setCoupan(title);
        navigation.goBack();
    }
    const onPressApply = () => { };

    return (
        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(10) : insets.bottom }]}>
            <MyStatusbar />
            <ScrollView style={{ flex: 1 }} showsVerticalScrollIndicator={false}>
                <Header
                    title="Apply Coupan"
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.titleStyle}
                />
                <Container>
                    <View style={[styles.inputContainer, { borderColor: isFocused ? "black" : colors.inputBoxLightBorder }]}>
                        <TextInput placeholder='Enter the coupan code' onFocus={() => setIsFocused(true)} onBlur={() => setIsFocused(false)} />
                        <TouchableOpacity onPress={onPressApply}>
                            <Text style={styles.applyText}>Apply</Text>
                        </TouchableOpacity>
                    </View>
                    <CoupansForYou onApply={handleSelectedCoupan} />
                </Container>
            </ScrollView>
        </SafeAreaView>
    )
}

export default ApplyCoupanScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginHorizontal: Matrics.s(10),
        paddingVertical: Matrics.vs(15),
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20)
    },
    inputContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: "center",
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        backgroundColor: colors.white,
        borderRadius: Matrics.s(12),
        paddingHorizontal: Matrics.s(10),
        height: Matrics.vs(44)
    },
    applyText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.disableButton,
    }
})