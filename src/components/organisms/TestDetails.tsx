import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React from 'react'
import { FlatList } from 'react-native-gesture-handler';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';

type TestItem = {
    id: number;
    title: string;
    description: string;
    newPrice: number;
    oldPrice: number;
    discount: number;
    isAdded: boolean;
};

type TestDetailsProps = {
    data: TestItem[];
}

const TestDetails: React.FC<TestDetailsProps> = ({ data }) => {

    console.log("hye there", data);
    const renderCartItem = (item: TestItem, index: number) => {
        return (

            <View style={styles.renderItemContainer}>
                <View style={{ width: "15%", marginLeft: 5 }}>
                    <Icons.Liver height={36} width={36} />
                </View>
                <View style={{ width: '85%', }}>
                    <View style={styles.rightContainer}>
                        <View>
                            <Text style={styles.titleStyle}>{item.title}</Text>
                            <Text style={styles.reportText}>reported by date</Text>
                        </View>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: "center", marginRight: 20 }}>
                            <Text>{item.newPrice}</Text>
                            <Icons.Delete height={15} width={15} style={{ marginLeft: 10 }} />
                        </View>
                    </View>
                    <View style={styles.border} />
                </View>
            </View>


        );
    }
    return (
        <View >
            <Text style={styles.title}>TestDetails</Text>

            <View style={styles.container}>
                {data && data.map(renderCartItem)}
                <TouchableOpacity
                    style={styles.addCartButton}

                >
                    <Text style={styles.addCartText}> Add more test</Text>

                </TouchableOpacity>
            </View>


        </View>
    )
}

export default TestDetails

const styles = StyleSheet.create({
    title: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray
    },
    container: {
        backgroundColor: 'white',
        borderRadius: 12,
        padding: 10,
        marginVertical: 10
    },
    renderItemContainer: {
        width: '100%',
        flexDirection: 'row',
        marginVertical: 10
    },
    rightContainer: {

        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: "center"
    },
    border: {
        borderBottomWidth: 1,
        borderBottomColor: "#D3D3D3",
        marginTop: 10
    },
    addCartButton: {
        marginVertical: 10,
        width: "100%",
        borderWidth: 1,
        borderColor: colors.themePurple,
        padding: 6,
        borderRadius: 12,
        justifyContent: 'center',
        alignItems: 'center'
    },
    addCartText: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple
    },
    titleStyle: {
        fontSize: 14,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 5
    },
    reportText: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.purple
    },
})