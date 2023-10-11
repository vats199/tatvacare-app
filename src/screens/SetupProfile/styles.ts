import { StyleSheet } from "react-native";
import { colors } from "../../constants/colors";
import { Fonts, Matrics } from "../../constants";

export const WelcomeScreenStyle = StyleSheet.create({
    container : {
        flex :1,
        backgroundColor : colors.white
    },
    image : {
        height: Matrics.screenHeight * 0.5,
        width: Matrics.screenWidth - Matrics.s(50),
        alignSelf: 'center'
    },
    titleText : {
        fontSize : Matrics.mvs(20),
        color : colors.labelDarkGray,
        fontFamily : Fonts.BOLD,
        textAlign : 'center'
    },
    descText : {
        fontSize : Matrics.mvs(14),
        color : colors.subTitleLightGray,
        fontFamily : Fonts.REGULAR,
        textAlign : 'center',
        marginTop : Matrics.vs(12)
    },
    textCont: {
        marginHorizontal : Matrics.s(16),
        alignItems : 'center',
        flex : 1
    }
})