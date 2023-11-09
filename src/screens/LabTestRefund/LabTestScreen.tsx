import { StyleSheet, Text, View } from 'react-native'
import React, { useRef, useState } from 'react';
import { LabTestRefundStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { Icons } from '../../constants/icons';
import Header from '../../components/atoms/Header';
import ScheduleLabTest from '../../components/organisms/ScheduleLabTest';
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import CancelLabTestBottomSheet from '../../components/molecules/CancelLabTestBottomSheet';

type LabTestScreenProps = StackScreenProps<
    LabTestRefundStackParamList,
    'LabTestScreen'
>;

export type labTest = {
    id: number;
    amountPaid?: string;
    title?: string;
    orderId?: string;
    appointmentOn?: string;
    time?: string;
    status?: "finished" | "unfinished" | "cancelled";
}


const LabTestScreen: React.FC<LabTestScreenProps> = ({ route, navigation }) => {
    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedItem, setSelectedItem] = useState<number>(0);

    const [labTestOptions, setLabTestOptions] = useState<labTest[]>([
        {
            id: 1,
            amountPaid: '2,296',
            title: "Test Name,Test Name",
            orderId: "VL219630",
            appointmentOn: "Fri, 08 Jul, 2022",
            time: "09:30 - 10:30",
            status: "unfinished"
        },
        {
            id: 2,
            amountPaid: '2,296',
            title: "Test Name,Test Name",
            orderId: "VL219630",
            appointmentOn: "Fri, 08 Jul, 2022",
            time: "09:30 - 10:30",
            status: "finished"
        }
    ]);

    const onPressCancel = (id: number) => {
        setSelectedItem(id);
        bottomSheetModalRef.current?.present();
    }

    const onPressBack = () => {
        navigation.goBack();
    }

    const onPressLabTest = () => {
        navigation.navigate("OrderDetails");
    }

    const onPressReschedule = () => {
        navigation.navigate("SelectTestSlot");
    }

    const onCancel = (id: number) => {

        bottomSheetModalRef.current?.close();
        setLabTestOptions((prevLabTestOptions) => {
            return prevLabTestOptions.map((item) => {
                if (item.id === id) {
                    return { ...item, status: "cancelled" };
                }
                return item;
            });
        });
    }


    console.log(labTestOptions);
    console.log("selecteditem", selectedItem);
    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <MyStatusbar />
            <Header
                title='Lab Test'
                containerStyle={styles.upperHeader}
                titleStyle={styles.headerTitle}
                onBackPress={onPressBack}
            />
            <ScheduleLabTest
                data={labTestOptions}
                onPressCancel={onPressCancel}
                onPressItem={onPressLabTest}
                onPressReschedule={onPressReschedule}
            />
            <CommonBottomSheetModal snapPoints={['42%']} ref={bottomSheetModalRef}>
                <CancelLabTestBottomSheet id={selectedItem} onCancel={onCancel} />
            </CommonBottomSheetModal>
        </SafeAreaView>
    )
}

export default LabTestScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginTop: Matrics.s(25),
        marginBottom: Matrics.s(10),
        marginHorizontal: Matrics.s(20)
    },
    headerTitle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20),
    },
})