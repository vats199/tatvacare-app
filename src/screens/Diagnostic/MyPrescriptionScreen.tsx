import { Pressable, StyleSheet, Text, View, Image, ScrollView } from 'react-native'
import React, { useState } from 'react';
import {
    DiagnosticStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';

type MyPerscriptionScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'MyPerscription'
>;
type perscription = {
    id: number;
    date?: any;
    uri?: string;
}
const MyPrescriptionScreen: React.FC<MyPerscriptionScreenProps> = ({ route, navigation }) => {

    const [selectedId, setSelectedId] = useState<number[]>([]);
    const data: perscription[] = route.params?.data;

    const onPressAdd = () => { }

    const handleSelectedId = (id: number) => {
        if (selectedId.includes(id)) {
            setSelectedId(selectedId.filter((item) => item !== id))
        } else { setSelectedId([...selectedId, id]); }
    }

    console.log("data>>>>>", data);

    const onPressBack = () => {
        navigation.goBack();
    }



    const renderPerscription = (item: perscription, index: number) => {
        return (
            <View style={{ marginTop: 10, marginBottom: 5 }} key={index}>
                <Text style={styles.addedONDate}>{item.date}</Text>
                <Pressable style={{ position: 'relative', width: 90, height: 108, backgroundColor: "white", borderColor: 'red' }} onPress={() => handleSelectedId(item?.id)}  >
                    <Image source={{ uri: item.uri }} style={{ width: '100%', height: '100%' }} />

                    {
                        (selectedId.includes(item.id)) && (
                            <Icons.Success style={{ position: 'absolute', right: -5, top: -5 }} />
                        )
                    }
                </Pressable>
            </View>
        );
    }
    return (
        <SafeAreaView edges={['top']} style={styles.screen}>


            <View style={{ borderBottomWidth: 2, elevation: 2, borderBottomColor: '#F9F9FF' }}>
                <Header
                    title="My Prescription"
                    isIcon={true}
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.titleStyle}
                    onBackPress={onPressBack}
                />
            </View>
            <ScrollView style={{ paddingLeft: 20, flex: 1 }}>
                {data?.map(renderPerscription)}

            </ScrollView>
            {
                (selectedId) && (
                    <View style={{ backgroundColor: "white", padding: 10 }}>
                        <Button
                            title="Add"
                            buttonStyle={styles.outlinedButton}
                            onPress={onPressAdd}
                        />
                    </View>
                )
            }
        </SafeAreaView>
    )
}

export default MyPrescriptionScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        justifyContent: "space-between",
        marginBottom: 20
    },
    upperHeader: {
        marginHorizontal: 20,
        marginTop: 30,
        marginBottom: 20
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.dimGray,
        marginLeft: 20,
    },
    addedONDate: {
        fontSize: 14,
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        marginVertical: 10
    },
    outlinedButton: {
        padding: 10,
        borderRadius: 16,
        backgroundColor: colors.themePurple,
        marginHorizontal: 0
    },
})