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
import {Fonts, Matrics} from '../../constants';

type DrawerUserInfoProps = {};

const DrawerUserInfo: React.FC<DrawerUserInfoProps> = () => {
  const [image, setImage] = React.useState<string | null>(null);

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
  const onPressIcon = () => {
    navigateTo('ProfileVC');
  };

  return (
    <View style={styles.container}>
      {image ? (
        <Image
          source={{uri: image}}
          style={styles.image}
          resizeMode={'contain'}
        />
      ) : (
        <TouchableOpacity
          style={styles.image}
          activeOpacity={0.7}
          onPress={onPress}>
          <Icons.NoProfilePhotoPlaceholder />
        </TouchableOpacity>
      )}
      <View style={styles.nameContainer}>
        <Text style={styles.name}>Rashi Atry</Text>
        <Text style={styles.number}>+91-9999999999</Text>
      </View>
      <TouchableOpacity onPress={onPressIcon}>
        <Icons.ChevronRightGrey />
      </TouchableOpacity>
    </View>
  );
};

export default DrawerUserInfo;

const styles = StyleSheet.create({
  container: {
    marginHorizontal: Matrics.s(12),
    marginBottom: Matrics.vs(5),
    paddingVertical: Matrics.vs(10),
    paddingHorizontal: Matrics.s(12),
    backgroundColor: colors.white,
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: Matrics.mvs(12),
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
    marginBottom: Matrics.vs(5),
    fontSize: Matrics.mvs(16),
    fontFamily: Fonts.MEDIUM,
  },
  number: {
    color: colors.lightGrey,
    fontSize: Matrics.mvs(12),
    fontFamily: Fonts.REGULAR,
  },
});
