import { StyleSheet } from "react-native";
import { Matrics } from "../../constants";
import { colors } from "../../constants/colors";

export const OnBoardStyle = StyleSheet.create({
    container: {
        flex: 1
    },
    buttonStyle: {
        marginHorizontal: Matrics.s(20),
        borderRadius: Matrics.mvs(16)
    },
    spaceView: {
        height: Matrics.vs(42)
    },
    title: {
        color: colors.labelDarkGray,
        textAlign: 'center',
        fontSize: Matrics.mvs(24),
        marginHorizontal: Matrics.s(32)
    },
    desc: {
        color: colors.subTitleLightGray,
        textAlign: 'center',
        fontSize: Matrics.mvs(16),
        marginHorizontal: Matrics.s(4),
        marginTop: Matrics.vs(12)
    },
    img: {
        height: Matrics.screenHeight * 0.5,
        width: Matrics.screenWidth - Matrics.s(20),
        alignSelf: 'center'
    },
    wrapper: (insets: any) => ({
        backgroundColor: colors.white,
        paddingTop: insets.top,
        flex: 1,
        // paddingBottom: Matrics.vs(32),
        borderBottomRightRadius: Matrics.mvs(32),
        borderBottomLeftRadius: Matrics.mvs(32)
    })


})