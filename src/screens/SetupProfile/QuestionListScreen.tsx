import {FlatList, Text, View} from 'react-native';
import React, {useState} from 'react';
import {CompositeScreenProps} from '@react-navigation/native';
import {StackScreenProps} from '@react-navigation/stack';
import {useSafeAreaInsets, SafeAreaView} from 'react-native-safe-area-context';

import {
  AppStackParamList,
  SetupProfileStackParamList,
} from '../../interface/Navigation.interface';
import {QuestionOneScreenStyle as styles} from './styles';
import Button from '../../components/atoms/Button';
import {Constants, Matrics} from '../../constants';
import AuthHeader from '../../components/molecules/AuthHeader';
import SetupProfileHeading from '../../components/atoms/SetupProfileHeading';
import InputField from '../../components/atoms/AnimatedInputField';
import {colors} from '../../constants/colors';
import AnimatedDatePicker from '../../components/atoms/AnimatedDatePicker';
import {TouchableOpacity} from 'react-native';
import {Icons} from '../../constants/icons';
import QuestionData from './QuestionData.json';
type QuestionOneScreenProps = CompositeScreenProps<
  StackScreenProps<SetupProfileStackParamList, 'QuestionOneScreen'>,
  StackScreenProps<AppStackParamList, 'SetupProfileScreen'>
>;

const QuestionListScreen: React.FC<QuestionOneScreenProps> = ({
  navigation,
  route,
}) => {
  const insets = useSafeAreaInsets();

  // ==================== state ====================//
  const [name, setName] = useState<string>('');
  // const [email, setEmail] = useState<string>('');
  const [doctorCode, setDoctorCode] = useState<string>('');
  const [dob, setDob] = useState<string | null>(null);
  const [selectedGenderIndex, setSelectedGenderIndex] = useState<number | null>(
    null,
  );
  console.log(QuestionData, 'QuestionDataQuestionData');
  const isButtonDisable = React.useMemo(() => {
    return name != '' && dob != null && selectedGenderIndex != null;
  }, [name, dob, selectedGenderIndex]);

  const [arr, setArr] = useState(QuestionData.Question);

  // ==================== function ====================//
  const onChangeName = (text: string) => {
    setName(text);
  };

  // const onChangeEmail = (text: string) => {
  //   setEmail(text);
  // };

  const onChangeCode = (text: string) => {
    setDoctorCode(text);
  };

  const onPressGenderSelection = (index: number) => {
    setSelectedGenderIndex(index);
  };

  const renderItem = ({item, index}: {item: any; index: number}) => {
    return (
      <View>
        <View></View>
      </View>
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.container}>
        <AuthHeader
          onPressBack={() => {
            navigation.goBack();
          }}
          isShowSkipButton={true}
        />
      </View>
      <SetupProfileHeading title={arr[0].question} />

      <FlatList data={arr} renderItem={renderItem} />
      <Button
        title={'Next'}
        type={Constants.BUTTON_TYPE.SECONDARY}
        disabled={!isButtonDisable}
        buttonStyle={{marginBottom: insets.bottom == 0 ? Matrics.vs(16) : 0}}
      />
    </SafeAreaView>
  );
};

export default QuestionListScreen;
