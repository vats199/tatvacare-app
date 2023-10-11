import {
  Image,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  ViewStyle,
} from 'react-native';
import React from 'react';
import moment from 'moment';
import {Icons} from '../../constants/icons';
import {colors} from '../../constants/colors';
import RenderHTML from 'react-native-render-html';

type LearnItemProps = {
  learnItem: any;
  onPressBookmark: (data: any) => void;
  onPressItem: (contentId: string, contentType: string) => void;
  style?: ViewStyle;
};

const LearnItem: React.FC<LearnItemProps> = ({
  learnItem,
  onPressBookmark,
  onPressItem,
  style,
}) => {
  return (
    <TouchableOpacity
      activeOpacity={0.7}
      style={[styles.itemContainer, style]}
      onPress={() =>
        onPressItem(learnItem.content_master_id, learnItem.content_type)
      }>
      <Image
        style={styles.imageStyle}
        source={
          learnItem.url
            ? {uri: learnItem.url}
            : require('../../assets/images/learnImage.jpg')
        }
      />
      <View style={styles.detailsContainer}>
        <Text style={styles.itemTitle} numberOfLines={2} ellipsizeMode={'tail'}>
          {learnItem?.title || '-'}
        </Text>
        <RenderHTML source={learnItem?.description || ''} />
        <View style={styles.bottomContainer}>
          <Text style={styles.itemDescription}>
            {learnItem?.publish_date
              ? moment(learnItem?.publish_date).format('MMM D, yyyy')
              : '-'}
          </Text>
          <TouchableOpacity
            activeOpacity={0.6}
            onPress={() => {
              onPressBookmark(learnItem);
            }}>
            {learnItem.bookmarked === 'Y' ? (
              <Icons.BookmarkFilled height={20} width={20} />
            ) : (
              <Icons.Bookmark height={20} width={20} />
            )}
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );
};

export default LearnItem;

const styles = StyleSheet.create({
  itemContainer: {
    marginBottom: 5,
    backgroundColor: colors.white,
    borderRadius: 12,
    padding: 2,
    width: 260,
    minHeight: 120,
    marginRight: 15,
    flexDirection: 'row',
    alignItems: 'center',
  },
  imageStyle: {
    maxWidth: 100,
    borderTopLeftRadius: 12,
    borderBottomLeftRadius: 12,
  },
  detailsContainer: {
    flex: 1,
    justifyContent: 'space-between',
    padding: 10,
  },
  itemTitle: {
    flex: 1,
    color: colors.black,
    fontWeight: '600',
    fontSize: 14,
    lineHeight: 18,
  },
  itemDescription: {
    flex: 1,
    color: colors.darkGray,
    fontWeight: '300',
    fontSize: 10,
    lineHeight: 12,
  },
  bottomContainer: {
    flex: 1,
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
});
