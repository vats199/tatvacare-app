// --------------- LIBRARIES ---------------
import React from 'react';
import {
    View,
    Modal,
    ActivityIndicator,
    StyleSheet,
    Text,
    Animated,
} from 'react-native';
import LottieView from 'lottie-react-native';

// --------------- ASSETS ---------------
import { colors } from '../../constants/colors';
import Fonts from '../../constants/fonts';
import Matrics from '../../constants/Matrics';

// --------------- COMPONENT DECLARATION ---------------
type LoaderProps = {
    visible: boolean,
    label?: string,
};

const Loader: React.FC<LoaderProps> = ({
    visible,
    label,
}) => {
    const animations = {
        backdrop: React.useRef(new Animated.Value(0)).current,
        scale: React.useRef(new Animated.Value(0)).current,
    };
    const animationStyles = {
        backdrop: {
            opacity: animations.backdrop,
        },
        card: {
            transform: [
                {
                    scale: animations.scale.interpolate({
                        inputRange: [0, 1],
                        outputRange: [1.25, 1],
                    }),
                },
            ],
            opacity: animations.scale.interpolate({
                inputRange: [0, 1],
                outputRange: [0, 1],
            }),
        },
    };

    React.useEffect(() => {
        if (visible == true) showAnimation();
        else if (visible == false) hideAnimation();
    }, [visible]);

    const showAnimation = () => {
        Animated.parallel([
            Animated.timing(animations.backdrop, {
                toValue: 1,
                duration: 100,
                useNativeDriver: true,
            }),
            Animated.spring(animations.scale, {
                toValue: 1,
                useNativeDriver: true,
                springConfig: {
                    damping: 25,
                    mass: 0.8,
                    stiffness: 500,
                },
            }),
        ]).start();
    };

    const hideAnimation = () => {
        Animated.parallel([
            Animated.timing(animations.backdrop, {
                toValue: 0,
                duration: 80,
                useNativeDriver: true,
            }),
            Animated.timing(animations.scale, {
                toValue: 0,
                duration: 50,
                useNativeDriver: true,
            }),
        ]).start();
    };

    return (

        <Modal
            visible={visible}
            transparent
            statusBarTranslucent={true}>
            <View style={styles.container}>
                <LottieView source={require('../../assets/raw/mytatva_animate_loader.json')} autoPlay loop style={{ height: Matrics.vs(150), width: Matrics.s(150) }} />

                <Animated.View
                    style={[styles.backdrop, animationStyles.backdrop]}
                />
                <LottieView source={require('../../assets/raw/mytatva_loader.json')} autoPlay loop />
            </View>
        </Modal>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    backdrop: {
        backgroundColor: colors.OVERLAY_DARK_30,
        ...StyleSheet.absoluteFillObject,
    },
    card: {
        height: Matrics.mvs(55),
        paddingHorizontal: Matrics.s(20),
        justifyContent: 'center',
        alignItems: 'center',
        // ...MainStyles.shadow(),
        backgroundColor: colors.white,
        borderRadius: Matrics.mvs(12),
        flexDirection: 'row',
        maxWidth: '90%',
    },
    label: {
        fontSize: Matrics.mvs(16),
        color: colors.black,
        fontFamily: Fonts.BOLD,
        marginLeft: Matrics.s(12),
    },
});
export default Loader;