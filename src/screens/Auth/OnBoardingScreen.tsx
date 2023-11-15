import {
  FlatList,
  Image,
  StyleSheet,
  Text,
  View,
  Modal,
  KeyboardAvoidingView,
  StatusBar,
} from 'react-native';
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
import { Constants, Images, Matrics } from '../../constants';
import Button from '../../components/atoms/Button';
import AnimatedInputField from '../../components/atoms/AnimatedInputField';
import { Icons } from '../../constants/icons';
import { TextInput } from 'react-native-gesture-handler';
import Auth from '../../api/auth';
import LoginBottomSheet, {
  LoginBottomSheetRef,
} from '../../components/molecules/LoginBottomSheet';
import Loader from '../../components/atoms/Loader';
import constants from '../../constants/constants';
import * as actions from '../../redux/slices';
import { useDispatch, useSelector } from 'react-redux';
import { RootState } from '../../redux/Store';
import Location from '../../api/location';
type OnBoardingScreenProps = CompositeScreenProps<
  StackScreenProps<AuthStackParamList, 'OnBoardingScreen'>,
  StackScreenProps<AppStackParamList, 'AuthStackScreen'>
>;
const OnBoardingScreen: React.FC<OnBoardingScreenProps> = ({
  navigation,
  route,
}) => {
  const dispatch = useDispatch();
  const {
    user: { data, isLoading },
  } = useSelector((s: RootState) => s.Auth);
  const insets = useSafeAreaInsets();
  const [activeIndex, setActiveIndex] = React.useState<number>(0);
  const activeIndexRef = React.useRef<number>(0);
  const flatListRef = React.useRef<FlatList>(null);
  const BottomSheetRef = React.useRef<LoginBottomSheetRef>(null);
  const [arr, setArr] = React.useState<
    Array<{
      id: number;
      image: any;
      title: string;
      description: string;
    }>
  >([
    {
      id: 1,
      image: Images.OnBoard1,
      title: `Experience improved\n health outcomes`,
      description: `Digitally delivered by dedicated health coaches`,
    },
    {
      id: 2,
      image: Images.OnBoard2,
      title: `Personalised\n Care`,
      description: `Tailored to improve your health`,
    },
    {
      id: 3,
      image: Images.OnBoard3,
      title: `Clinically validated\n approach`,
      description: `Improve your vitals and biomarkers`,
    },
  ]);

  React.useEffect(() => {
    setInterval(() => {
      if (activeIndexRef.current == arr.length - 1) {
        activeIndexRef.current = 0;
        setActiveIndex(activeIndexRef.current);
        flatListRef.current?.scrollToIndex({ index: 0 });
      } else {
        activeIndexRef.current = activeIndexRef.current + 1;
        setActiveIndex(activeIndexRef.current);
        flatListRef.current?.scrollToIndex({ index: activeIndexRef.current });
      }
    }, 4000);
  }, []);
  const renderItem = ({ item, index }: { item: any; index: number }) => {
    return (
      <View style={{ width: Matrics.screenWidth }}>
        <Image source={item.image} style={styles.img} resizeMode="contain" />
        <View style={{ alignItems: 'center' }}>
          <Text style={styles.title}>{item.title}</Text>
          <Text style={styles.desc}>{item.description}</Text>
        </View>
      </View>
    );
  };
  const onPressGetStarted = () => {
    // setModalVisible(true)
    BottomSheetRef?.current?.show();
  };
  const onPressContinue = async (contact_no: string) => {
    const payload = {
      contact_no,
    };
    new Promise((resolve, reject) => {
      dispatch(
        actions.loginRequestAction({
          payload,
          resolve,
          reject,
        }),
      );
    })
      .then(res => {
        console.log(res, 'resss');
        BottomSheetRef?.current?.hide();
        navigation.navigate('OTPScreen', {
          contact_no: contact_no.trim(),
          isLoginOTP: true,
        });
      })
      .catch(err => {
        console.log(err.message, 'errorroror');
        if (err.message === '0') {
          new Promise((resolve, reject) => {
            dispatch(
              actions.signUpRequestAction({
                payload,
                resolve,
                reject,
              }),
            );
          })
            .then(res => {
              BottomSheetRef?.current?.hide();
              navigation.navigate('OTPScreen', {
                contact_no: contact_no.trim(),
                isLoginOTP: false,
              });
            })
            .catch(error => {
              //TODO: error popoup shown
            });
        }
      });
  };
  // TODO: remove if not in use later stage
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
    setActiveIndex(roundIndex);
  };
  return (
    <SafeAreaView edges={['bottom']} style={styles.container}>
      <StatusBar
        translucent={true}
        backgroundColor={colors.white}
        barStyle={'dark-content'}
      />
      <View style={[styles.wrapper, { paddingTop: insets.top }]}>
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
              <View
                key={index.toString()}
                style={{
                  height: Matrics.vs(5),
                  width: Matrics.s(30),
                  backgroundColor:
                    activeIndex == index
                      ? colors.inputBoxDarkBorder
                      : colors.lightGrey,
                  marginLeft: index == 0 ? 0 : Matrics.s(6),
                  borderRadius: Matrics.mvs(1000),
                }}></View>
            );
          })}
        </View>
      </View>
      <View style={styles.spaceView} />
      <Button
        title="Get Started"
        buttonStyle={{ marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0 }}
        onPress={onPressGetStarted}
      />
      <LoginBottomSheet
        ref={BottomSheetRef}
        onPressContinue={onPressContinue}
      />
      {/* <Loader visible={isLoading} /> */}
    </SafeAreaView>
  );
};
export default OnBoardingScreen;