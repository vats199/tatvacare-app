import {View, Text, StyleSheet, Image} from 'react-native';
import React from 'react';
import {Fonts, Matrics} from '../../constants';
import {colors} from '../../constants/colors';
import {Images} from '../../constants';

type DiscoverCardProps = {
  CardData: Object;
};
const DiscoverCard:React.FC<DiscoverCardProps> = ({CardData}) => {
  return (
    <View style={style.Container}>
      <View style={style.imageContainer}>
        <Image
          source={CardData?.icons}
          style={style.image}
          resizeMode="stretch"
        />
        <View style={style.tag}>
          <Text style={style.tagText}>LifeStyle</Text>
        </View>
      </View>
      <View style={style.textContainer}>
        <View style={style.discriptionContainer}>
          <View>
            <Text style={style.title}>{CardData.title}</Text>
            <Text style={style.discription} numberOfLines={2}>{CardData.discription}</Text>
          </View>
          <View style={style.iconContainer}>
            <View style={style.iconContainer}>
              <Image source={Images.Like} style={style.icon} />
              <Image source={Images.Save} style={style.icon} />
            </View>
            <View style={style.minStyleconatiner}>
              <Text style={style.minText}>{'0' + ' ' + 'min read'}</Text>
            </View>
          </View>
        </View>
      </View>
    </View>
  );
};

export default DiscoverCard;

const style = StyleSheet.create({
  Container: {
    height: Matrics.s(230),
    borderRadius: Matrics.mvs(8),
    marginHorizontal: Matrics.vs(15),

    marginBottom: Matrics.vs(15),
    //  shadowOffset: {width: -2, height: 4},
    // shadowColor: '#171717',
    // shadowOpacity: 0.2,
    // shadowRadius: 2,
    //  shadowColor: '#52006A',
    // elevation: 20,
  },
  imageContainer: {flex: 0.5},
  textContainer: {flex: 0.5},
  image: {
    height: '100%',
    width: '100%',
  },
  discriptionContainer: {
    margin: 10,
    flex: 1,
    justifyContent: 'space-between',
  },
  title: {
    fontFamily: Fonts.BOLD,
    fontSize: Matrics.mvs(13),
    fontWeight: '600',
    color: colors.darkBlue,
  },
  discription: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(12),
    fontWeight: '400',
    color: colors.darkBlue,
    marginTop: Matrics.vs(5),
  },
  iconContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  icon: {
    height: Matrics.vs(15),
    width: Matrics.vs(15),
    marginRight: Matrics.vs(5),
  },
  minStyleconatiner: {
    backgroundColor: colors.lightGrayBackgroundColor,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: Matrics.mvs(5),
  },
  minText: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(10),
    fontWeight: '400',
    color: colors.darkBlue,
    padding: Matrics.vs(5),
  },
  tag: {
    position: 'absolute',
    backgroundColor: colors.white,
    borderRadius: Matrics.mvs(3),
    top: Matrics.vs(10),
    left: Matrics.vs(10),
  },
  tagText: {
    fontFamily: Fonts.REGULAR,
    fontSize: Matrics.mvs(10),
    fontWeight: '400',
    color: colors.darkBlue,
    padding: Matrics.vs(5),
  },
});
