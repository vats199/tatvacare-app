import {StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {DrawerScreenProps} from '@react-navigation/drawer';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {colors} from '../constants/colors';
import {SafeAreaView} from 'react-native-safe-area-context';
import {StackScreenProps} from '@react-navigation/stack';
import WebView from 'react-native-webview';
import AboutUsTabSwitcher from '../components/atoms/AboutUsTabSwitcher';
import {Icons} from '../constants/icons';
import LottieView from 'lottie-react-native';

type AboutUsScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'AboutUsScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const ABOUT_US_URL = 'https://www.mytatva.in/';
const TERMS_URL = 'https://mytatva.in/terms-and-conditions/';
const POLICY_URL = 'https://www.mytatva.in/privacy-policy/';

const AboutUsScreen: React.FC<AboutUsScreenProps> = ({navigation, route}) => {
  const [aboutUsTab, setAboutUsTab] = React.useState<
    'about' | 'terms' | 'policy'
  >('about');

  const [loading, setLoading] = React.useState<boolean>(true);

  const onPressClose = () => {
    navigation.goBack();
  };

  const getUrl = () => {
    switch (aboutUsTab) {
      case 'about':
        return ABOUT_US_URL;
      case 'terms':
        return TERMS_URL;
      case 'policy':
        return POLICY_URL;
    }
  };

  React.useEffect(() => {
    setLoading(true);
  }, [aboutUsTab]);

  return (
    <SafeAreaView edges={['bottom', 'top']} style={styles.screen}>
      {loading && (
        <View style={styles.overlay}>
          <LottieView
            source={require('../assets/images/mytatva_animate_loader.json')}
            autoPlay
            loop
            style={{height: 125, width: 125}}
          />
        </View>
      )}
      <View style={styles.container}>
        <TouchableOpacity
          style={styles.closeBtn}
          activeOpacity={0.7}
          onPress={onPressClose}>
          <Icons.CloseIcon height={15} width={15} />
        </TouchableOpacity>
        <AboutUsTabSwitcher
          activeTab={aboutUsTab}
          setActiveTab={setAboutUsTab}
        />
        <WebView
          source={{uri: getUrl()}}
          style={{flex: 1}}
          allowsFullscreenVideo={false}
          onLoadEnd={() => setLoading(false)}
        />
      </View>
    </SafeAreaView>
  );
};

export default AboutUsScreen;

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: colors.white,
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    // position: 'absolute',
    zIndex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  container: {
    flex: 1,
    backgroundColor: colors.white,
  },
  closeBtn: {
    paddingHorizontal: 15,
    paddingBottom: 15,
  },
});
