import {Image, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import {useApp} from '../../context/app.context';

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
            {location?.city && location?.state
              ? `${location?.city}, ${location?.state}`
              : userLocation?.city && userLocation?.state
              ? `${userLocation?.city}, ${userLocation?.state}`
              : userLocation?.state
              ? `${userLocation?.state}`
              : `-`}
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
        {!userData?.profile_pic && (
          <TouchableOpacity
            activeOpacity={0.6}
            onPress={onPressProfile}
            style={styles.profileImageContainer}>
            <Icons.NoUserImage height={28} width={28} />
          </TouchableOpacity>
        )}
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
  notifCountBadgeText: {
    fontWeight: '700',
    color: colors.white,
    fontSize: 8,
    alignSelf: 'center',
  },
  locationText: {
    color: colors.subTitleLightGray,
    fontSize: 12,
    fontWeight: '400',
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
