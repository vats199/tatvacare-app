import { StyleSheet, Text, View, FlatList } from 'react-native'
import React, { useState } from 'react';
import {
    DiagnosticStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { SafeAreaView } from 'react-native-safe-area-context';
import Button from '../../components/atoms/Button';
import SlotDetailsCard from '../../components/molecules/SlotDetailsCard';
import SlotButton from '../../components/atoms/SlotButton';

type SelectTestSlotScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'SelectTestSlot'
>;

type SlotDetailsType = {
    id: number;
    timeZone: string;
    slots: string[];
};


const SelectTestSlotScreen: React.FC<SelectTestSlotScreenProps> = ({ route, navigation }) => {

    const [selectedTime, setSelectedTime] = useState<String>("");

    const onPressBack = () => {
        navigation.goBack();
    }
    const onPressReviewDetails = () => {

        navigation.navigate("LabTestSummary");
    }
    const slots: SlotDetailsType[] = [
        {
            id: 1,
            timeZone: 'Morning',
            slots: [
                '05:30 - 07:30',
                '07:30 - 09:30',
                '05:30 - 07:30',
                '07:30 - 09:30',
            ],
        },
        {
            id: 2,
            timeZone: 'Afternoon',
            slots: [
                '05:30 - 07:30',
                '07:30 - 09:30',
                '05:30 - 07:30',
                '07:30 - 09:30',
            ],
        },
        {
            id: 3,
            timeZone: 'Evening',
            slots: [
                '05:30 - 07:30',
                '07:30 - 09:30',
                '05:30 - 07:30',
                '07:30 - 09:30',
            ],
        },
    ]

    const onPressTimeSlot = (item: string) => {
        setSelectedTime(item)
    }

    const renderSlots = (it: string, index: number) => {
        // const selectedTime =
        //     selectedTimeSlot?.timeZone === item.timeZone &&
        //     selectedTimeSlot?.time == it;
        console.log(it);
        return (
            <SlotButton
                title={it}
                onPress={() => onPressTimeSlot(it)}
                buttonStyle={{
                    backgroundColor: selectedTime ? colors.boxLightPurple : colors.white,
                    borderColor: selectedTime ? colors.darkBorder : colors.lightBorder,
                }}
                titleStyle={
                    selectedTime ? styles.activeTimeTxt : styles.inactiveTimeTxt
                }
            />
        );
    };

    const renderImage = (title: string) => {
        const imageHeight = Matrics.vs(35);
        const imageWidth = Matrics.s(35);
        switch (title) {
            case 'Morning':
                return <Icons.Morning height={imageHeight} width={imageWidth} />;
            case 'Afternoon':
                return <Icons.Afternoon height={imageHeight} width={imageWidth} />;
            case 'Evening':
                return <Icons.Moon height={imageHeight} width={imageWidth} />;
            default:
                return null;
        }
    };
    const renderSlot = (item: SlotDetailsType, index: number) => {
        return (
            <View style={[styles.container, styles.containerShadow]}>
                {renderImage(item.timeZone)}
                <View
                    style={{
                        marginLeft: Matrics.s(10),
                    }}>
                    <Text style={styles.timeZoneTxt}>{item.timeZone}</Text>
                    <View style={styles.slotWraper}>{item.slots.map(renderSlots)}</View>
                </View>
            </View>
        );
    }

    return (
        <SafeAreaView edges={['top']} style={styles.screen} >
            <Header
                title='Select Test Slot'
                isIcon={true}
                titleStyle={styles.titleStyle}
                containerStyle={styles.upperHeader}
                onBackPress={onPressBack}
            />

            <View>
                <Text style={styles.sampleText}>Sample Collection Time</Text>
                {slots.map(renderSlot)}
            </View>

            <View>
                <Button
                    title='Review Details'
                    onPress={onPressReviewDetails}
                />
            </View>
        </SafeAreaView>
    )
}

export default SelectTestSlotScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,

    },
    upperHeader: {
        margin: 20
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
    sampleText: {
        fontSize: Matrics.s(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20
    },
    container: {
        flexDirection: 'row',
        backgroundColor: colors.white,
        paddingHorizontal: Matrics.s(15),
        paddingTop: Matrics.s(10),
        borderRadius: Matrics.s(12),
        alignItems: 'flex-start',
        marginVertical: Matrics.s(8.5),
        marginHorizontal: Matrics.s(15),
    },
    containerShadow: {
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 3 },
        shadowOpacity: 0.08,
        shadowRadius: 8,
        elevation: 2,
    },
    timeZoneTxt: {
        fontFamily: Fonts.BOLD,
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        color: colors.labelDarkGray,
        marginVertical: Matrics.s(10),
    },
    slotWraper: {
        flexWrap: 'wrap',
        flexDirection: 'row',
        maxWidth: Matrics.s(250),
    },
    activeTimeTxt: {
        color: colors.black,
        fontWeight: '500',
    },
    inactiveTimeTxt: {
        color: colors.inactiveGray,
    },
    timeTxt: {
        fontFamily: Fonts.MEDIUM,
        fontSize: Matrics.mvs(12),
        lineHeight: Matrics.vs(14),
        color: colors.titleLightGray,
    },
    timeContainerSlot: {
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: Matrics.s(12),
        borderWidth: Matrics.s(1),
        paddingHorizontal: Matrics.s(7),
        paddingVertical: Matrics.vs(7),
        marginRight: Matrics.s(10),
        marginBottom: Matrics.vs(10),
    },
    timeContainerShadow: {
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 0 },
        shadowOpacity: 0.04,
        shadowRadius: 3,
        elevation: 1,
    },
})