import { StyleSheet } from "react-native";
import { colors } from "./colors";

export const globalStyles = StyleSheet.create({
    shadowContainer: {
        shadowOffset: { width: 0, height: 0 },
        shadowColor: colors.shadow,
        shadowOpacity: 0.2,
        shadowRadius: 10,
        elevation: 12,
    }
})