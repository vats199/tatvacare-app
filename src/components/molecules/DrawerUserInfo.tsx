import {
  Alert,
  Image,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React from 'react';
import {colors} from '../../constants/colors';
import ImagePicker from 'react-native-image-crop-picker';
import {Icons} from '../../constants/icons';
import {navigateTo} from '../../routes/Router';
import {useApp} from '../../context/app.context';

type DrawerUserInfoProps = {};

const DrawerUserInfo: React.FC<DrawerUserInfoProps> = () => {
  const {userData} = useApp();

  const [image, setImage] = React.useState<string | null>(
    userData?.profile_pic,
  );

  const openPicker = () => {
    ImagePicker.openPicker({
      width: 300,
      height: 300,
      cropping: true,
    })
      .then(image => {
        setImage(image.path);
      })
      .catch(err => {
        console.log(err);
      });
  };

  const openCamera = () => {
    ImagePicker.openCamera({
      width: 300,
      height: 300,
      cropping: true,
    })
      .then(image => {
        setImage(image.path);
      })
      .catch(err => {
        console.log(err);
      });
  };

  const onPress = () => {
    Alert.alert('Choose', 'Please select one of the following to continue.', [
      {text: 'Open Camera', onPress: openCamera},
      {text: 'Open Gallery', onPress: openPicker},
      {text: 'Cancel'},
    ]);
  };
  const onPressProfile = () => {
    navigateTo('ProfileVC');
  };

  return (
    <TouchableOpacity
      style={styles.container}
      onPress={onPressProfile}
      activeOpacity={0.8}>
      {image ? (
        <Image
          source={{uri: image}}
          style={styles.image}
          resizeMode={'stretch'}
        />
      ) : (
        <Icons.NoProfilePhotoPlaceholder />
      )}
      <View style={styles.nameContainer}>
        <Text style={styles.name}>{userData?.name}</Text>
        <Text style={styles.number}>
          {userData?.country_code}-{userData?.contact_no}
        </Text>
      </View>
      <Icons.ChevronRightGrey />
    </TouchableOpacity>
  );
};

export default DrawerUserInfo;

const styles = StyleSheet.create({
  container: {
    marginHorizontal: 10,
    marginBottom: 5,
    padding: 10,
    backgroundColor: colors.white,
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 12,
  },
  image: {
    height: 48,
    width: 48,
    borderRadius: 24,
    backgroundColor: '#F9F9FF',
  },
  nameContainer: {
    flex: 1,
    padding: 10,
    justifyContent: 'space-between',
  },
  name: {
    color: colors.black,
    marginBottom: 5,
    fontSize: 16,
    fontWeight: '600',
  },
  number: {
    color: colors.subTitleLightGray,
    fontSize: 12,
    fontWeight: '300',
  },
});
