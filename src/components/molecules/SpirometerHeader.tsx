import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {Matrics} from '../../constants';

type SpirometerHeaderProps = {};

const SpirometerHeader: React.FC<SpirometerHeaderProps> = () => {
  return (
    <View style={styles.headerContainer}>
      <View style={styles.commonHeaderContainer}>
        <TouchableOpacity style={styles.menuIcon}>
          <Icons.Menu />
        </TouchableOpacity>
        <Icons.MyTatvaLogo
          style={{
            marginHorizontal: Matrics.s(15),
          }}
        />
      </View>
      <View style={styles.commonHeaderContainer}>
        <TouchableOpacity style={styles.bellIcon}>
          <Icons.Bell />
        </TouchableOpacity>
        <Image
          source={{uri: `https://randomuser.me/api/portraits/men/44.jpg`}}
          style={styles.userProfile}
          resizeMode={'cover'}
        />
      </View>
    </View>
  );
};

export default SpirometerHeader;

const styles = StyleSheet.create({
  headerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: Matrics.s(10),
    paddingHorizontal: Matrics.s(15),
  },
  commonHeaderContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  menuIcon: {
    paddingVertical: Matrics.s(5),
    marginTop: Matrics.s(2),
  },
  bellIcon: {
    paddingVertical: Matrics.s(5),
    marginTop: Matrics.s(2),
    marginHorizontal: Matrics.s(10),
  },
  userProfile: {
    height: Matrics.s(25),
    width: Matrics.s(25),
    borderRadius: Matrics.s(25),
    paddingVertical: Matrics.s(5),
    marginTop: Matrics.s(2),
  },
});
