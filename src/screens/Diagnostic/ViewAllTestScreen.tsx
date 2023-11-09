import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import {

    DiagnosticStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import LabTest from '../../components/organisms/LabTest';
import { Fonts, Matrics } from '../../constants';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import { ScrollView } from 'react-native';


type ViewAllTestScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'ViewAllTest'
>;

const ViewAllTestScreen: React.FC<ViewAllTestScreenProps> = ({ route, navigation }) => {
    const insets = useSafeAreaInsets();

    const onPressBack = () => {
        navigation.goBack();
    }

    return (
        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]} >
            <MyStatusbar />
            <ScrollView showsVerticalScrollIndicator={false} style={{ flex: 1, }}>
                <Header
                    title="Liver Test"
                    isIcon={true}
                    icon={<Icons.Cart height={24} width={24} />}
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.titleStyle}
                    onBackPress={onPressBack}
                />
                <View style={{ marginHorizontal: 16 }}>
                    <LabTest title='Liver Test' />
                </View>
            </ScrollView>
        </SafeAreaView>
    )
}

export default ViewAllTestScreen

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,

    },
    upperHeader: {
        marginHorizontal: 15,
        paddingTop: Matrics.s(20),
        paddingBottom: Matrics.s(15)
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20),
    },
})