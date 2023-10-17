import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import LottieView from 'lottie-react-native';

const TatvaLoader: React.FC<{}> = () => {
  return (
    <View style={styles.container}>
      <LottieView
        source={require('../../assets/images/mytatva_animate_loader.json')}
        autoPlay
        loop
        style={{height: 150, width: 150}}
      />
    </View>
  );
};

export default TatvaLoader;

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    ...StyleSheet.absoluteFillObject,
    zIndex: 100,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
});
