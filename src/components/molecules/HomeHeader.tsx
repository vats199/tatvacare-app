import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import {useApp} from '../../context/app.context';
import {useIsFocused} from '@react-navigation/native';

type Location = {
  city?: string;
  country?: string;
  pincode?: string;
  state?: string;
};

type HomeHeaderProps = {
  onPressLocation: () => void;
  onPressBell: () => void;
  onPressProfile: () => void;
  userLocation: any;
};

const HomeHeader: React.FC<HomeHeaderProps> = ({
  onPressBell,
  onPressLocation,
  onPressProfile,
  userLocation,
}) => {
  const {location, userData} = useApp();

  const [userLoc, setUserLocation] = React.useState<Location>(userLocation);

  const unreadNotificationCount: number = userData?.unread_notifications ?? 0;

  return (
    <View style={styles.rowBetween}>
      <View>
        <Icons.MyTatvaLogo />
        <TouchableOpacity
          activeOpacity={0.6}
          style={styles.locationContainer}
          onPress={onPressLocation}>
          <Text style={styles.locationText}>
            {userLoc?.city && userLoc?.state
              ? `${userLoc?.city}, ${userLoc?.state}`
              : userLoc?.state
              ? `${userLoc?.state}`
              : location?.city && location?.state
              ? `${location?.city}, ${location?.state}`
              : `Select Location`}
          </Text>
          <Icons.Dropdown />
        </TouchableOpacity>
      </View>
      <View style={styles.row}>
        <TouchableOpacity
          activeOpacity={0.6}
          onPress={onPressBell}
          style={styles.bellContainer}>
          <Icons.Bell />
          {unreadNotificationCount > 0 && (
            <View style={styles.notifCountBadge}>
              <Text style={styles.notifCountBadgeText}>
                {unreadNotificationCount}
              </Text>
            </View>
          )}
        </TouchableOpacity>
        <TouchableOpacity
          activeOpacity={0.6}
          onPress={onPressProfile}
          style={styles.profileImageContainer}>
          {!userData?.profile_pic ? (
            <Icons.NoUserImage height={28} width={28} />
          ) : (
            <Image
              source={{uri: userData.profile_pic}}
              style={styles.image}
              resizeMode={'contain'}
            />
          )}
        </TouchableOpacity>
      </View>
    </View>
  );
};

export default HomeHeader;

const styles = StyleSheet.create({
  headerContainer: {
    flex: 1,
    // display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  locationContainer: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
  },
  notifCountBadge: {
    backgroundColor: colors.themePurple,
    height: 15,
    width: 15,
    borderRadius: 7.5,
    alignItems: 'center',
    justifyContent: 'center',
    position: 'absolute',
    top: -2.5,
    right: -2.5,
  },
  image: {
    height: 28,
    width: 28,
    borderRadius: 14,
    borderWidth: 0.5,
  },
  notifCountBadgeText: {
    fontFamily: 'SFProDisplay-Bold',
    color: colors.white,
    fontSize: 8,
    alignSelf: 'center',
  },
  locationText: {
    color: colors.subTitleLightGray,
    fontSize: 12,
    fontFamily: 'SFProDisplay-Semibold',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rowBetween: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
  },
  bellContainer: {
    marginRight: 10,
  },
  profileImageContainer: {
    marginLeft: 10,
    borderRadius: 14,
    height: 28,
    width: 28,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  userImg: {
    height: '100%',
    width: '100%',
  },
});
