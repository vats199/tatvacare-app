import React, {useEffect, useMemo, useRef, useState} from 'react';
import {
  StyleProp,
  TextStyle,
  NativeSyntheticEvent,
  NativeScrollEvent,
  Animated,
  ViewStyle,
  View,
  ViewProps,
  FlatListProps,
  FlatList,
  StyleSheet,
} from 'react-native';
import WheelPickerItem from '../molecules/WheelPickerItem';
import {Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {
  useAnimatedProps,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import WheelPickerList from './WheelPickerList';

export interface Props {
  selectedIndex: number;
  options: string[];
  onChange: (index: number) => void;
  selectedIndicatorStyle?: StyleProp<ViewStyle>;
  itemTextStyle?: TextStyle;
  itemStyle?: ViewStyle;
  itemHeight?: number;
  containerStyle?: ViewStyle;
  containerProps?: Omit<ViewProps, 'style'>;
  scaleFunction?: (x: number) => number;
  rotationFunction?: (x: number) => number;
  opacityFunction?: (x: number) => number;
  visibleRest?: number;
  decelerationRate?: 'normal' | 'fast' | number;
  flatListProps?: Omit<FlatListProps<string | null>, 'data' | 'renderItem'>;
  seprator?: string;
  sideIcon?: {left?: boolean; right?: boolean};
}

const WheelPicker: React.FC<Props> = ({
  selectedIndex,
  options,
  onChange,
  selectedIndicatorStyle = {},
  containerStyle = {},
  itemStyle = {},
  itemTextStyle = {},
  itemHeight = 40,
  scaleFunction = (x: number) => 1.0 ** x,
  rotationFunction = (x: number) => 1 - Math.pow(1 / 1.5, x),
  opacityFunction = (x: number) => Math.pow(1 / 4.5, x),
  visibleRest = 2,
  decelerationRate = 'fast',
  containerProps = {},
  flatListProps = {},
  seprator,
}) => {
  const containerHeight = (1 + visibleRest * 2) * itemHeight;
  return (
    <View
      style={[styles.container, {height: containerHeight}, containerStyle]}
      {...containerProps}>
      <View
        style={[
          styles.selectedIndicator,
          selectedIndicatorStyle,
          {
            transform: [{translateY: -itemHeight / 2.5}],
            height: itemHeight,
          },
        ]}>
        <View
          style={[
            styles.commonTriangle,
            {
              left: Matrics.s(-20),
            },
          ]}
        />

        <View
          style={[
            styles.commonTriangle,
            {
              right: Matrics.s(-20),
            },
          ]}
        />
      </View>
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'center',
        }}>
        <WheelPickerList {...flatListProps} />
        {/* <Animated.FlatList<string | null>
          {...flatListProps}
          ref={flatListRef}
          style={styles.scrollView}
          showsVerticalScrollIndicator={false}
          onScroll={Animated.event(
            [{nativeEvent: {contentOffset: {y: scrollY}}}],
            {useNativeDriver: true},
          )}
          onMomentumScrollEnd={handleMomentumScrollEnd}
          snapToOffsets={offsets}
          decelerationRate={decelerationRate}
          initialScrollIndex={selectedIndex}
          getItemLayout={(data, index) => ({
            length: itemHeight,
            offset: itemHeight * index,
            index,
          })}
          data={paddedOptions}
          keyExtractor={(item, index) => index.toString()}
          renderItem={({item: option, index}) => {
            return (
              <WheelPickerItem
                key={`option-${index}`}
                index={index}
                option={option}
                style={itemStyle}
                textStyle={{
                  ...itemTextStyle,
                }}
                height={itemHeight}
                currentScrollIndex={currentScrollIndex}
                scaleFunction={scaleFunction}
                rotationFunction={rotationFunction}
                opacityFunction={opacityFunction}
                visibleRest={visibleRest}
              />
            );
          }}
        /> */}
      </View>
    </View>
  );
};

export default WheelPicker;

const styles = StyleSheet.create({
  container: {
    position: 'relative',
  },
  selectedIndicator: {
    position: 'absolute',
    width: '100%',
    borderRadius: 5,
    top: '50%',
  },

  option: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 16,
    zIndex: 100,
  },
  commonTriangle: {
    height: Matrics.mvs(30),
    width: Matrics.mvs(30),
    backgroundColor: colors.themePurple,
    transform: [{rotate: '45deg'}],
    position: 'absolute',
    top: Matrics.vs(3),
  },
});
