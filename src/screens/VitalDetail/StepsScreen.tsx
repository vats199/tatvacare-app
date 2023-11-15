import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react';
import { VitalDetailStackParamList } from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';
import { Icons } from '../../constants/icons';
import MyStatusbar from '../../components/atoms/MyStatusBar';
import Header from '../../components/atoms/Header';

type StepsScreenProps = StackScreenProps<
    VitalDetailStackParamList,
    'StepsScreen'
>;

const StepsScreen: React.FC<StepsScreenProps> = ({ route, navigation }) => {
    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <MyStatusbar />
            <View style={styles.headerContainer}>
                <Header
                    title='Steps'
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.headerTitle}
                    isIcon={true}
                    icon={<Icons.AddCircle height={24} width={24} />}
                />
            </View>
            <ScrollView style={{ padding: Matrics.s(15) }}>
                <View style={styles.buttonContainer}>
                    <TouchableOpacity>
                        <Text>Day</Text>
                    </TouchableOpacity>
                    <TouchableOpacity>
                        <Text>Week</Text>
                    </TouchableOpacity>
                    <TouchableOpacity>
                        <Text>Month</Text>
                    </TouchableOpacity>
                </View>
            </ScrollView>
        </SafeAreaView>
    )
}

export default StepsScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    headerContainer: {
        paddingVertical: Matrics.s(5),
        borderBottomWidth: 0.1,
        borderBottomColor: '#ccc',
        shadowColor: colors.black,
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.08,
        shadowRadius: Matrics.s(8),
        elevation: 2,
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
    buttonContainer: {
        width: "100%",
        flexDirection: "row",
        justifyContent: "space-evenly",
        marginVertical: Matrics.vs(10),
        backgroundColor: colors.white,

    }
})