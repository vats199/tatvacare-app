import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    ScrollView,
} from 'react-native';
import React, { useState, useRef, useCallback, useEffect } from 'react';
import DocumentPicker, {
    DirectoryPickerResponse,
    DocumentPickerResponse,
    isCancel,
    isInProgress,
} from 'react-native-document-picker';
import {
    DiagnosticStackParamList,
} from '../../interface/Navigation.interface';
import { StackScreenProps } from '@react-navigation/stack';
import Header from '../../components/atoms/Header';
import { Icons } from '../../constants/icons';
import { colors } from '../../constants/colors';
import LabTest from '../../components/organisms/LabTest';
import { Fonts } from '../../constants';
import { useApp } from '../../context/app.context';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import UploadPrescription from '../../components/molecules/UploadPrescription';
import FreeTest from '../../components/molecules/FreeTest';
import { BottomSheetModal } from '@gorhom/bottom-sheet';
import ImagePicker from 'react-native-image-crop-picker';
import PerscriptionBottomSheet from '../../components/organisms/PerscriptionBottomSheet';
import CommonBottomSheetModal from '../../components/molecules/CommonBottomSheetModal';
import FreeTestBottomSheet from '../../components/molecules/FreeTestBottomSheet';
import { Matrics } from '../../constants';
import MyStatusbar from '../../components/atoms/MyStatusBar';


type AllLabTestProps = StackScreenProps<
    DiagnosticStackParamList,
    'AllLabTestScreen'
>;

type TestItem = {
    id: number;
    title: string;
    description: string;
    newPrice: number;
    oldPrice: number;
    discount: number;
    isAdded: boolean;
};

type perscription = {
    id: number;
    uri?: string;
    date?: any
}

const AllLabTestScreen: React.FC<AllLabTestProps> = ({ route, navigation }) => {
    const [addedCartItem, setAddedCartItem] = useState<TestItem[]>([]);
    const bottomSheetModalRef = useRef<BottomSheetModal>(null);
    const [selectedBottomsheet, setSelectedBottomsheet] = useState<string>("");
    const [selectedImage, setSelectedImage] = useState<string>();
    const [result, setResult] = React.useState<
        Array<DocumentPickerResponse> | DirectoryPickerResponse | undefined | null
    >();
    const [uploadedPerscription, setUploadedPerscription] = useState<perscription[]>([]);
    const insets = useSafeAreaInsets();
    const { location } = useApp();
    const addedItem = addedCartItem.length;
    const snapPoints = (selectedBottomsheet === "FreeTest") ? ["31%"] : ['63%'];

    useEffect(() => {
        console.log(JSON.stringify(result, null, 2))
    }, [result])

    const handleError = (err: unknown) => {
        if (isCancel(err)) {
            console.warn('cancelled')
        } else if (isInProgress(err)) {
            console.warn('multiple pickers were opened, only the last will be considered')
        } else {
            throw err
        }
    }

    const selectImageFromCamera = async () => {
        try {
            const image = await ImagePicker.openCamera({
                width: 300,
                height: 400,
                cropping: true,
            });
            setNewPerscription(image.path);
            setSelectedImage(image.path);
            bottomSheetModalRef.current?.close();
        } catch (error) {
            console.log('Error selecting image from camera:', error);
        }
    }
    const setNewPerscription = (uri: string) => {
        const id = Math.floor(Math.random() * 1000);
        const today = new Date();
        const date = today.toISOString().split('T')[0];
        const newPrescription: perscription = {
            id,
            date,
            uri: uri,
        };
        setUploadedPerscription([...uploadedPerscription, newPrescription]);
    }

    const selectImageFromGallery = async () => {
        try {
            const image = await ImagePicker.openPicker({
                width: 300,
                height: 400,
                cropping: true,
            });
            setNewPerscription(image.path);
            setSelectedImage(image.path);
            bottomSheetModalRef.current?.close();
        } catch (error) {
            console.log('Error selecting image from gallery:', error);
        }
    }

    const onPressUploadFile = async () => {
        try {
            const pickerResult = await DocumentPicker.pickSingle({
                presentationStyle: 'fullScreen',
                copyTo: 'cachesDirectory',
            })
            console.log("hey", pickerResult.uri);
            setResult([pickerResult]);
            bottomSheetModalRef.current?.close();
        } catch (e) {
            handleError(e)
        }
    }
    const handleItemAdded = (item: TestItem) => {
        setAddedCartItem(prevAddedItems => [...prevAddedItems, item]);
    };
    const iconPress = () => { };
    const onPressUploadPerscription = useCallback(() => {
        setSelectedBottomsheet("Perscription");
        bottomSheetModalRef.current?.present();
    }, []);
    const onPressViewFreeTests = useCallback(() => {
        setSelectedBottomsheet("FreeTest");
        bottomSheetModalRef.current?.present();
    }, []);
    const onPressAdd = () => { };
    const onPressViewAll = () => {
        navigation.navigate("ViewAllTest");
    };
    const onBackPress = () => {
        navigation.goBack();
    };

    const onPressViewCart = () => {
        navigation.navigate('LabTestCart');
    };

    const onPressTest = () => {
        navigation.navigate("TestDetail");
    }
    const onPressSearchTab = () => {
        navigation.navigate('SearchLabTest');
    }


    return (
        <SafeAreaView edges={['top']} style={[styles.screen, { paddingBottom: insets.bottom == 0 ? Matrics.vs(20) : insets.bottom }]} >
            <MyStatusbar />
            <ScrollView showsVerticalScrollIndicator={false}>
                <Header
                    title="All Lab test"
                    isIcon={true}
                    icon={<Icons.Cart height={24} width={24} />}
                    containerStyle={styles.upperHeader}
                    titleStyle={styles.titleStyle}
                    onIconPress={iconPress}
                    onBackPress={onBackPress}
                />
                <View style={styles.location}>
                    <Icons.Location height={16} width={16} />
                    <Text style={styles.locationText}>{location.city} {location.pincode} </Text>
                    <Icons.dropArrow height={16} width={16} />
                </View>

                <View style={{ flex: 1, paddingHorizontal: Matrics.s(16) }}>
                    <TouchableOpacity
                        style={styles.searchContainer}
                        activeOpacity={1}
                        onPress={onPressSearchTab}>
                        <Icons.Search height={20} width={20} />

                        <Text style={styles.placeholderText}> Search for Tests, Health Packages</Text>
                    </TouchableOpacity>

                    <UploadPrescription onPressUpload={onPressUploadPerscription} />
                    <FreeTest onPressAdd={onPressAdd} onPressViewFreeTest={onPressViewFreeTests} />

                    <View style={styles.titleButtonStyle}>
                        <Text style={styles.title}>Liver Test</Text>
                        <TouchableOpacity onPress={onPressViewAll} >
                            <Text style={styles.textViewButton}>View all</Text>
                        </TouchableOpacity>
                    </View>

                    <LabTest title="Liver Test" onAdded={handleItemAdded} onPressTest={onPressTest} />

                    <View style={styles.titleButtonStyle}>
                        <Text style={styles.title}>Kidney Test</Text>
                        <TouchableOpacity  >
                            <Text style={styles.textViewButton}>View all</Text>
                        </TouchableOpacity>
                    </View>
                    <LabTest title="Kindney Test" onAdded={handleItemAdded} onPressTest={onPressTest} />
                </View>
            </ScrollView>
            {addedCartItem.length > 0 && (
                <View style={styles.belowContainer}>
                    <View>
                        <Text style={styles.testAddedText}>{addedItem} Test Added</Text>
                        <Text style={styles.textViewButton}> View Details</Text>
                    </View>
                    <TouchableOpacity
                        style={styles.viewCartButton}
                        onPress={onPressViewCart}>
                        <Text style={styles.viewCartText}>View Cart</Text>
                    </TouchableOpacity>
                </View>
            )}
            <CommonBottomSheetModal snapPoints={snapPoints} ref={bottomSheetModalRef}  >
                {
                    (selectedBottomsheet === 'Perscription') ? (
                        <PerscriptionBottomSheet
                            onPressChooseFromGallery={selectImageFromGallery}
                            onPressClickAPhoto={selectImageFromCamera}
                            onPressUploadaFile={onPressUploadFile}
                        />
                    ) : (
                        <FreeTestBottomSheet />
                    )
                }
            </CommonBottomSheetModal>
        </SafeAreaView>
    );
};

