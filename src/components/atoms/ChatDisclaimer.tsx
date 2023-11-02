import {StyleSheet, Text, View} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';

const ChatDisclaimer = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>
        Disclaimer: I share information only for your knowledge, please consult
        a healthcare provider for a more accurate assessment and guidance on
        your specific situation.
      </Text>
    </View>
  );
};

export default ChatDisclaimer;

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: 16,
    paddingTop: 12,
    paddingBottom: 8,
    backgroundColor: colors.white,
  },
  text: {
    color: colors.darkGray,
    fontSize: 12,
    fontWeight: '400',
  },
});
