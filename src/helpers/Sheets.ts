import {registerSheet} from 'react-native-actions-sheet';
import constants from '../constants/constants';

// Sheets
import NoPermissionSheet from '../components/molecules/sheets/NoPermissionSheet';

registerSheet(constants.SHEETS.NO_PERMISSION, NoPermissionSheet);

export {};