export default AllLabTestScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
    },
    upperHeader: {
        marginHorizontal: Matrics.s(15),
        marginTop: Matrics.s(15),
        marginBottom: Matrics.s(20)
    },
    titleStyle: {
        fontSize: Matrics.mvs(16),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: Matrics.s(20),
        lineHeight: Matrics.s(20)
    },
    location: {
        backgroundColor: colors.white,
        height: Matrics.vs(36),
        marginBottom: Matrics.s(10),
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: Matrics.s(20),
    },
    locationText: {
        fontSize: Matrics.mvs(12),
        fontWeight: "400",
        fontFamily: Fonts.BOLD,
        color: colors.subTitleLightGray,
        lineHeight: Matrics.s(16)
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: Matrics.s(12),
        paddingHorizontal: Matrics.s(10),
        marginBottom: Matrics.s(10),
        marginTop: Matrics.s(5),
        minHeight: Matrics.vs(44),
    },
    searchText: {
        color: colors.subTitleLightGray,
        marginLeft: Matrics.s(10),
    },
    titleButtonStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginTop: Matrics.s(25),
        marginBottom: Matrics.s(5)
    },
    title: {
        fontSize: Matrics.mvs(16),
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray
    },
    textViewButton: {
        fontSize: Matrics.mvs(12),
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },

    belowContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: Matrics.s(15),
        paddingVertical: Matrics.vs(10),
        backgroundColor: colors.white,
        elevation: Matrics.s(10),
        shadowColor: colors.labelDarkGray,
        shadowOffset: { width: 0, height: 1 }
    },
    viewCartButton: {
        paddingHorizontal: Matrics.s(16),
        paddingVertical: Matrics.s(12),
        backgroundColor: colors.themePurple,
        borderRadius: Matrics.s(16),
    },
    viewCartText: {
        fontFamily: Fonts.BOLD,
        fontWeight: '700',
        fontSize: Matrics.mvs(16),
        color: colors.white,
    },
    testAddedText: {
        fontSize: Matrics.mvs(14),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    placeholderText: {
        fontSize: Matrics.mvs(12),
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    },
});
