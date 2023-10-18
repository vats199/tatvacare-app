import {
  View,
  Text,
  TouchableOpacity,
  FlatList,
  Image,
  ScrollView,
} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {
  AppStackParamList,
  BottomTabParamList,
   EngageStackParamList,
} from '../../interface/Navigation.interface';
import {BottomTabScreenProps} from '@react-navigation/bottom-tabs';
import {StackScreenProps} from '@react-navigation/stack';
import {EngageStyle as style} from './styles';
import {Icons} from '../../constants/icons';
import {Images} from '../../constants';
import {colors} from '../../constants/colors';
import DiscoverCard from '../../components/molecules/DiscoverCard';
  
type ExplorScreenProps = CompositeScreenProps<
  StackScreenProps<EngageStackParamList, 'EngageScreen'>,
  CompositeScreenProps<
    BottomTabScreenProps<BottomTabParamList, 'EngageScreen'>,
    StackScreenProps<AppStackParamList, 'DrawerScreen'>
  >
>;

const EngageScreen: React.FC<ExplorScreenProps> = () => {
  const handleFilter = () => {};
  const [cateegory, setCategory] = React.useState([
    {title: 'Condition Basics', icons: Images.GroupIcon, selected: false},
    {title: 'LifeStyle', icons: Images.LifeStyleIcon, selected: false},
    {title: 'Trending', icons: Images.HearRateIcon, selected: false},
    {title: 'Medication & Vitals', icons: Images.MedicalIcon, selected: false},
    {title: 'Diet', icons: Images.Diet, selected: false},
    {title: 'Exercies', icons: Images.Exercies, selected: false},
  ]);

  const toggleCategorySelection = (index: number) => {
    const updatedCategory = [...cateegory];
    updatedCategory[index].selected = !updatedCategory[index].selected;
    setCategory(updatedCategory);
  };
  const [cateegoryData, setCategoryData] = React.useState([
    {
      title: 'MyTatva App Guide',
      discription:
        'Key app features and their respective slots in the video : Logging key activities',
      icons: require('../../assets/images/discoverImage.png'),
    },
    {
      title: 'The Link Between COPD Flare-Ups and Stress Management',
      discription:
        'Chronic stress may also cause more frequent flare-ups of chronic obstructive pulmonary disease (COPD) symptoms. ',
      icons: require('../../assets/images/discoverImage.png'),
    },
    {
      title:
        'Key app features and their respective slots in the video : Logging key activities',
      discription:
        'Chronic stress may also cause more frequent flare-ups of chronic obstructive pulmonary disease (COPD) symptoms. ',
      icons: require('../../assets/images/discoverImage.png'),
    },
    {
      title: 'The Link Between COPD Flare-Ups and Stress Management',
      discription:
        'Chronic stress may also cause more frequent flare-ups of chronic obstructive pulmonary disease (COPD) symptoms. ',
      icons: require('../../assets/images/discoverImage.png'),
    },
    {
      title:
        'Key app features and their respective slots in the video : Logging key activities',
      discription:
        'Chronic stress may also cause more frequent flare-ups of chronic obstructive pulmonary disease (COPD) symptoms. ',
      icons: require('../../assets/images/discoverImage.png'),
    },
    {
      title: 'The Link Between COPD Flare-Ups and Stress Management',
      discription:
        'Chronic stress may also cause more frequent flare-ups of chronic obstructive pulmonary disease (COPD) symptoms. ',
      icons: require('../../assets/images/discoverImage.png'),
    },
  ]);

  const arrsyColors = [
    colors.lightPurple,
    colors.lightGreen,
    colors.lightYellow,
    colors.lightRed,
  ];
  const renderCategory = ({item, index}: {item: any; index: number}) => {
    return (
      <TouchableOpacity
        onPress={() => toggleCategorySelection(index)}
        style={[
          style.categoryContainer,
          {
            backgroundColor: arrsyColors[index % arrsyColors.length],
            borderWidth: item.selected ? 2 : 0,
            borderColor: colors.themePurple,
          },
        ]}>
        <View style={style.categoryView}>
          <Image source={item.icons} style={style.icons} />
          <Text style={style.categoryText}>{item.title}</Text>
        </View>
      </TouchableOpacity>
    );
  };
  return (
    <View style={style.mainContainer}>
      <View style={style.headerContainer}>
        <Text style={style.headerText}>Engage</Text>
        <TouchableOpacity onPress={handleFilter}>
          <Icons.Filter />
        </TouchableOpacity>
      </View>
      <View>
        <FlatList
          data={cateegory}
          renderItem={renderCategory}
          horizontal={true}
          showsHorizontalScrollIndicator={false}
        />
      </View>
      <View style={style.categoryDataContainer}>
        <View style={style.dropdownContainer}>
          <Text>Select your language</Text>
          <View style={style.dropdown}>
            <Text style={style.dropdownText}>English</Text>
          </View>
        </View>
        <FlatList
          data={cateegoryData}
          showsVerticalScrollIndicator={false}
          renderItem={({item}) => {
            return <DiscoverCard CardData={item} />;
          }}
        />
      </View>
    </View>
  );
};

export default EngageScreen;
