package com.mytatva.patient.utils.azure

import android.content.ContentResolver
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.core.net.toUri
import androidx.fragment.app.Fragment
import com.microsoft.azure.storage.CloudStorageAccount
import com.microsoft.azure.storage.blob.CloudBlobContainer
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.ui.base.BaseActivity
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File
import java.io.InputStream
import java.text.SimpleDateFormat
import java.util.*

class UploadToAzureStorage {

    companion object {
        /*val AZURE_CONTAINER = if (URLFactory.IS_PRODUCTION)
            "aztatva-prod-storage-container"
        else
            "mytatvahl-dev-storage-container"*/

        val AZURE_CONTAINER = if (URLFactory.ENVIRONMENT == URLFactory.Env.PRODUCTION)
            "aztatva-prod-storage-container"
        else if (URLFactory.ENVIRONMENT == URLFactory.Env.UAT)
            "aztatva-prod-storage-container"
        else
            "mytatvahl-dev-storage-container"


        const val PREFIX_DRUG = "drug"
        const val PREFIX_FOOD = "food"
        const val PREFIX_RECORD = "record"
        const val PREFIX_USER = "user"
        const val PREFIX_SUPPORT = "support"
        const val PREFIX_ASKANEXPERT = "askanexpert"

        val createFileName: String
            get() {
                val SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
                val salt = StringBuilder()
                val rnd = Random()
                while (salt.length < 10) {
                    val index = (rnd.nextFloat() * SALTCHARS.length).toInt()
                    salt.append(SALTCHARS[index])
                }
                try {
                    salt.append(SimpleDateFormat("yyMMddhhmmssMs", Locale.US).format(Date()))
                } catch (e: Exception) {
                }
                return salt.toString()
            }

    }

    /** ********************************************
     *  Storage name : developerstemp
     *  yOLHVXsNedswUpeXDAEAsido9gzPuHVYAXm5Ss6sLeo2M7eOZPEXxd+jyBAU7K5AYhbSrK+MJ2JyLdu8ym9r9g==
     *  Container name : mytatva-dev
     *  Portal :
     *  https://portal.azure.com/#@HYPERLINKINFOSYSTEMPRIVATEL.onmicrosoft.com/resource/subscriptions/17b483cb-a5d8-4663-9658-7893b4d58c0e/resourcegroups/mytatva-common/providers/Microsoft.Storage/storageAccounts/developerstemp/overview
     *  *********************************************
     *
     *  storage account : mytatvahldevstorage
     *  Container name : mytatvahl-dev-storage-container
     *  url : https://mytatvahldevstorage.blob.core.windows.net/
     *  Key : uV5ueScj6CaWDTm6TOF8JBYf2SrqhqN8yXMfNveXLH998gcLIz5pUkZkkjktZSDELOrLUhnTxuW2cw4OhTFFfg==
    Connection string : DefaultEndpointsProtocol=https;AccountName=mytatvahldevstorage;AccountKey=uV5ueScj6CaWDTm6TOF8JBYf2SrqhqN8yXMfNveXLH998gcLIz5pUkZkkjktZSDELOrLUhnTxuW2cw4OhTFFfg==;EndpointSuffix=core.windows.net
     *
     * ******PRODUCTION AZURE***************************************************
     *
     * AZURE_CONTAINER_ACCESS_KEYS = 'o0L6kqnwjBW96Ttj75eHWfJAWABK/1cUuFD658PDvtVbOuxWufQpvprhe7lMHsEsd1nE8SX3tJ5m+xg6VDcJeQ=='
     * AZURE_STORAGE = 'aztatvaprodstorage'
     * AZURE_CONTAINER = 'aztatva-prod-storage-container'
     *  ********************************************/

