import {DimensionValue, FlatList, Image, Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';

import {
  AppStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import {QuestionOneScreenStyle as styles} from './styles';
import Button from '../../components/atoms/Button';
import {Constants, Fonts, Matrics} from '../../constants';
import AuthHeader from '../../components/molecules/AuthHeader';
import SetupProfileHeading from '../../components/atoms/SetupProfileHeading';
import InputField from '../../components/atoms/AnimatedInputField';
import {colors} from '../../constants/colors';
import AnimatedDatePicker from '../../components/atoms/AnimatedDatePicker';
import {TouchableOpacity} from 'react-native';
import {Icons} from '../../constants/icons';
import QuestionData from './QuestionData.json';
import MyStatusbar from '../../components/atoms/MyStatusBar';

type QuestionOneScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'QuestionListScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const QuestionListScreen: React.FC<QuestionOneScreenProps> = ({
  navigation,
  route,
}) => {
  const insets = useSafeAreaInsets();
  const flatListRef = React.useRef<FlatList>(null);
  // ==================== state ====================//

  const [arr, setArr] = useState(QuestionData.Question);
  const [activeIndex, setActiveIndex] = useState<number>(0);
  const [progressPercentage, setProgressPercentage] = useState<
    DimensionValue | undefined
  >(undefined);

  // ==================== function ====================//
  useEffect(() => {
    let percent = (activeIndex / arr.length) * 100;
    setProgressPercentage(`${Math.ceil(percent)}%`);
  }, [activeIndex]);

  const renderItem = ({item, index}: {item: any; index: number}) => {
    console.log(item, 'itemitem');
    return (
      <View style={{width: Matrics.screenWidth}}>
        {item.type == 1 && (
          <View
            style={{
              flexDirection: 'row',
              flexWrap: 'wrap',
              marginHorizontal: Matrics.s(20),
            }}>
            {item.option.map((_ele, i) => {
              return (
                <TouchableOpacity
                  style={{
                    width: (Matrics.screenWidth - Matrics.s(66)) / 3,
                    height: (Matrics.screenWidth - Matrics.s(66)) / 3,
                    marginLeft: i % 3 == 0 ? 0 : Matrics.s(13),
                    backgroundColor:
                      i == 0 ? colors.THEME_OVERLAY : colors.white,
                    borderWidth: 1,
                    borderColor: i == 0 ? colors.themePurple : colors.lightGray,
                    borderRadius: Matrics.mvs(16),
                    justifyContent: 'space-around',
                    alignItems: 'center',
                    marginTop: Matrics.vs(12),
                  }}
                  activeOpacity={0.7}>
                  <Image style={{height: 20, width: 20}} />
                  <Text
                    style={{
                      fontSize: Matrics.mvs(12),
                      fontFamily: Fonts.MEDIUM,
                      color: i == 0 ? colors.labelDarkGray : colors.darkGray,
                    }}>
                    {_ele?.title ?? ''}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        )}

        {item.type == 2 && (
          <View>
            {item.option.map((_ele, index) => {
              return (
                <TouchableOpacity
                  style={{
                    height: Matrics.vs(38),
                    backgroundColor:
                      index == 0 ? colors.THEME_OVERLAY : colors.white,
                    borderWidth: 1,
                    borderColor:
                      index == 0 ? colors.themePurple : colors.lightGray,
                    marginHorizontal: Matrics.s(20),
                    borderRadius: Matrics.mvs(12),
                    justifyContent: 'center',
                    alignItems: 'center',
                    marginTop: Matrics.vs(12),
                  }}>
                  <Text
                    style={{
                      fontSize: Matrics.mvs(12),
                      fontFamily: Fonts.MEDIUM,
                      color:
                        index == 0 ? colors.labelDarkGray : colors.darkGray,
                    }}>
                    {_ele?.title ?? ''}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        )}

        {item.type == 4 && (
          <>
            <View
              style={{
                flexDirection: 'row',
                flexWrap: 'wrap',
                marginHorizontal: Matrics.s(20),
              }}>
              {item.option.map((_ele, index) => {
                return (
                  <TouchableOpacity
                    style={{
                      width: (Matrics.screenWidth - Matrics.s(105)) / 6,
                      height: (Matrics.screenWidth - Matrics.s(105)) / 6,
                      marginLeft: index == 0 ? 0 : Matrics.s(12),
                      backgroundColor:
                        index == 0 ? colors.THEME_OVERLAY : colors.white,
                      borderWidth: 1,
                      borderColor:
                        index == 0 ? colors.themePurple : colors.lightGray,
                      borderRadius:
                        (Matrics.screenWidth - Matrics.s(105) / 6) / 2,
                      justifyContent: 'center',
                      alignItems: 'center',
                      marginTop: Matrics.vs(12),
                    }}
                    activeOpacity={0.7}>
                    <Text
                      style={{
                        fontSize: Matrics.mvs(12),
                        fontFamily: Fonts.MEDIUM,
                        color:
                          index == 0 ? colors.labelDarkGray : colors.darkGray,
                      }}>
                      {_ele?.title ?? ''}
                    </Text>
                  </TouchableOpacity>
                );
              })}
            </View>
            <View
              style={{
                marginHorizontal: Matrics.s(20),
                flexDirection: 'row',
                justifyContent: 'space-between',
                paddingTop: Matrics.vs(12),
              }}>
              <Text
                style={{
                  fontSize: Matrics.mvs(12),
                  fontFamily: Fonts.MEDIUM,
                  color: colors.inactiveGray,
                  textAlign: 'left',
                  width: '35%',
                }}>
                {item?.min_tag_text ?? ''}
              </Text>

              <Text
                style={{
                  fontSize: Matrics.mvs(12),
                  fontFamily: Fonts.MEDIUM,
                  color: colors.inactiveGray,
                  textAlign: 'right',
                  width: '35%',
                }}>
                {item?.max_tag_text ?? ''}
              </Text>
            </View>
          </>
        )}
      </View>
    );
  };

  const onPressNext = () => {
    if (activeIndex == arr.length - 1) {
      navigation.navigate('ProgressReportScreen');
      return;
    }
    flatListRef.current?.scrollToIndex({index: activeIndex + 1});
    setActiveIndex(activeIndex + 1);
  };

  const onPressSkip = () => {
    if (activeIndex == arr.length - 1) {
      return;
    }
    flatListRef.current?.scrollToIndex({index: activeIndex + 1});
    setActiveIndex(activeIndex + 1);
  };

  const onPressBack = () => {
    if (activeIndex == 0) {
      navigation.goBack();
      return;
    }
    flatListRef.current?.scrollToIndex({index: activeIndex - 1});
    setActiveIndex(activeIndex - 1);
  };

  return (
    <SafeAreaView style={styles.container}>
      <MyStatusbar translucent={true} />
      <View style={styles.container}>
        <AuthHeader
          onPressBack={() => {
            onPressBack();
          }}
          isShowSkipButton={true}
          onPressSkip={() => onPressSkip()}
        />

        <SetupProfileHeading
          title={arr[activeIndex].question}
          desc={arr[activeIndex]?.description || null}
        />

        <FlatList
          ref={flatListRef}
          style={{marginTop: Matrics.vs(11)}}
          data={arr}
          renderItem={renderItem}
          horizontal={true}
          pagingEnabled={true}
          scrollEnabled={false}
          keyExtractor={item => item.id}
          showsHorizontalScrollIndicator={false}
        />
      </View>

      <Button
        title={activeIndex == arr.length - 1 ? 'Finish' : 'Next'}
        onPress={() => onPressNext()}
        type={
          activeIndex == arr.length - 1
            ? Constants.BUTTON_TYPE.PRIMARY
            : Constants.BUTTON_TYPE.SECONDARY
        }
        // disabled={true}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
        progressPercentage={progressPercentage}
        isShowProgress={true}
      />
    </SafeAreaView>
  );
};

export default QuestionListScreen;
