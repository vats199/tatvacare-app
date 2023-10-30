import { StyleSheet, Text, View } from 'react-native'
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts } from '../../constants';
import { Icons } from '../../constants/icons';
import { Matrics } from '../../constants';

type OfferAndPromotionProps = {
    coupanTitle?: string;
    onPressApplyCoupan?: () => void;
}

const OfferAndPromotion: React.FC<OfferAndPromotionProps> = ({ coupanTitle, onPressApplyCoupan }) => {
    return (
        <View >
            <Text style={styles.heading}>Offer & Promotions</Text>
            <View style={styles.offerContainer}>
                <View style={{
                    flexDirection: 'row',
                    justifyContent: "space-between",
                    alignItems: 'center'
                }}>
                    {
                        (coupanTitle) ? (
                            <Icons.Success height={28} width={28} />
                        ) : (
                            <Icons.Offer height={28} width={28} />
                        )
                    }
                    {
                        (coupanTitle) ? (
                            <Text style={styles.applyCoupanText}>{coupanTitle} Applied</Text>
                        ) : (<Text style={styles.applyCoupanText}> Apply Coupan</Text>)
                    }
                </View>
                <View>
                    <Icons.forwardArrow height={16} width={16} onPress={onPressApplyCoupan} />
                </View>
            </View>
        </View>
    )
}

export default OfferAndPromotion;

const styles = StyleSheet.create({
    heading: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: Matrics.s(20),
        marginBottom: 5
    },
    offerContainer: {
        marginVertical: 10,
        padding: 12,
        backgroundColor: colors.white,
        borderRadius: 12,
        elevation: 0.3,
        minHeight: 52,
        width: '100%',
        flexDirection: 'row',
        justifyContent: "space-between",
        alignItems: 'center',
        shadowColor: colors.inputValueDarkGray,
        shadowOffset: { width: 0, height: 1 },
    },
    applyCoupanText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(10)
    },
})