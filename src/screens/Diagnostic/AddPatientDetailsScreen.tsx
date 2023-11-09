import { ScrollView, StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React, { useState } from 'react'
import {
    DiagnosticStackParamList
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import DropdownComponent from '../../components/atoms/Dropdown';
import Button from '../../components/atoms/Button';
import { Matrics } from '../../constants';


type AddPatientDetailsScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'AddPatientDetails'
>;

const data = [
    { label: 'Item 1', value: '1' },
    { label: 'Item 2', value: '2' },
    { label: 'Item 3', value: '3' },
];
const AddPatientDetailsScreen: React.FC<AddPatientDetailsScreenProps> = ({ route, navigation }) => {


    const [selectedAge, setSelectedAge] = useState<string>();
    const [selectedRelation, setSelectedRelation] = useState<string>();
    const [enteredName, setEnteredName] = useState<string>();
    const [enteredEmail, setEnteredEmail] = useState<string>();
    const [isMale, setIsMale] = useState<boolean>(false);
    const [isFemale, setIsFemale] = useState<boolean>(false);
    console.log(enteredName);

    const color = (selectedAge && selectedRelation && enteredEmail && enteredName && (isMale || isFemale)) ? colors.themePurple : colors.darkGray;



    const handleSelectedAge = (item: string) => {
        setSelectedAge(item);
    }
    const handleSelectedRelation = (item: string) => {
        setSelectedRelation(item);
    }
    const handleEnteredName = (item: string) => {
        setEnteredName(item);
    }
    const handleEnteredEmail = (item: string) => {
        setEnteredEmail(item);
    }

    const handleMaleSelection = () => {
        setIsMale((prev) => !prev);
        setIsFemale(false);
    }
    const handleFemaleSelection = () => {
        setIsFemale((prev) => !prev);
        setIsMale(false);
    }
    console.log(isMale);

    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressSave = () => {
        navigation.navigate("LabTestCart");
    }
    return (
        <ScrollView style={{ flex: 1, backgroundColor: '#F9F9FF', padding: 15 }} showsVerticalScrollIndicator={false}>
            <View style={styles.upperHeader}>
                <Icons.backArrow height={24} width={24} onPress={onPressBack} />
                <Text style={styles.headerText}>Add Patients Details</Text>
            </View>
            <View style={{ marginVertical: 8 }}>
                <DropdownComponent
                    data={data}
                    placeholder='relation'
                    placeholderStyle={styles.placeholderText} dropdownStyle={{ marginRight: 0 }}
                    selectedItem={handleSelectedRelation}
                />
                <Text style={styles.messageText}>Select the relation with name of the account </Text>
            </View>
            <View style={{ marginVertical: 8 }}>
                <AnimatedInputField
                    placeholder='Name'
                    style={styles.inputStyle} textStyle={styles.placeholderText}
                    placeholderTextColor={colors.inactiveGray}
                    onChangeText={handleEnteredName}
                />
            </View>
            <View style={{ marginVertical: 8 }}>
                <AnimatedInputField
                    placeholder='Email'
                    style={styles.inputStyle}
                    textStyle={styles.placeholderText} placeholderTextColor={colors.inactiveGray}
                    onChangeText={handleEnteredEmail}
                />
                <Text style={styles.messageText}>User will receive updates of order status and soft copy of reports on this email address </Text>
            </View>
            <View style={{ marginVertical: 8 }}>
                <DropdownComponent
                    data={data}
                    placeholder='Age'
                    placeholderStyle={styles.placeholderText} dropdownStyle={{ marginRight: 0 }}
                    selectedItem={handleSelectedAge}
                />

            </View>
            <View style={{ marginTop: 8 }}>
                <Text style={styles.genderText}> Gender</Text>
                <View style={styles.genderBoxes}>
                    <TouchableOpacity
                        style={[styles.genderBox, { marginRight: 10 }, isMale && { backgroundColor: "#3B0859" }]}
                        onPress={handleMaleSelection}
                    >
                        <Icons.MaleIcon height={24} width={24} />
                        <Text style={styles.maleFemaleText}>Male</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        style={[styles.genderBox, isFemale && { backgroundColor: "#3B0859" }]}
                        onPress={handleFemaleSelection}
                    >
                        <Icons.FemaleIcon height={24} width={24} />
                        <Text style={styles.maleFemaleText}>Female</Text>
                    </TouchableOpacity>
                </View>
            </View>

            <View style={{ marginTop: 50 }}>
                <Button
                    title="Save"
                    titleStyle={styles.outlinedButtonText}
                    buttonStyle={{ ...styles.outlinedButton, backgroundColor: color }}
                    onPress={onPressSave}
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
        backgroundColor: colors.darkGray,
        marginHorizontal: 0
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