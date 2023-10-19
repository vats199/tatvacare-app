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
import { Fonts } from '../../constants';
import { Container } from '../../components/styled/Views';


type ViewAllTestScreenProps = StackScreenProps<
    DiagnosticStackParamList,
    'ViewAllTest'
>;

const ViewAllTestScreen: React.FC<ViewAllTestScreenProps> = ({ route, navigation }) => {

    const onPressBack = () => {
        navigation.goBack();
    }
    return (
        <View style={styles.screen}>
            <Header
                title="Liver Test"
                isIcon={true}
                icon={<Icons.Cart height={24} width={24} />}
                containerStyle={styles.upperHeader}
                titleStyle={styles.titleStyle}
                onBackPress={onPressBack}
            />
            <Container>
                <LabTest title='Liver Test' />
            </Container>

        </View>
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
        paddingTop: 25,
        paddingBottom: 15
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
    },
})