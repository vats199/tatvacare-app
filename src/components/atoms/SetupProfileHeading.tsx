import { Image, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import React from 'react';
import { colors } from '../../constants/colors';
import { Fonts, Matrics } from '../../constants';

type HeadingProps = {
    title: string;
    desc?: string;
};

const SetupProfileHeading: React.FC<HeadingProps> = ({
    title,
    desc = null
}) => {
    return (
        <View style={styles.container}>
            <Text style={styles.heading}>
                {title}
            </Text>
            {desc && (
                <Text style={styles.desc}>
                    {desc}
                </Text>
            )}
        </View>
    );
};

export default SetupProfileHeading;

const styles = StyleSheet.create({
    container: {
        marginHorizontal: Matrics.s(20),
        marginTop: Matrics.vs(16)
    },
    heading: {
        fontSize: Matrics.mvs(20),
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        textAlign: 'left'
    },
    desc: {
        fontSize: Matrics.mvs(14),
        fontFamily: Fonts.REGULAR,
        color: colors.subTitleLightGray,
        textAlign: 'left'
    }
})