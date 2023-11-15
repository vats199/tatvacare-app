import React from 'react';
import {StyleSheet, Text, View} from 'react-native';

import ActionSheet, {
  ActionSheetRef,
  SheetManager,
  SheetProps,
} from 'react-native-actions-sheet';
import {Icons} from '../../../constants/icons';
import {colors} from '../../../constants/colors';
import Button from '../../atoms/Button';

interface NoPermissionSheetProps extends SheetProps {}

const NoPermissionSheet: React.FC<NoPermissionSheetProps> = ({sheetId}) => {
  const actionSheetRef = React.useRef<ActionSheetRef>(null);

  return (
    <ActionSheet
      id={sheetId}
      ref={actionSheetRef}
      containerStyle={styles.sheet}
      isModal={false}
      snapPoints={[100]}
      initialSnapIndex={0}
      statusBarTranslucent
      gestureEnabled={true}
      useBottomSafeAreaPadding
      defaultOverlayOpacity={0.3}>
      <View style={styles.container}>
        <View style={styles.contentContainer}>
          <Icons.LocationInactive />
          <Text style={styles.title}>Device location not enabled</Text>
          <Text style={styles.subtitle}>
            Granting location permission will ensure accurate location
          </Text>
        </View>
        <View style={styles.buttonContainer}>
          <Button
            title={'Select Manually'}
            onPress={() => {}}
            titleStyle={styles.outlinedButtonText}
            buttonStyle={styles.outlinedButton}
            activeOpacity={0.6}
            loaderColor={colors.themePurple}
          />
          <Button
            title={'Grant'}
            onPress={() => {}}
            titleStyle={styles.filledButtonText}
            buttonStyle={styles.filledButton}
            activeOpacity={0.6}
          />
        </View>
      </View>
    </ActionSheet>
  );
};

const styles = StyleSheet.create({
  sheet: {
    borderTopRightRadius: 20,
    borderTopLeftRadius: 20,
  },
  container: {
    paddingHorizontal: 16,
    maxHeight: '100%',
    height: 250,
  },
  contentContainer: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 20,
  },
  title: {
    textAlign: 'center',
    marginTop: 12,
    fontWeight: '700',
    fontSize: 20,
    color: colors.labelDarkGray,
  },
  subtitle: {
    textAlign: 'center',
    marginTop: 12,
    fontSize: 12,
    fontWeight: '400',
    color: colors.subTitleLightGray,
  },
  buttonContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 16,
    gap: 12,
  },
  outlinedButton: {
    borderWidth: 1,
    borderColor: colors.themePurple,
    backgroundColor: colors.white,
    borderRadius: 16,
    flex: 1,
  },
  outlinedButtonText: {
    fontSize: 16,
    fontWeight: '700',
    color: colors.themePurple,
  },
  filledButton: {
    backgroundColor: colors.themePurple,
    borderRadius: 16,
    flex: 1,
  },
  filledButtonText: {
    fontSize: 16,
    fontWeight: '700',
    color: colors.white,
  },
});

export default NoPermissionSheet;
