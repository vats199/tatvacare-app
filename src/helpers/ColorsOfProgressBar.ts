import { colors } from "../constants/colors";

export const colorsOfprogressBar = (values: number) => {
    if (values === 0) {
        return {
          tintColor: colors.inactiveGray,
          backgroundColor: 'rgba(145, 145, 145, 0.2)',
        };
      } else if (values > 0 && values < 25) {
        return {
          tintColor: colors.progressBarRed,
          backgroundColor: 'rgba(255, 51, 51, 0.2)',
        };
      } else if (values >= 25 && values < 75) {
        return {
          tintColor: colors.progressBarYellow,
          backgroundColor: 'rgba(250, 176, 0, 0.2)',
        };
      } else {
        return {
          tintColor: colors.progressBarGreen,
          backgroundColor: 'rgba(27, 179, 51, 0.2)',
        };
      }
  };