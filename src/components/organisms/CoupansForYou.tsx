import { StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React, { useState } from 'react';
import { Icons } from '../../constants/icons';
import { Fonts } from '../../constants';
import { colors } from '../../constants/colors';

type CoupanItem = {
    id: number;
    title: string;
    paytmDiscount: string;
    maximumDiscount: string;
};
type CoupansForYouProps = {
    onApply: (title: string) => void
}

const CoupansForYou: React.FC<CoupansForYouProps> = ({ onApply }) => {

    const [showDetail, setShowDetail] = useState<number[]>([]);
    //console.log(showDetail);


    const handleViewDetails = (id: number) => {
        if (showDetail.includes(id)) {

            setShowDetail(showDetail.filter((item) => item !== id));
        } else {

            setShowDetail([...showDetail, id]);
        }
    }

    const onPressApply = (title: string) => {
        onApply(title);
    }
    const options: CoupanItem[] = [
        {
            id: 1,
            title: 'TATVAFIRST',
            paytmDiscount: "Get 20% off when you pay using Paytm",
            maximumDiscount: "Maximum discount upto ₹300 on your first order",
        },
        {
            id: 2,
            title: 'PAYTM',
            paytmDiscount: "Get 20% off when you pay using Paytm",
            maximumDiscount: "Maximum discount upto ₹300 on your first order",
        },
        {
            id: 3,
            title: 'UPI20',
            paytmDiscount: "Get 20% off when you pay using Paytm",
            maximumDiscount: "Maximum discount upto ₹300 on your first order",
        },

        {
            id: 4,
            title: 'TATVAFIRST',
            paytmDiscount: "Get 20% off when you pay using Paytm",
            maximumDiscount: "Maximum discount upto ₹300 on your first order",
        },


    ];

    const renderCoupanItem = (item: CoupanItem, index: number) => {
        return (
            <View key={index} style={styles.coupanContainer}>
                <View style={{ margin: 14 }}>
                    <View style={styles.upperRow}>
                        <View >
                            <Icons.Offer height={20} width={20} />
                        </View>
                        <View >
                            <Text style={styles.titleText}>{item.title}</Text>
                            <Text style={styles.paytmDiscount}>{item.paytmDiscount}</Text>
                        </View>
                        <TouchableOpacity onPress={() => onPressApply(item?.title)} >
                            <Text style={styles.buttonText}>Apply</Text>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.border} />
                    <View style={styles.lowerContainer}>
                        <Text style={styles.maximumDiscount}>{item.maximumDiscount}</Text>
                        <TouchableOpacity style={{ marginVertical: 5 }} onPress={() => handleViewDetails(item?.id)} >
                            {
                                showDetail.includes(item.id) ? (
                                    <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                        <Text style={styles.buttonText}>Hide Details</Text>
                                        <Icons.upArrow />
                                    </View>
                                ) : (
                                    <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                        <Text style={styles.buttonText}>View Details</Text>
                                        <Icons.Dropdown />
                                    </View>
                                )
                            }
                        </TouchableOpacity>
                    </View>
                </View>
                {
                    showDetail.includes(item.id) && (
                        <>
                            <View style={styles.border} />
                            <View style={styles.viewDetailsContainer}>
                                <Text style={styles.termsAndConditionText}>Terms and condition</Text>
                                <View style={{ marginLeft: 5, marginVertical: 5 }}>
                                    <Text style={styles.conditionText}>{'\u2022'} Offer valid till Jul 31,2023</Text>
                                    <Text style={styles.conditionText}>{'\u2022'} Valid on Weekends OnlyOther T&C’s</Text>
                                    <Text style={styles.conditionText}>{'\u2022'} Other T&C’s</Text>
                                    <Text style={styles.conditionText}>{'\u2022'} Other T&C’s</Text>
                                </View>
                            </View>
                        </>
                    )
                }
            </View>
        );
    }
    return (
        <View style={{ marginVertical: 20 }}>
            <Text style={styles.coupanForYouText}>CoupansForYou</Text>
            <View >
                {options.map(renderCoupanItem)}
            </View>
        </View>
    )
}

export default CoupansForYou;

const styles = StyleSheet.create({
    coupanForYouText: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    coupanContainer: {
        backgroundColor: 'white',
        borderRadius: 12,
        //padding: 14,
        marginVertical: 10,
        minHeight: 124
    },
    upperRow: {
        flexDirection: "row",
        justifyContent: "space-evenly",
        marginBottom: 10
    },
    border: {
        borderBottomWidth: 0.5,
        borderBottomColor: "#D3D3D3",

    },
    titleText: {
        fontSize: 14,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,

    },
    buttonText: {
        fontSize: 12,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
        marginRight: 5
    },
    paytmDiscount: {
        fontSize: 12,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    },
    maximumDiscount: {
        fontSize: 12,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
    },
    lowerContainer: {
        marginTop: 10
    },
    viewDetailsContainer: {
        padding: 10
    },
    termsAndConditionText: {
        fontSize: 14,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
    },
    conditionText: {
        fontSize: 14,
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
        marginTop: 3
    }

})