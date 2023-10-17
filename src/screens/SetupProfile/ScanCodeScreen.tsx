import {StyleSheet, Text, View} from 'react-native';
import React, {useState, useCallback} from 'react';
import {CompositeScreenProps, useFocusEffect} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';
import {
  useCameraDevice,
  Camera,
  FrameProcessor,
} from 'react-native-vision-camera';
import {useScanBarcodes, BarcodeFormat} from 'vision-camera-code-scanner';

import {
  AppStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import {QuestionOneScreenStyle as styles} from './styles';
import AuthHeader from '../../components/molecules/AuthHeader';
import {colors} from '../../constants/colors';
import BarcodeMask from 'react-native-barcode-mask';

type ScanCodeScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'ScanCodeScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const ScanCodeScreen: React.FC<ScanCodeScreenProps> = ({navigation, route}) => {
  // state
  const device = useCameraDevice('back');
  const [permissionGranted, setPermissionGranted] = useState<boolean>(false);
  const [qrCodeData, setQRCodeData] = useState<string>('');
  const [isLoading, setLoading] = useState<boolean>(false);
  const [isCameraActive, setCameraActive] = useState<boolean>(false);
  // const frameFPS = React.useRef<FrameProcessor | undefined>(5);

  const [frame, codes] = useScanBarcodes([BarcodeFormat.QR_CODE], {
    checkInverted: true,
  });
  // ==================== function ====================//
  const checkPermissions = async () => {
    const cameraPermission = await Camera.getCameraPermissionStatus();
    if (cameraPermission !== 'granted') {
      await Camera.requestCameraPermission();
    } else {
      setPermissionGranted(true);
    }
  };

  React.useEffect(() => {
    if (codes && codes.length > 0) {
      // if (codes[codes.length - 1].content.data != qrCodeData) {
      // frameFPS.current = 0;
      // setQRCodeData(codes[codes.length - 1].content.data)
      // }
    }
  }, [codes]);

  useFocusEffect(
    useCallback(() => {
      setCameraActive(true);
      checkPermissions();

      return () => {
        setCameraActive(false);
      };
    }, []),
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.container}>
        <AuthHeader
          onPressBack={() => {
            navigation.goBack();
          }}
        />
        <View style={{flex: 1}}>
          {device != null ? (
            <>
              <Camera
                isActive={isCameraActive}
                device={device}
                style={StyleSheet.absoluteFill}
                // frameProcessor={frame}
                audio={false}
              />
              <View
                style={{
                  borderWidth: 0,
                  flex: 1,
                  justifyContent: 'center',
                  alignItems: 'center',
                }}>
                <BarcodeMask
                  width={300}
                  height={300}
                  edgeBorderWidth={15}
                  edgeColor={colors.white}
                  edgeHeight={40}
                  edgeWidth={40}
                  showAnimatedLine={false}
                  outerMaskOpacity={0}
                />
              </View>
            </>
          ) : null}
        </View>
      </View>
    </SafeAreaView>
  );
};

export default ScanCodeScreen;
