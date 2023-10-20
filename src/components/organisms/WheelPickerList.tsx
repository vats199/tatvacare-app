import {
  FlatList,
  NativeScrollEvent,
  NativeSyntheticEvent,
  StyleSheet,
  Text,
  View,
  Animated,
  ViewStyle,
} from 'react-native';
import React, {useEffect, useMemo, useRef, useState} from 'react';
import {Props} from './WheelPicker';
import WheelPickerItem from '../molecules/WheelPickerItem';

type WheelPickerListProps = {
  selectedIndex: number;
  options: string[];
  onChange: (index: number) => void;
  seprator?: string;
  visibleRest?: number;
  itemHeight?: number;
  decelerationRate?: 'normal' | 'fast' | number;
  itemStyle?: ViewStyle;
};
const WheelPickerList: React.FC<WheelPickerListProps> = ({
  selectedIndex,
  options,
  seprator,
  onChange,
  visibleRest = 2,
  itemHeight = 40,
  decelerationRate = 'fast',
  itemStyle = {},
}) => {
  const flatListRef = useRef<FlatList>(null);
  const [scrollY] = useState(new Animated.Value(0));

  useEffect(() => {
    if (selectedIndex < 0 || selectedIndex >= options.length) {
      throw new Error(
        `Selected index ${selectedIndex} is out of bounds [0, ${
          options.length - 1
        }]`,
      );
    }
  }, [selectedIndex, options]);

  /**
   * If selectedIndex is changed from outside (not via onChange) we need to scroll to the specified index.
   * This ensures that what the user sees as selected in the picker always corresponds to the value state.
   */
  useEffect(() => {
    flatListRef.current?.scrollToIndex({
      index: selectedIndex,
      animated: false,
    });
  }, [selectedIndex]);

  const paddedOptions = useMemo(() => {
    // const array: (string | null)[] = [...options];
    const array: (string | null)[] = options.map(item => {
      return `${item}${seprator}`;
    });
    for (let i = 0; i < visibleRest; i++) {
      array.unshift(null);
      array.push(null);
    }
    return array;
  }, [options, visibleRest]);

  const offsets = useMemo(
    () => [...Array(paddedOptions.length)].map((x, i) => i * itemHeight),
    [paddedOptions, itemHeight],
  );

  const currentScrollIndex = useMemo(
    () => Animated.add(Animated.divide(scrollY, itemHeight), visibleRest),
    [visibleRest, scrollY, itemHeight],
  );

  const handleMomentumScrollEnd = (
    event: NativeSyntheticEvent<NativeScrollEvent>,
  ) => {
    // Due to list bounciness when scrolling to the start or the end of the list
    // the offset might be negative or over the last item.
    // We therefore clamp the offset to the supported range.
    const offsetY = Math.min(
      itemHeight * (options.length - 1),
      Math.max(event.nativeEvent.contentOffset.y, 0),
    );

    let index = Math.floor(Math.floor(offsetY) / itemHeight);
    const last = Math.floor(offsetY % itemHeight);
    if (last > itemHeight / 2) index++;

    if (index !== selectedIndex) {
      onChange(index);
    }
  };
  return (
    <Animated.FlatList<string | null>
      {...flatListProps}
      ref={flatListRef}
      style={styles.scrollView}
      showsVerticalScrollIndicator={false}
      onScroll={Animated.event([{nativeEvent: {contentOffset: {y: scrollY}}}], {
        useNativeDriver: true,
      })}
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
    />
  );
};

export default WheelPickerList;

const styles = StyleSheet.create({
  scrollView: {
    overflow: 'hidden',
    flex: 1,
  },
});
