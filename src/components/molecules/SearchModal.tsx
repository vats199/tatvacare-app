import { Modal, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import React from 'react'
import { Icons } from '../../constants/icons'
import AnimatedInputField from '../atoms/AnimatedInputField'
import { colors } from '../../constants/colors'

type SearchModalProps = {
    visible: boolean,
    setVisible: (value: boolean) => void,
    search: string,
    setSearch: (value: string) => void,
}

const SearchModal: React.FC<SearchModalProps> = ({ visible, setVisible, search, setSearch }) => {
    return (
        <Modal visible={visible} transparent={false} onRequestClose={() => { setVisible(false) }} animationType={"fade"}>
            <View style={styles.container}>
                <View style={styles.headerContainer}>
                    <TouchableOpacity activeOpacity={0.6} onPress={() => { setVisible(false) }}>
                        <Icons.BackIcon />
                    </TouchableOpacity>
                    <View style={styles.searchContainer}>
                        <AnimatedInputField
                            value={search}
                            onChangeText={e => setSearch(e)}
                            placeholder={'Find resources to manage your condition'}
                            style={styles.searchField}
                        />
                        {search && <TouchableOpacity activeOpacity={0.6} onPress={() => { setSearch('') }}>
                            <Icons.CloseIcon />
                        </TouchableOpacity>}
                    </View>
                </View>
            </View>
        </Modal>
    )
}

export default SearchModal

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F9F9FF'
    },
    headerContainer: {
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        gap: 15,
        padding: 20
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.subTitleLightGray,
        borderRadius: 12,
        paddingHorizontal: 10,
        flex: 1
    },
    searchField: {
        borderWidth: 0,
        flex: 1,
    },
})