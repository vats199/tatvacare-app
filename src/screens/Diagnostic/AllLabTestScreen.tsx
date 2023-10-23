import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    ScrollView,
    Image
} from 'react-native';
import React, { useState, useRef, useCallback, useMemo, useEffect } from 'react';
import DocumentPicker, {
    DirectoryPickerResponse,
    DocumentPickerResponse,
    isCancel,
    isInProgress,
    types,
} from 'react-native-document-picker'
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
import { SafeAreaView } from 'react-native-safe-area-context';
import UploadPrescription from '../../components/molecules/UploadPrescription';
import FreeTest from '../../components/molecules/FreeTest';
import { BottomSheetModal, BottomSheetModalProvider } from '@gorhom/bottom-sheet';
import ImagePicker from 'react-native-image-crop-picker';

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
// type prescription = {
//     date?: any;
//     items: {
//         id:number;
//         uri?: string;
//     }[];
// };
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

    console.log("item>>>", uploadedPerscription);
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

    const { location } = useApp();

    const snapPoints = (selectedBottomsheet === "FreeTest") ? ["20%", "30%"] : ["20%", '63%'];

    const selectImageFromCamera = async () => {
        try {
            const image = await ImagePicker.openCamera({
                width: 300,
                height: 400,
                cropping: true,
            });
            setNewPerscription(image.path);
            setSelectedImage(image.path);
        } catch (error) {
            console.log('Error selecting image from camera:', error);
        }
    }
    const setNewPerscription = (uri: string) => {
        const id = Math.floor(Math.random() * 1000);


        const today = new Date();
        console.log
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
            setResult([pickerResult])
        } catch (e) {
            handleError(e)
        }
    }


    const handleItemAdded = (item: TestItem) => {
        setAddedCartItem(prevAddedItems => [...prevAddedItems, item]);
    };


    const addedItem = addedCartItem.length;
    console.log(addedItem);
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
        console.log("pressed")
        navigation.navigate('LabTestCart', { item: addedCartItem });
    };

    const onPressTest = () => {
        // console.log("pressed");
        navigation.navigate("TestDetail");
    }


    return (
        <SafeAreaView edges={['top']} style={styles.screen}>
            <ScrollView>
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
                    <Icons.Location />
                </View>

                <View style={{ flex: 1, paddingHorizontal: 15 }}>
                    <TouchableOpacity
                        style={styles.searchContainer}
                        activeOpacity={1}
                        onPress={() => {
                            navigation.navigate('SearchLabTest');
                        }}>
                        <Icons.Search height={20} width={20} />
                        {/* <TextInput placeholder='Search for Tests, Health Packages' /> */}
                        <Text style={styles.placeholderText}> Search for Tests, Health Packages</Text>
                    </TouchableOpacity>

                    <UploadPrescription onPressUpload={onPressUploadPerscription} />
                    <FreeTest onPressAdd={onPressAdd} onPressViewFreeTest={onPressViewFreeTests} />

                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 20, marginBottom: 5 }}>
                        <Text style={styles.title}>Liver Test</Text>
                        <TouchableOpacity onPress={onPressViewAll} >
                            <Text style={styles.textViewButton}>View all</Text>
                        </TouchableOpacity>
                    </View>

                    <LabTest title="Liver Test" onAdded={handleItemAdded} onPressTest={onPressTest} />

                    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 20, marginBottom: 5 }}>
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
                        <Text>{addedItem} test added</Text>
                        <Text style={styles.textViewButton}> View Details</Text>
                    </View>
                    <TouchableOpacity
                        style={styles.viewCartButton}
                        onPress={onPressViewCart}>
                        <Text style={styles.viewCartText}>View cart</Text>
                    </TouchableOpacity>
                </View>
            )}
            <BottomSheetModalProvider>
                <BottomSheetModal
                    ref={bottomSheetModalRef}
                    index={1}
                    snapPoints={snapPoints}>
                    <View style={styles.contentContainer}>
                        {
                            (selectedBottomsheet === "Perscription") && (
                                <View style={{ padding: 15 }}>
                                    <Text style={styles.bottomSheetTitle}>Upload Perscription</Text>
                                    <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                                        <Icons.Camera />
                                        <TouchableOpacity
                                            onPress={selectImageFromCamera}>
                                            <Text style={styles.subTitle}>Click a Photo</Text>
                                        </TouchableOpacity>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                                        <Icons.Gallery />
                                        <TouchableOpacity
                                            onPress={selectImageFromGallery}>
                                            <Text style={styles.subTitle}>Choose from Gallery</Text>
                                        </TouchableOpacity>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                                        <Icons.File />
                                        <TouchableOpacity onPress={onPressUploadFile}>
                                            <Text style={styles.subTitle}>Upload File</Text>
                                        </TouchableOpacity>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: "center", marginVertical: 5 }}>
                                        <Icons.Article />
                                        <TouchableOpacity onPress={() => navigation.navigate("MyPerscription", { data: uploadedPerscription })}>
                                            <Text style={styles.subTitle}>My Prescriptions</Text>
                                        </TouchableOpacity>
                                    </View>

                                    <View>
                                        <Text style={styles.guidePerscriptionTitle}>Guide for a valid prescription</Text>

                                        <Text style={styles.guideSubtitle}>{'\u2022'}  Don't crop out any part of the image</Text>
                                        <Text style={styles.guideSubtitle}>{'\u2022'}  Avoid blurred image</Text>
                                        <Text style={styles.guideSubtitle}>{'\u2022'}  Include details of doctor and patient + clinic visit date</Text>
                                        <Text style={styles.guideSubtitle}>{'\u2022'}  Medicines will be dispensed as per prescription</Text>
                                        <Text style={styles.guideSubtitle}>{'\u2022'}  Supported files type: jpeg, jpg, png, pdf</Text>
                                        <Text style={styles.guideSubtitle}>{'\u2022'}  Maximum allowed file size: 5MB</Text>
                                    </View>
                                </View>
                            )
                        }
                        {
                            (selectedBottomsheet === 'FreeTest') && (
                                <View>
                                    <Text style={[styles.bottomSheetTitle, { marginLeft: 20 }]}>Free Tests</Text>
                                    <View style={styles.border} />
                                    <View style={{ padding: 10 }}>
                                        <Text style={[styles.subTitle, { marginVertical: 5 }]}>Test Name 1</Text>
                                        <Text style={[styles.subTitle, { marginVertical: 5 }]}>Test Name 2</Text>
                                        <Text style={[styles.subTitle, { marginVertical: 5 }]}>Test Name 3</Text>
                                    </View>
                                </View>
                            )
                        }
                    </View>
                </BottomSheetModal>
            </BottomSheetModalProvider>
        </SafeAreaView>
    );
};

