import {FlatList, StyleSheet, Text, TouchableOpacity, View} from 'react-native';
import React from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {DrawerScreenProps} from '@react-navigation/drawer';
import {StackScreenProps} from '@react-navigation/stack';
import {
  AppStackParamList,
  DrawerParamList,
} from '../interface/Navigation.interface';
import {SafeAreaView} from 'react-native-safe-area-context';
import {colors} from '../constants/colors';
import {Icons} from '../constants/icons';
import {navigateToEngagement} from '../routes/Router';
import Home from '../api/home';
import LearnItem from '../components/atoms/LearnItem';

type AllLearnItemsScreenProps = CompositeScreenProps<
  DrawerScreenProps<DrawerParamList, 'AllLearnItemsScreen'>,
  StackScreenProps<AppStackParamList, 'DrawerScreen'>
>;

const AllLearnItemsScreen: React.FC<AllLearnItemsScreenProps> = ({
  navigation,
  route,
}) => {
  const [learnItems, setLearnItems] = React.useState<any[]>([]);

  const getLearnMoreData = async () => {
    const learnMore = await Home.getLearnMoreData({});
    setLearnItems(learnMore?.data);
  };

  const onPressLearnItem = (contentId: string, contentType: string) => {
    navigateToEngagement(contentId.toString());
  };

  const onPressBookmark = async (data: any) => {
    const payload = {
      content_master_id: data?.content_master_id,
      is_active: data?.bookmarked === 'Y' ? 'N' : 'Y',
    };
    const resp = await Home.addBookmark({}, payload);
    if (resp?.data) {
      getLearnMoreData();
    }
  };

  const renderLearnItem = ({index, item}: {item: any; index: number}) => {
    return (
      <LearnItem
        learnItem={item}
        onPressBookmark={onPressBookmark}
        onPressItem={onPressLearnItem}
        style={styles.learnItem}
      />
    );
  };

  React.useEffect(() => {
    getLearnMoreData();
  }, []);

  return (
    <SafeAreaView edges={['top', 'bottom']} style={styles.screen}>
      <View style={styles.screen}>
        <View style={styles.row}>
          <TouchableOpacity
            onPress={() => navigation.goBack()}
            style={styles.closeBtn}>
            <Icons.CloseIcon height={18} width={18} />
          </TouchableOpacity>
          <Text style={styles.learnTitle}>Learn</Text>
        </View>

        <FlatList
          data={learnItems}
          keyExtractor={(_item, index) => index.toString()}
          renderItem={renderLearnItem}
          ItemSeparatorComponent={() => <View style={styles.sep} />}
          contentContainerStyle={styles.flatlist}
        />
      </View>
    </SafeAreaView>
  );
};

export default AllLearnItemsScreen;

const styles = StyleSheet.create({
  screen: {
    flex: 1,
    backgroundColor: '#f9f8fd',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  closeBtn: {
    padding: 12,
  },
  learnTitle: {
    fontWeight: '700',
    fontSize: 20,
    color: colors.black,
  },
  learnItem: {
    width: '90%',
    alignSelf: 'center',
    marginRight: 0,
    marginBottom: 0,
  },
  sep: {
    height: 10,
  },
  flatlist: {
    paddingBottom: 10,
  },
});
