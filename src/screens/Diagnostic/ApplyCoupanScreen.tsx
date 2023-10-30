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

type ApplyCoupanScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'ApplyCoupan'
>;

const ApplyCoupanScreen: React.FC<ApplyCoupanScreenProps> = ({ route, navigation }) => {

    const [isFocused, setIsFocused] = useState<boolean>(false);
    const [selectedCoupan, setSelectedCoupan] = useState<string>('');

    useEffect(() => {
        if (selectedCoupan.length > 0) {
            navigation.navigate("LabTestCart", { coupan: selectedCoupan });
        }
    }, [selectedCoupan]);

    const handleSelectedCoupan = (title: string) => {
        setSelectedCoupan(title);

    }
    console.log(selectedCoupan);
    const onPressApply = () => {
        navigation.navigate("LabTestCart", { coupan: selectedCoupan });
    }

    return (
        <>
            <Screen>
                <ScrollView style={{ flex: 1 }}>
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
            </Screen >
        </>
    )
}

export default ApplyCoupanScreen

const styles = StyleSheet.create({
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
        minHeight: Matrics.vs(44)
    },
    applyText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.disableButton,
    }
})