    fun uploadImage(
        fragment: Fragment,
        imagePath: String,
        imageContainer: String = AZURE_CONTAINER,
        fileName: String,
        /*prefix: String,*/
        success: () -> Unit,
        failure: (String) -> Unit,
    ) {

        val accountName =
            (fragment.requireActivity() as BaseActivity).firebaseConfigUtil.getAzureAccountName()
        /*if (URLFactory.IS_PRODUCTION)
            fragment.getString(R.string.azure_account_name)
        else
            fragment.getString(R.string.azure_account_name_dev)*/

        val accountKey =
            (fragment.requireActivity() as BaseActivity).firebaseConfigUtil.getAzureAccessKey()
        /*if (URLFactory.IS_PRODUCTION)
            fragment.getString(R.string.azure_access_key)
        else
            fragment.getString(R.string.azure_access_key_dev)*/

        GlobalScope.launch(Dispatchers.IO) {
            try {
                val imageStream: InputStream? =
                    fragment.requireActivity().contentResolver.openInputStream(File(imagePath).toUri())
                val imageLength = imageStream?.available()
                val azureConnectionURL =
                    ("DefaultEndpointsProtocol=https;" + "AccountName=${accountName};"
                            + "AccountKey=${accountKey}")
                val container: CloudBlobContainer =
                    getContainer(imageContainer, azureConnectionURL)!!

                container.createIfNotExists()
                val imageBlob = container.getBlockBlobReference(fileName)

                //val contentType = "image/png"
                val cR: ContentResolver = fragment.requireActivity().contentResolver!!
                val mime: MimeTypeMap = MimeTypeMap.getSingleton()
                //mime.getExtensionFromMimeType(cR.getType(File(imagePath).toUri()))
                val contentType = cR.getType(File(imagePath).toUri())

                Log.e("CONTENT_TYPE", "uploadImage: $contentType")
                imageBlob.properties.contentType = contentType
                imageBlob.upload(imageStream, imageLength!!.toLong())
                success.invoke()

            } catch (e: Exception) {
                Log.d("imageUploadError", "::" + e.message)
                failure.invoke(e.message.toString())
            }
        }
    }

    fun uploadImageMultiple(
        fragment: Fragment,
        imagePaths: List<String>,
        imageContainer: String = AZURE_CONTAINER,
        success: (fileNameList: List<String>) -> Unit,
        failure: (String) -> Unit,
    ) {

        val accountName =
            (fragment.requireActivity() as BaseActivity).firebaseConfigUtil.getAzureAccountName()
        /*if (URLFactory.IS_PRODUCTION)
            fragment.getString(R.string.azure_account_name)
        else
            fragment.getString(R.string.azure_account_name_dev)*/

        val accountKey =
            (fragment.requireActivity() as BaseActivity).firebaseConfigUtil.getAzureAccessKey()
        /*if (URLFactory.IS_PRODUCTION)
            fragment.getString(R.string.azure_access_key)
        else
            fragment.getString(R.string.azure_access_key_dev)*/

        val uploadedFileNameList = arrayListOf<String>()

        GlobalScope.launch(Dispatchers.IO) {
            imagePaths.forEachIndexed { index, imagePath ->
                try {
                    val imageStream: InputStream? =
                        fragment.requireActivity().contentResolver.openInputStream(File(imagePath).toUri())
                    val imageLength = imageStream?.available()
                    val azureConnectionURL =
                        ("DefaultEndpointsProtocol=https;" + "AccountName=${accountName};"
                                + "AccountKey=${accountKey}")
                    val container: CloudBlobContainer =
                        getContainer(imageContainer, azureConnectionURL)!!

                    container.createIfNotExists()

                    val fileName = "$createFileName.jpg"
                    val imageBlob = container.getBlockBlobReference(fileName)

                    val contentType = "image/png"
                    imageBlob.properties.contentType = contentType
                    imageBlob.upload(imageStream, imageLength!!.toLong())

                    uploadedFileNameList.add(fileName)

                    if (uploadedFileNameList.size == imagePaths.size) {
                        success.invoke(uploadedFileNameList)
                    }
                } catch (e: Exception) {
                    Log.d("imageUploadError", "::" + e.message)
                    failure.invoke(e.message.toString())
                }
            }
        }
    }


    private fun getContainer(
        imageContainer: String,
        azureConnectionURL: String,
    ): CloudBlobContainer? {
        // Retrieve storage account from connection-string.
        val storageAccount = CloudStorageAccount
            .parse(azureConnectionURL)
        // Create the blob client.
        val blobClient = storageAccount.createCloudBlobClient()
        // Get a reference to a container.
        // The container name must be lower case
        return blobClient.getContainerReference(imageContainer)
    }
}


/*
private fun updateUserProfileImage() {
        val fileName = createFileName(profileImage)
        UploadToAzureStorage().uploadImage(
                this,
                profileImage,
                ApiParameters.AZURE_CONTAINER,
                fileName,
                ApiParameters.EMPOWER_USER_PIC_PREFIX,
                {
                    var hashMap = HashMap<String, String>()
                    hashMap[ApiParameters.IMAGE] = fileName
                    homeViewModel.updateProfilePic(hashMap)
                },
                {
                    showLoading(false)
                    showSnackBar(it)
                })
    }
 */