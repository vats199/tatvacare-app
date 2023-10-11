import {
  FlatList,
  Image,
  ImageSourcePropType,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import {StackScreenProps} from '@react-navigation/stack';
import {AppStackParamList} from '../../interface/Navigation.interface';
import AppointmentHeader from '../../components/molecules/AppointmentHeader';
import {Fonts, Matrics} from '../../constants';

type AppointmentScreenProps = StackScreenProps<AppStackParamList>;

type LanguagesType = {
  id: number;
  language: string;
};

type SlotsType = {
  id: number;
  time: string;
};

type CoachDetailsType = {
  name: string;
  profile: ImageSourcePropType & string;
  type: string;
  level: string;
  languages: LanguagesType[];
};

type CoachDataType = {
  coachDetails: CoachDetailsType;
  slots: SlotsType[];
};

const AppointmentWithScreen: React.FC<AppointmentScreenProps> = ({
  route,
  navigation,
}) => {
  const CoachData: CoachDataType[] = [
    {
      coachDetails: {
        name: 'Health coach name',
        profile: require('../../assets/images/User.png'),
        type: 'Specialisation',
        level: 'Experience',
        languages: [
          {
            id: 1,
            language: 'Language 1',
          },
          {
            id: 2,
            language: 'Language 2',
          },
          {
            id: 3,
            language: 'Language 1',
          },
          {
            id: 4,
            language: 'Language 2',
          },
          {
            id: 5,
            language: 'Language 1',
          },
          {
            id: 6,
            language: 'Language2',
          },
          {
            id: 7,
            language: 'Language1',
          },
          {
            id: 8,
            language: 'Language2',
          },
        ],
      },
      slots: [
        {
          id: 1,
          time: '06:30 - 07:30',
        },
        {
          id: 2,
          time: '06:30 - 07:30',
        },
        {
          id: 3,
          time: '06:30 - 07:30',
        },
        {
          id: 4,
          time: '06:30 - 07:30',
        },
      ],
    },
    {
      coachDetails: {
        name: 'Health coach name',
        profile: require('../../assets/images/User.png'),
        type: 'Specialisation',
        level: 'Experience',
        languages: [
          {
            id: 1,
            language: 'Language1',
          },
          {
            id: 2,
            language: 'Language2',
          },
        ],
      },
      slots: [
        {
          id: 1,
          time: '06:30 - 07:30',
        },
        {
          id: 2,
          time: '06:30 - 07:30',
        },
        {
          id: 3,
          time: '06:30 - 07:30',
        },
        {
          id: 4,
          time: '06:30 - 07:30',
        },
      ],
    },
    {
      coachDetails: {
        name: 'Health coach name',
        profile: require('../../assets/images/User.png'),
        type: 'Specialisation',
        level: 'Experience',
        languages: [
          {
            id: 1,
            language: 'Language1',
          },
          {
            id: 2,
            language: 'Language2',
          },
        ],
      },
      slots: [
        {
          id: 1,
          time: '06:30 - 07:30',
        },
        {
          id: 2,
          time: '06:30 - 07:30',
        },
        {
          id: 3,
          time: '06:30 - 07:30',
        },
        {
          id: 4,
          time: '06:30 - 07:30',
        },
      ],
    },
  ];

  const type = route?.params?.type;

  const renderLanguage = (item: LanguagesType[]) => {
    const combineLanguage = item.map(item => item.language).join(',');
    return (
      <Text
        numberOfLines={1}
        style={{
          fontFamily: Fonts.BOLD,
          fontSize: Matrics.mvs(11),
          color: colors.subTitleLightGray,
          maxWidth: Matrics.s(240),
        }}>
        {combineLanguage}
      </Text>
    );
  };

  const timeFrom = (count: number) => {
    let dates: string[] = [];
    for (let I = 0; I < Math.abs(count); I++) {
      dates.push(
        new Date(
          new Date().getTime() -
            (count >= 0 ? I : I - I - I) * 24 * 60 * 60 * 1000,
        ).toLocaleString('en-us', {weekday: 'short', day: '2-digit'}),
      );
    }
    return dates;
  };

  const renderDays = ({item, index}: {item: string; index: number}) => {
    const dayName = item?.split(' ')[0];
    const date = item?.split(' ')[1];
    return (
      <TouchableOpacity
        style={{
          backgroundColor: colors.white,
          alignItems: 'center',
          width: Matrics.s(40),
          height: Matrics.vs(40),
          justifyContent: 'center',
          borderRadius: Matrics.s(10),
          borderWidth: Matrics.s(1),
          borderColor: colors.inactiveGray,
          marginLeft: Matrics.s(12),
        }}>
        <Text
          style={{
            fontFamily: Fonts.MEDIUM,
            fontSize: Matrics.mvs(12),
          }}>
          {dayName}
        </Text>
        <Text>{date}</Text>
      </TouchableOpacity>
    );
  };

  const renderSlots = ({item, index}: {item: SlotsType; index: number}) => {
    return (
      <TouchableOpacity
        style={{
          backgroundColor: colors.white,
          alignItems: 'center',
          justifyContent: 'center',
          borderRadius: Matrics.s(10),
          borderWidth: Matrics.s(1),
          borderColor: colors.inactiveGray,
          padding: Matrics.s(6),
          marginRight: Matrics.s(6),
        }}>
        <Text>{item.time}</Text>
      </TouchableOpacity>
    );
  };

  const renderItem = ({item, index}: {item: CoachDataType; index: number}) => {
    const {coachDetails, slots} = item;
    const {languages, level, name, profile, type} = coachDetails;
    const dates = timeFrom(7);
    return (
      <View
        style={{
          backgroundColor: colors.white,
          flex: 1,
          marginHorizontal: Matrics.s(15),
          paddingVertical: Matrics.s(15),
          borderRadius: Matrics.s(15),
        }}>
        <View
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            paddingHorizontal: Matrics.s(15),
          }}>
          <Image
            source={profile}
            style={{
              height: Matrics.vs(50),
              width: Matrics.s(50),
            }}
            resizeMode="contain"
          />
          <View
            style={{
              flex: 1,
              marginLeft: Matrics.s(10),
            }}>
            <Text
              numberOfLines={1}
              style={{
                fontFamily: Fonts.BOLD,
                fontSize: Matrics.mvs(14),
                fontWeight: '500',
                color: colors.black,
                maxWidth: Matrics.s(240),
              }}>
              {name}
            </Text>
            <View
              style={{
                flexDirection: 'row',
                alignItems: 'center',
              }}>
              <Text
                numberOfLines={1}
                style={{
                  fontFamily: Fonts.REGULAR,
                  fontSize: Matrics.mvs(11),
                  color: colors.subTitleLightGray,
                  lineHeight: Matrics.vs(20),
                  maxWidth: Matrics.s(110),
                }}>
                {type}
              </Text>
              <View
                style={{
                  width: Matrics.s(4),
                  height: Matrics.s(4),
                  borderRadius: Matrics.s(4),
                  backgroundColor: colors.inactiveGray,
                  marginHorizontal: Matrics.s(5),
                }}
              />
              <Text
                numberOfLines={1}
                style={{
                  fontFamily: Fonts.REGULAR,
                  fontSize: Matrics.mvs(11),
                  color: colors.subTitleLightGray,
                  lineHeight: Matrics.vs(20),
                  maxWidth: Matrics.s(110),
                }}>
                {level}
              </Text>
            </View>
            {renderLanguage(languages)}

            {/* <View style={{flexWrap: 'wrap', flexDirection: 'row'}}>
              {languages.map(renderLanguage)}
            </View> */}
          </View>
        </View>
        <View style={[styles.seprator]} />
        <FlatList
          data={dates}
          renderItem={renderDays}
          horizontal
          showsHorizontalScrollIndicator={false}
          keyExtractor={(_item, index) => index.toString()}
        />
        <View style={styles.slotContainer}>
          <Text>Next Available Slots</Text>
          <FlatList
            data={slots.slice(0, 3)}
            renderItem={renderSlots}
            numColumns={3}
            style={{
              marginTop: Matrics.s(10),
            }}
            keyExtractor={(_item, index) => index.toString()}
          />
          {slots.length > 3 ? (
            <TouchableOpacity style={styles.viewAllTxtContainer}>
              <Text style={styles.viewAllSlotsTxt}>View All Slots</Text>
            </TouchableOpacity>
          ) : null}
        </View>
      </View>
    );
  };

  return (
    <View style={styles.container}>
      <AppointmentHeader
        onPress={() => {
          navigation.goBack();
        }}
        title={`Appointment with ${type}`}
      />
      <FlatList
        data={CoachData}
        renderItem={renderItem}
        keyExtractor={(_item, index) => index.toString()}
        ItemSeparatorComponent={() => {
          return <View style={styles.itemSeprator} />;
        }}
      />
    </View>
  );
};

export default AppointmentWithScreen;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.lightPurple,
  },
  itemSeprator: {
    height: Matrics.vs(11),
  },
  seprator: {
    height: Matrics.vs(0.5),
    backgroundColor: colors.lightGrey,
    marginVertical: Matrics.s(12),
    marginHorizontal: Matrics.s(15),
  },
  viewAllSlotsTxt: {
    color: colors.themePurple,
    fontWeight: '600',
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(14),
    lineHeight: Matrics.s(15),
  },
  viewAllTxtContainer: {
    alignSelf: 'center',
    marginTop: Matrics.s(10),
  },
  slotContainer: {
    marginTop: Matrics.s(15),
    marginHorizontal: Matrics.s(15),
  },
});
