import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import {useApp} from '../../context/app.context';
import {Matrics} from '../../constants';

type HomeHeaderProps = {
  onPressLocation?: () => void;
  onPressBell?: () => void;
  onPressProfile?: () => void;
  userLocation?: any;
};

const DrawerHeader: React.FC<HomeHeaderProps> = ({
  onPressBell,
  onPressLocation,
  onPressProfile,
  userLocation,
}) => {
  const {location} = useApp();

  return (
    <View style={styles.rowBetween}>
      <View>
        <Icons.MyTatvaLogo />
      </View>
      <Icons.DrawerRightIcon />
    </View>
  );
};

export default DrawerHeader;

const styles = StyleSheet.create({
  headerContainer: {
    // display: 'flex',
    // flexDirection: 'row',
    // justifyContent: 'space-between',
    paddingTop: Matrics.vs(16),
  },
  locationContainer: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
  },
  locationText: {
    color: colors.subTitleLightGray,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rowBetween: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  bellContainer: {
    marginRight: 10,
  },
  profileImageContainer: {
    marginLeft: 10,
    borderRadius: 14,
    height: 28,
    width: 28,
    overflow: 'hidden',
  },
  userImg: {
    height: '100%',
    width: '100%',
  },
});
