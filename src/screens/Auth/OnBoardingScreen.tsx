import { FlatList, Image, StyleSheet, Text, View, Modal, KeyboardAvoidingView } from 'react-native';
import React from 'react';
import { CompositeScreenProps } from '@react-navigation/native';
import { DrawerScreenProps } from '@react-navigation/drawer';
import {
  AppStackParamList,
  AuthStackParamList,
  DrawerParamList,
} from '../../interface/Navigation.interface';
import { colors } from '../../constants/colors';
import { useSafeAreaInsets, SafeAreaView } from 'react-native-safe-area-context';
import { StackScreenProps } from '@react-navigation/stack';
import { OnBoardStyle as styles } from './styles';
import OnBoard from '../../interface/Auth.interface';
import { Images, Matrics } from '../../constants';
import Button from '../../components/atoms/Button';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import { Icons } from '../../constants/icons';
import { TextInput } from 'react-native-gesture-handler';

type OnBoardingScreenProps = CompositeScreenProps<
  StackScreenProps<AuthStackParamList, 'OnBoardingScreen'>,
  StackScreenProps<AppStackParamList, 'AuthStackScreen'>
>;

interface OnBoardProps {
  onBoards: OnBoard[];
}

const OnBoardingScreen: React.FC<OnBoardingScreenProps> = ({ navigation, route }) => {
  const insets = useSafeAreaInsets()
  const [activeIndex, setActiveIndex] = React.useState<number>(0)
  const [mobileNumber, setMobileNumber] = React.useState<string>('')
  const [isModalVisible, setModalVisible] = React.useState<boolean>(false)
  const flatListRef = React.useRef<FlatList>(null);

  const [arr, setArr] = React.useState<Array<{
    id: number,
    image: any,
    title: string,
    description: string
  }>>([
    {
      id: 1,
      image: Images.OnBoard1,
      title: `Experience improved\n health outcomes`,
      description: `Digitally delivered by dedicated health coaches`
    },
    {
      id: 2,
      image: Images.OnBoard2,
      title: `Personalised\n Care`,
      description: `Tailored to improve your health`
    },
    {
      id: 3,
      image: Images.OnBoard3,
      title: `Clinically validated\n approach`,
      description: `Improve your vitals and biomarkers`
    }
  ])

  const renderItem = ({ item, index }: { item: any; index: number }) => {
    return (
      <View style={{ width: Matrics.screenWidth }}>
        <Image source={item.image} style={styles.img} resizeMode='contain' />
        <View style={{ alignItems: 'center' }}>
          <Text style={styles.title}>{item.title}</Text>
          <Text style={styles.desc}>{item.description}</Text>
        </View>
      </View>
    );
  };

  const onPressGetStarted = () => {
    if (activeIndex == arr.length - 1) {
      setModalVisible(true)
      return;
    }
    flatListRef.current?.scrollToIndex({ index: activeIndex + 1 })
    setActiveIndex(activeIndex + 1)

  }

  const onChangeText = (text: string) => {
    setMobileNumber(text)
  }

  const onPressContinue = () => {
    setModalVisible(false)
    navigation.navigate('OTPScreen')
  }
  //TODO: remove if not in use later stage
  // const _onViewableItemsChanged = React.useCallback(({ viewableItems, changed }) => {
  //   // console.log("Visible items are", viewableItems[0]?.index);
  //   // console.log("Changed in this iteration", changed);
  //   setActiveIndex(viewableItems[0]?.index)
  // }, []);

  // const _viewabilityConfig = {
  //   itemVisiblePercentThreshold: 50
  // }

  const _onscroll = (event: any) => {
    const slideSize = event.nativeEvent.layoutMeasurement.width;
    const index = event.nativeEvent.contentOffset.x / slideSize;
    const roundIndex = Math.round(index);
    setActiveIndex(roundIndex)
  }
  return (
    <SafeAreaView edges={['bottom']} style={styles.container}>
      <View style={styles.wrapper(insets)}>
        <FlatList
          ref={flatListRef}
          // onScroll={_onscroll}
          scrollEnabled={false}
          bounces={false}
          data={arr}
          renderItem={renderItem}
          horizontal
          pagingEnabled
          keyExtractor={item => item.id}
          showsHorizontalScrollIndicator={false}
        // onViewableItemsChanged={_onViewableItemsChanged}
        // viewabilityConfig={_viewabilityConfig}
        />
        <View style={styles.pagingCont}>
          {arr.map((ele, index) => {
            return (
              <View style={{ height: Matrics.vs(5), width: Matrics.s(30), backgroundColor: activeIndex == index ? colors.inputBoxDarkBorder : colors.lightGrey, marginLeft: index == 0 ? 0 : Matrics.s(6), borderRadius: Matrics.mvs(1000) }}>
              </View>
            )
          })}
        </View>
      </View>
      <View style={styles.spaceView} />
      <Button
        title='Get Started'
        buttonStyle={styles.buttonStyle}
        onPress={() => onPressGetStarted()}
      />

      <Modal
        visible={isModalVisible}
        transparent={true}
      >
        <SafeAreaView style={{ flex: 1 }}>
          <KeyboardAvoidingView behavior='padding' style={{ flex: 1 }}>
            <View style={styles.modelContainer}>
              <View style={styles.modelWrapper}>
                <View style={styles.indicator} />
                <Text style={styles.loginTitle}>{`Login or signup to your account`}</Text>
                <Text style={styles.loginDesc}>{`Enter your number to receive a One Time Password.`}</Text>
                <View style={styles.inputRowCont}>
                  <Icons.FlagIcon />
                  <View style={{ flex: 1, paddingHorizontal: Matrics.s(12) }}>
                    <Text style={styles.inputTitle}>{`Mobile Number`}</Text>
                    <View style={styles.inputContainer}>
                      <Text style={styles.contryCode}>{`+91`}</Text>
                      <TextInput
                        style={styles.inputWrapper}
                        keyboardType='number-pad'
                        maxLength={10}
                        autoFocus={true}
                        onChangeText={onChangeText}
                      />
                    </View>
                  </View>
                </View>
                <Button
                  title='Continue'
                  buttonStyle={{ marginVertical: Matrics.vs(20) }}
                  disabled={mobileNumber.length < 10}
                  onPress={() => onPressContinue()}
                />
              </View>
            </View>
          </KeyboardAvoidingView>
        </SafeAreaView>
      </Modal>
    </SafeAreaView>
  );
};

export default OnBoardingScreen;

