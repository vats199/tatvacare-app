/**
 * @format
 */

import { AppRegistry, Text, TextInput } from 'react-native';
import App from './App';
import { name as appName } from './app.json';
import setDefaultProps from 'react-native-simple-default-props';

const customFont = {
    style: {
        fontFamily: 'SFProDisplay-Regular'
    }
}

setDefaultProps(Text, customFont)
setDefaultProps(TextInput, customFont)

AppRegistry.registerComponent(appName, () => App);

