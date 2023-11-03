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
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';

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
  const [bookmarked, setBookmarked] = React.useState<'Y' | 'N'>(
    learnItem.bookmarked,
  );

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
          learnItem.media[0].home_thumbnail_url
            ? { uri: learnItem.media[0].home_thumbnail_url }
            : require('../../assets/images/learnImage.jpg')
        }
        resizeMode={'cover'}
      />
      <View style={styles.detailsContainer}>
        <Text style={styles.itemTitle} numberOfLines={2} ellipsizeMode={'tail'}>
          {learnItem?.title || '-'}
        </Text>
        <Text
          numberOfLines={2}
          ellipsizeMode={'tail'}
          style={styles.itemDescription}>
          {(learnItem?.description || '').replace(/(<([^>]+)>)/gi, '')}
        </Text>
        <View style={styles.bottomContainer}>
          <Text style={styles.itemDescription}>
            {learnItem?.publish_date
              ? moment(learnItem?.publish_date).format('MMM D, yyyy')
              : '-'}
          </Text>
          <TouchableOpacity
            activeOpacity={0.6}
            onPress={() => {
              if (bookmarked === 'Y') {
                setBookmarked('N');
              } else {
                setBookmarked('Y');
              }
              onPressBookmark(learnItem);
            }}>
            {bookmarked === 'Y' ? (
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
    overflow: 'hidden',
  },
  imageStyle: {
    width: 100,
    height: '100%',
  },
  detailsContainer: {
    flex: 1,
    justifyContent: 'space-between',
    padding: 10,
  },
  itemTitle: {
    flex: 1,
    color: colors.black,
    fontFamily: 'SFProDisplay-Bold',
    fontSize: 14,
    lineHeight: 18,
  },
  itemDescription: {
    flex: 1,
    color: colors.darkGray,
    fontFamily: 'SFProDisplay-Semibold',
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
