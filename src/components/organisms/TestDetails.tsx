import { StyleSheet, Text, View, TouchableOpacity } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';


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
    data?: TestItem[];
    title?: string;
    onPressDelete?: (id: number) => void;
}
const TestDetails: React.FC<TestDetailsProps> = ({ data, title, onPressDelete }) => {

    const deleteHandler = (id: number) => {
        if (onPressDelete) {
            onPressDelete(id);
        }
    }

    const rupee = '\u20B9';

    const renderIcon = (
        title: string
    ) => {
        switch (title) {
            case 'Fitgen':
                return <Icons.Liver height={36} width={36} />
            case 'Lipid Profile':
                return <Icons.Heart height={36} width={36} />
            case "COPD":
                return <Icons.Kidney height={36} width={36} />

            case 'Fitgen Endo':
                return <Icons.Liver height={36} width={36} />
        }
    }
    const renderCartItem = (item: TestItem, index: number) => {

        return (
            <View style={styles.renderItemContainer}>
                <View style={{ width: "15%", marginLeft: 5 }}>
                    {renderIcon(item.title)}
                </View>
                <View style={{ width: '85%', }}>
                    <View style={styles.rightContainer}>
                        <View>
                            <Text style={styles.titleStyle}>{item.title}</Text>
                            <Text style={styles.reportText}>reported by date</Text>
                        </View>
                        <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: "center", marginRight: 20 }}>
                            <Text>{rupee}{item.newPrice}</Text>
                            {
                                (title === 'Test Details') && (
                                    <Icons.Delete height={15} width={15} style={{ marginLeft: 10 }} onPress={() => deleteHandler(item.id)} />
                                )
                            }
                        </View>
                    </View>
                    {
                        (data && data.length > 0 && index < data.length - 1) && (
                            <View style={styles.border} />
                        )
                    }
                </View>
            </View>
        );
    }
    return (
        <View >
            <Text style={styles.title}>{title}</Text>
            <View style={styles.container}>
                {data && data.map(renderCartItem)}
                {
                    (title === "Test Details") && (
                        <TouchableOpacity
                            style={styles.addCartButton}
                        >
                            <Text style={styles.addCartText}> Add More Test</Text>
                        </TouchableOpacity>
                    )
                }
            </View>
        </View>
    )
}

export default TestDetails

const styles = StyleSheet.create({
    title: {
        fontSize: Matrics.mvs(16),
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: Matrics.s(20),
        marginBottom: Matrics.s(10)
    },
    container: {
        backgroundColor: 'white',
        borderRadius: Matrics.s(12),
        padding: Matrics.vs(10),
        marginVertical: Matrics.vs(10),
        elevation: 0.2,
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    renderItemContainer: {
        width: '100%',
        flexDirection: 'row',
        marginVertical: Matrics.vs(10)
    },
    rightContainer: {

        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: "center"
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: colors.secondaryLabel,
        marginTop: Matrics.s(10)
    },
    addCartButton: {
        marginVertical: Matrics.vs(10),
        width: "100%",
        borderWidth: 1,
        borderColor: colors.themePurple,
        paddingHorizontal: Matrics.s(6),
        paddingVertical: Matrics.vs(8),
        borderRadius: Matrics.s(12),
        justifyContent: 'center',
        alignItems: 'center'
    },
    addCartText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        lineHeight: Matrics.s(18)
    },
    titleStyle: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginBottom: 5
    },
    reportText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.purple
    },
})