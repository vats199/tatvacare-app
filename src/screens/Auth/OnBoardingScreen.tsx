import { FlatList, Image, StyleSheet, Text, View } from 'react-native';
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
      image: Images.OnBoard1,
      title: `Personalised\n Care`,
      description: `Tailored to improve your health`
    },
    {
      id: 3,
      image: Images.OnBoard1,
      title: `Clinically validated\n approach`,
      description: `Improve your vitals and biomarkers`
    }
  ])

  const renderItem = ({ item, index }: { item: any; index: number }) => {
    return (
      <View style={{ width: Matrics.screenWidth }}>
        <Image source={Images.OnBoard1} style={styles.img} resizeMode='contain' />
        <View style={{ alignItems: 'center' }}>
          <Text style={styles.title}>{item.title}</Text>
          <Text style={styles.desc}>{item.description}</Text>
        </View>
      </View>
    );
  };

  const onPressGetStarted = () => {
    if (activeIndex == arr.length - 1) {
      return;
    }
    flatListRef.current?.scrollToIndex({ index: activeIndex + 1 })
    setActiveIndex(activeIndex + 1)

  }

  return (
    <SafeAreaView edges={['bottom']} style={styles.container}>
      <View style={styles.wrapper(insets)}>
        <FlatList
          ref={flatListRef}
          bounces={false}
          data={arr}
          renderItem={renderItem}
          horizontal
          pagingEnabled
          keyExtractor={item => item.id}
          showsHorizontalScrollIndicator={false}
        />
      </View>
      <View style={styles.spaceView} />
      <Button
        title='Get Started'
        buttonStyle={styles.buttonStyle}
        onPress={() => onPressGetStarted()}
      />
    </SafeAreaView>
  );
};

export default OnBoardingScreen;

