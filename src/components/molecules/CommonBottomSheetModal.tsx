import {StyleSheet, View} from 'react-native';
import React from 'react';
import {
  BottomSheetBackdrop,
  BottomSheetBackdropProps,
  BottomSheetModal,
  BottomSheetModalProps,
} from '@gorhom/bottom-sheet';
import {colors} from '../../constants/colors';
import {Matrics} from '../../constants';

const CommonBottomSheetModal = React.forwardRef<
  BottomSheetModal,
  BottomSheetModalProps
>((props, ref) => {
  const renderBackdrop = React.useCallback(
    (props: BottomSheetBackdropProps) => (
      <BottomSheetBackdrop
        {...props}
        opacity={1}
        appearsOnIndex={0}
        disappearsOnIndex={-1}
        style={styles.overlay}
      />
    ),
    [],
  );

  return (
    <BottomSheetModal
      ref={ref}
      backdropComponent={renderBackdrop}
      handleIndicatorStyle={styles.sheetHandleIndicator}
      index={0}
      snapPoints={['45%']}
      enablePanDownToClose={false}
      enableContentPanningGesture={false}
      keyboardBehavior="interactive"
      backgroundStyle={styles.sheetBackGround}
      {...props}>
      {props.children}
    </BottomSheetModal>
  );
});

export default CommonBottomSheetModal;

const styles = StyleSheet.create({
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.5)',
    ...StyleSheet.absoluteFillObject,
  },
  sheetBackGround: {
    backgroundColor: colors.white,
  },
  sheetHandleIndicator: {
    backgroundColor: colors.lightGrey,
    width: Matrics.s(40),
    height: Matrics.vs(3.5),
  },
});
