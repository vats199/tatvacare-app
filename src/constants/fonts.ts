import {Platform} from 'react-native';

export default {
  BOLD: Platform.OS == 'ios' ? 'SFProDisplay-Bold' : 'sf_bold',
  MEDIUM: Platform.OS == 'ios' ? 'SFProDisplay-Medium' : 'sf_medium',
  REGULAR: Platform.OS == 'ios' ? 'SFProDisplay-Regular' : 'sf_regular',
  SEMI_BOLD: Platform.OS == 'ios' ? 'SFProDisplay-Semibold' : 'sf_semi_bold',
};
