import styled from 'styled-components/native';
import {Platform} from 'react-native';
export const Screen = styled.SafeAreaView`
  flex: 1;
  background-color: #f9f8fd;
`;

export const Container =
  Platform.OS == 'ios'
    ? styled.View`
        flex: 1;
        background-color: #f9f8fd;
        padding: 0px 0px 0px 0px;
      `
    : styled.View`
        flex: 1;
        background-color: #f9f8fd;
        padding: 0px 0px 70px 0px;
      `;
