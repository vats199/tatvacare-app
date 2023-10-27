import {StyleSheet, Text, View, Platform} from 'react-native';
import React from 'react';
import {
  SafeAreaView,
  SafeAreaViewProps,
  useSafeAreaInsets,
} from 'react-native-safe-area-context';
import {colors} from '../../constants/colors';
import {Matrics} from '../../constants';

const SafeAreaContainer: React.FC<SafeAreaViewProps> = props => {
  const insets = useSafeAreaInsets();
  return (
    <SafeAreaView
      edges={['top']}
      style={[
        styles.container,
        {
          paddingTop:
            Platform.OS == 'android' ? insets.top + Matrics.vs(10) : 0,
          paddingBottom: insets.bottom == 0 ? Matrics.vs(16) : insets.bottom,
        },
      ]}
      {...props}>
      {props.children}
    </SafeAreaView>
  );
};

export default SafeAreaContainer;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
  },
});
