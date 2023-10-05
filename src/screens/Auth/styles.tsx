import { StyleSheet } from "react-native";
import { Fonts, Matrics } from "../../constants";
import { colors } from "../../constants/colors";
import fonts from "../../constants/fonts";

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
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        textAlign: 'center',
        fontSize: Matrics.mvs(24),
        marginHorizontal: Matrics.s(32)

    },
    desc: {
        color: colors.subTitleLightGray,
        fontFamily: Fonts.REGULAR,
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
    pagingCont: {
        position: 'absolute',
        bottom: 10,
        alignSelf: 'center',
        flexDirection: 'row'
    },
    loginTitle: {
        color: colors.labelDarkGray,
        fontFamily: fonts.BOLD,
        fontSize: Matrics.mvs(24),
        marginTop: Matrics.vs(24)
    },
    loginDesc: {
        color: colors.subTitleLightGray,
        fontFamily: fonts.REGULAR,
        fontSize: Matrics.mvs(14),
        marginTop: Matrics.vs(12)
    },
    inputTitle: {
        color: colors.subTitleLightGray,
        fontFamily: fonts.REGULAR,
        fontSize: Matrics.mvs(10),
    },
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: Matrics.vs(2),
    },
    inputWrapper: {
        color: colors.inputValueDarkGray,
        fontFamily: fonts.MEDIUM,
        fontSize: Matrics.mvs(14),
        flex: 1,
        paddingLeft: Matrics.s(4)
    },
    contryCode: {
        color: colors.inputValueDarkGray,
        fontFamily: fonts.MEDIUM,
        fontSize: Matrics.mvs(14)
    },
    modelContainer: {
        justifyContent: 'flex-end',
        flex: 1,
        backgroundColor: colors.OVERLAY_DARK_60
    },
    modelWrapper: {
        backgroundColor: colors.white,
        borderTopRightRadius: Matrics.mvs(22),
        borderTopLeftRadius: Matrics.mvs(22),
        paddingHorizontal: Matrics.s(22)
    },
    indicator: {
        height: Matrics.vs(4),
        width: Matrics.s(40),
        backgroundColor: colors.darkGray,
        borderRadius: Matrics.mvs(1000),
        marginTop: Matrics.vs(12),
        alignSelf: 'center'
    },
    inputRowCont: {
        flexDirection: 'row',
        height: Matrics.vs(44),
        borderRadius: Matrics.mvs(12),
        borderWidth: 1,
        borderColor: colors.inputBoxDarkBorder,
        marginTop: Matrics.vs(24),
        alignItems: 'center',
        paddingLeft: Matrics.s(16)
    },
    wrapper: (insets: any) => ({
        backgroundColor: colors.white,
        paddingTop: insets.top,
        flex: 1,
        borderBottomRightRadius: Matrics.mvs(32),
        borderBottomLeftRadius: Matrics.mvs(32)
    })
})


export const OtpStyle = StyleSheet.create({
    title: {
        color: colors.labelDarkGray,
        fontFamily: fonts.BOLD,
        fontSize: Matrics.mvs(24),
        marginTop: Matrics.vs(16)
    },
    container: {
        flex: 1,
        backgroundColor: colors.white,
        paddingHorizontal: Matrics.s(20)
    },
    description: {
        color: colors.labelDarkGray,
        fontFamily: fonts.REGULAR,
        fontSize: Matrics.mvs(14),
        marginTop: Matrics.vs(12)
    },
    nestedBoldText: {
        fontFamily: fonts.BOLD,
    }
})