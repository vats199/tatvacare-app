import { ScrollView, StyleSheet, Text, View } from 'react-native'
import React from 'react'
import {
    AppStackParamList,
    DrawerParamList,
    BottomTabParamList,
    HomeStackParamList,
} from '../../interface/Navigation.interface';
import { Container, Screen } from '../../components/styled/Views';
import { StackScreenProps } from '@react-navigation/stack';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import { CompositeScreenProps } from '@react-navigation/native';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import DropdownComponent from '../../components/atoms/Dropdown';
import Button from '../../components/atoms/Button';

type AddPatientDetailsScreenProps = CompositeScreenProps<
    StackScreenProps<HomeStackParamList, 'AddPatientDetails'>,
    CompositeScreenProps<
        BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
        StackScreenProps<AppStackParamList, 'DrawerScreen'>
    >
>;
const AddPatientDetailsScreen: React.FC<AddPatientDetailsScreenProps> = ({ route, navigation }) => {
    const data = [
        { label: 'Item 1', value: '1' },
        { label: 'Item 2', value: '2' },
        { label: 'Item 3', value: '3' },
    ];
    return (
        <ScrollView style={{ flex: 1, backgroundColor: '#F9F9FF', padding: 15 }}>
            <View style={styles.upperHeader}>
                <Icons.backArrow height={24} width={24} />
                <Text style={styles.headerText}>Add Patients Details</Text>
            </View>
            <View style={{ marginVertical: 8 }}>
                <DropdownComponent data={data} placeholder='relation' placeholderStyle={styles.placeholderText} />
                <Text style={styles.messageText}>Select the relation with name of the account </Text>
            </View>
            <View style={{ marginVertical: 8 }}>
                <AnimatedInputField placeholder='Name' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} />
            </View>
            <View style={{ marginVertical: 8 }}>
                <AnimatedInputField placeholder='Email' style={styles.inputStyle} textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray} />
                <Text style={styles.messageText}>User will receive updates of order status and soft copy of reports on this email address </Text>
            </View>
            <View style={{ marginVertical: 8 }}>
                <DropdownComponent data={data} placeholder='Age' placeholderStyle={styles.placeholderText} />
            </View>
            <View style={{ marginTop: 8 }}>
                <Text style={styles.genderText}> Gender</Text>
                <View style={styles.genderBoxes}>
                    <View style={[styles.genderBox, { marginRight: 10 }]}>
                        <Icons.MaleIcon height={24} width={24} />
                        <Text style={styles.maleFemaleText}>Male</Text>
                    </View>
                    <View style={styles.genderBox}>
                        <Icons.FemaleIcon height={24} width={24} />
                        <Text style={styles.maleFemaleText}>Female</Text>
                    </View>
                </View>
            </View>

            <View style={{ marginTop: 50 }}>
                <Button
                    title="Save"
                    titleStyle={styles.outlinedButtonText}
                    buttonStyle={styles.outlinedButton}

                />
            </View>
        </ScrollView>
    )
}

export default AddPatientDetailsScreen;

const styles = StyleSheet.create({
    upperHeader: {
        flexDirection: "row",
        alignItems: 'center',
        marginVertical: 20,

    },
    headerText: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 10
    },
    inputStyle: {
        backgroundColor: 'white',
        height: 44,
        borderColor: '#E0E0E0',
        borderWidth: 1.3,
        borderRadius: 14,
        paddingHorizontal: 8,

    },
    messageText: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    outlinedButtonText: {
        fontSize: 18,
        fontWeight: 'bold',
    },
    outlinedButton: {
        padding: 10,
        borderRadius: 16,
        backgroundColor: colors.darkGray
    },
    genderText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 6
    },
    genderBoxes: {
        flexDirection: "row",
        justifyContent: 'space-around',
        alignItems: "center",
        width: '100%'
    },
    genderBox: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        width: '48%',
        padding: 10,
        backgroundColor: 'white',
        height: 44,
        borderColor: '#E0E0E0',
        borderWidth: 1,
        borderRadius: 12,

    },
    maleFemaleText: {
        fontSize: 12,
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    },
    placeholderText: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    }

})