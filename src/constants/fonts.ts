import { Platform } from "react-native";

export default {
    BOLD: Platform.OS == 'ios' ? 'SFProDisplay-Bold' : 'SF Pro Display',
    MEDIUM: Platform.OS == 'ios' ? 'SFProDisplay-Medium' : 'SFPRODISPLAYMEDIUM',
    REGULAR: Platform.OS == 'ios' ? 'SFProDisplay-Regular' : 'SFPRODISPLAYREGULAR'
};