export default AllLabTestScreen;

const styles = StyleSheet.create({
    screen: {
        flex: 1,
        backgroundColor: colors.lightGreyishBlue,
        marginBottom: 50
    },
    upperHeader: {
        marginHorizontal: 20,
        marginTop: 30,
        marginBottom: 20
    },
    titleStyle: {
        fontSize: 16,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginLeft: 20,
    },
    location: {
        backgroundColor: colors.white,
        height: 32,
        marginBottom: 10,
        flexDirection: 'row',
        alignItems: 'center',
        paddingHorizontal: 20,
    },
    searchContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: colors.white,
        borderWidth: 1,
        borderColor: colors.inputBoxLightBorder,
        borderRadius: 12,
        paddingHorizontal: 10,
        marginBottom: 10,
        marginTop: 5,
        minHeight: 44,
    },
    searchText: {
        color: colors.subTitleLightGray,
        marginLeft: 10,
    },
    title: {
        fontSize: 16,
        fontWeight: "700",
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray
    },
    textViewButton: {
        fontSize: 12,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.themePurple,
    },

    belowContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 15,
        paddingVertical: 10,
        backgroundColor: colors.white,
        elevation: 10,
        shadowColor: '#313131',
        shadowOffset: { width: 0, height: 1 }
    },
    viewCartButton: {
        paddingHorizontal: 16,
        paddingVertical: 12,
        backgroundColor: colors.themePurple,
        borderRadius: 16,
    },
    viewCartText: {
        fontFamily: Fonts.BOLD,
        fontWeight: '700',
        fontSize: 16,
        color: colors.white,
    },
    testAddedText: {
        fontSize: 14,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.darkGray,
    },
    placeholderText: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
    },
    contentContainer: {
        flex: 1,
        backgroundColor: colors.white,
        // padding: 15,
        elevation: 2
    },
    bottomSheetTitle: {
        fontSize: 20,
        fontWeight: '700',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginBottom: 10
    },
    subTitle: {
        fontSize: 14,
        fontWeight: '500',
        fontFamily: Fonts.BOLD,
        color: colors.inputValueDarkGray,
        marginLeft: 10
    },
    guidePerscriptionTitle: {
        fontSize: 15,
        fontWeight: '600',
        fontFamily: Fonts.BOLD,
        color: colors.labelDarkGray,
        marginTop: 25,
        marginBottom: 5
    },
    guideSubtitle: {
        fontSize: 12,
        fontWeight: '400',
        fontFamily: Fonts.BOLD,
        color: colors.inactiveGray,
        marginLeft: 4
    },
    border: {
        borderBottomWidth: 2,
        borderBottomColor: "#D7D7D7",
    },
    testText: {

    }
});
