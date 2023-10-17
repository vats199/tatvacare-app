import { StyleSheet, Text, View, Button, KeyboardAvoidingView, } from 'react-native'
import React, { useRef, useMemo, useCallback } from 'react';
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
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import { FloatingLabelInput } from 'react-native-floating-label-input';
// import MapView from 'react-native-maps';

type ConfirmLocationScreenProps = CompositeScreenProps<
    StackScreenProps<HomeStackParamList, 'ConfirmLocation'>,
    CompositeScreenProps<
        BottomTabScreenProps<BottomTabParamList, 'HomeScreen'>,
        StackScreenProps<AppStackParamList, 'DrawerScreen'>
    >
>;

const ConfirmLocationScreen: React.FC<ConfirmLocationScreenProps> = ({ route, navigation }) => {

    const bottomSheetModalRef = useRef<BottomSheetModal>(null);


    const snapPoints = useMemo(() => ['10%', '60%'], []);


    const handlePresentModalPress = useCallback(() => {
        bottomSheetModalRef.current?.present();
    }, []);
    const handleSheetChanges = useCallback((index: number) => {
        console.log('handleSheetChanges', index);
    }, []);

    const onPressBack = () => {
        navigation.goBack();
    }
    return (
        <View style={{ flex: 1 }}>
            <View style={styles.headerContainer}>
                <View style={styles.headerRow}>
                    <Icons.backArrow height={20} width={20} onPress={onPressBack} />
                    <Text style={styles.titleStyle}> Confirm Location</Text>
                </View>
            </View>
            <BottomSheetModalProvider>
                <View style={styles.container}>
                    <Button
                        onPress={handlePresentModalPress}
                        title="Present Modal"
                        color="black"
                    />
                    <BottomSheetModal
                        ref={bottomSheetModalRef}
                        index={1}
                        snapPoints={snapPoints}
                        onChange={handleSheetChanges}
                    >
                        <KeyboardAvoidingView style={styles.contentContainer} behavior="padding">
                            <Text style={styles.enterAddressTitle}>Enter Address </Text>
                            <View style={styles.border} />
                            <View style={{ padding: 20 }}>
                                <View style={styles.disclaimerBox}>
                                    <Text style={styles.disclaimerText}>Disclaimer: We need this information to deliver your product & for
                                        collecting test samples</Text>

                                </View>
                                <View style={{ padding: 50, flex: 1, backgroundColor: '#fff' }}>
                                    <FloatingLabelInput
                                        label="eneter pincode"
                                    // isPassword
                                    // customShowPasswordComponent={<Text>Show</Text>}
                                    // customHidePasswordComponent={<Text>Hide</Text>}
                                    />
                                </View>

                            </View>
                        </KeyboardAvoidingView>
                    </BottomSheetModal>
                </View>
            </BottomSheetModalProvider>
        </View >

    )
}

export default ConfirmLocationScreen

const styles = StyleSheet.create({
    headerContainer: {
        paddingTop: 40,
        paddingBottom: 20,
        paddingLeft: 20,
        backgroundColor: "white",
    },
    headerRow: {
        flexDirection: "row",
        alignItems: 'center',
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
    container: {
        flex: 1,
        padding: 24,
        justifyContent: 'center',
        backgroundColor: 'grey',
    },
    contentContainer: {
        flex: 1,
    },
    enterAddressTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
        marginBottom: 10
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: "#7D7D7D"
    },
    disclaimerBox: {
        padding: 5,
        borderWidth: 0.5,
        borderColor: "#7D7D7D",
        borderRadius: 12
    },
    disclaimerText: {
        fontSize: 10,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    }
})