package com.mytatva.patient.utils.imagepicker

import android.Manifest
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.graphics.*
import android.media.ExifInterface
import android.media.MediaMetadataRetriever
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.provider.Settings
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AlertDialog
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.fragment.app.FragmentManager
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.databinding.DialogFilePickerBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.imagepicker.Utils.APP_DIRECTORY
import com.yalantis.ucrop.UCrop
import java.io.*
import java.text.SimpleDateFormat
import java.util.*

class ImageAndVideoPicker : BottomSheetDialogFragment() {

    private var _binding: DialogFilePickerBinding? = null

    private val binding: DialogFilePickerBinding
        get() = _binding!!

    /**
     * *****************
     */
    internal var isVideo = false
    internal var isImage = false
    internal var isDocument = false
    internal var isCustomCrop = false
    internal var isMultipleSelection = false
    internal var imagePickerResult: ImageVideoPickerResult? = null

    fun pickImage(isSelect: Boolean): ImageAndVideoPicker {
        isImage = isSelect
        return this
    }

    fun pickVideo(isSelect: Boolean): ImageAndVideoPicker {
        isVideo = isSelect
        return this
    }

    fun pickDocument(isSelect: Boolean): ImageAndVideoPicker {
        isDocument = isSelect
        return this
    }

    fun allowMultiple(): ImageAndVideoPicker {
        isMultipleSelection = true
        return this
    }

    fun setResult(imagePickerResult: ImageVideoPickerResult?): ImageAndVideoPicker {
        this.imagePickerResult = imagePickerResult
        return this
    }

    /**
     * *****************
     */

    internal var selectedImage: Uri? = null
    private var isclicked: Boolean = false
    private var selectedImagePath: String? = null
    internal lateinit var imageUri: Uri
    private var seconds = 0
    internal var mCurrentPhotoPath: String? = null

    // length of the random string.


    val filename: String
        get() {
            val file = File(
                context?.getExternalFilesDir(Environment.DIRECTORY_PICTURES)?.path,
                "$APP_DIRECTORY"
            )
            if (!file.exists()) {
                file.mkdirs()
            }
            return file.absolutePath + "/" + System.currentTimeMillis() + ".jpg"
        }

    fun setImageCallBack(imageVideoPickerResult: ImageVideoPickerResult?) {
        /*this.imageCallBack = imageCallBack*/
        this.imagePickerResult = imageVideoPickerResult
    }

    fun setCustomCrop(customCrop: Boolean) {
        isCustomCrop = customCrop
    }

    //camera pick image
    lateinit var takePhoto: ActivityResultLauncher<Uri?>
    val cameraImageFileName: String
        get() = UUID.randomUUID().toString() + ".jpg"
    var cameraImageFilePath: String = ""

    //permission  ===============================
    private var readPermissionGranted = false
    private var writePermissionGranted = false
    private var cameraPermissionGranted = false
    private lateinit var permissionLauncher: ActivityResultLauncher<Array<String>>

    val hasReadPermission: Boolean
        get() {
            return ContextCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.READ_EXTERNAL_STORAGE
            ) == PackageManager.PERMISSION_GRANTED
        }

    val hasWritePermission: Boolean
        get() {
            return ContextCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.WRITE_EXTERNAL_STORAGE
            ) == PackageManager.PERMISSION_GRANTED
        }

    val minSdk29: Boolean
        get() = Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q

    val hasCameraPermission: Boolean
        get() {
            return ContextCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.CAMERA
            ) == PackageManager.PERMISSION_GRANTED
        }

    //==========================================
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        takePhoto = registerForActivityResult(ActivityResultContracts.TakePicture()) { result ->
            dismiss()
            if (result) {
                /*cropImage(Uri.fromFile(File(cameraImageFilePath)))*/
                val compressedImage = compressImage(cameraImageFilePath)
                if (isValidFileSize(compressedImage)) {
                    imagePickerResult?.onImagesSelected(arrayListOf(compressedImage))
                } else {
                    imagePickerResult?.onFail("Please select image with size lower then 6 MB")
                }
            } else {
                imagePickerResult?.onFail("")
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?,
    ): View {
        _binding = DialogFilePickerBinding.inflate(inflater, container, false)
        dialog?.requestWindowFeature(Window.FEATURE_NO_TITLE)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initUI()

        permissionLauncher =
            registerForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { permissions ->

                readPermissionGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU)
                    permissions[Manifest.permission.READ_MEDIA_IMAGES] ?: readPermissionGranted
                else
                    permissions[Manifest.permission.READ_EXTERNAL_STORAGE] ?: readPermissionGranted

                writePermissionGranted = permissions[Manifest.permission.WRITE_EXTERNAL_STORAGE]
                    ?: writePermissionGranted
                cameraPermissionGranted = permissions[Manifest.permission.CAMERA]
                    ?: cameraPermissionGranted

                if (!readPermissionGranted || !writePermissionGranted || !cameraPermissionGranted) {
                    Toast.makeText(
                        requireContext(),
                        "Please grant camera & storage permissions",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        updateOrRequestPermission()

        // view listeners
        binding.apply {
            imageViewCamera.setOnClickListener { onClick(it) }
            imageViewGallery.setOnClickListener { onClick(it) }
            imageViewVideoCamera.setOnClickListener { onClick(it) }
            imageViewVideoGallery.setOnClickListener { onClick(it) }
            textViewUploadDocument.setOnClickListener { onClick(it) }
        }
    }

    private fun updateOrRequestPermission() {
        readPermissionGranted = hasReadPermission
        writePermissionGranted = hasWritePermission || minSdk29
        cameraPermissionGranted = hasCameraPermission

        val permissionsToRequest = mutableListOf<String>()
        if (!writePermissionGranted) {
            permissionsToRequest.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        }
        if (!readPermissionGranted) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                permissionsToRequest.add(Manifest.permission.READ_MEDIA_IMAGES)
            }
            permissionsToRequest.add(Manifest.permission.READ_EXTERNAL_STORAGE)
        }
        if (!cameraPermissionGranted) {
            permissionsToRequest.add(Manifest.permission.CAMERA)
        }
        if (permissionsToRequest.isNotEmpty()) {
            permissionLauncher.launch(permissionsToRequest.toTypedArray())
        }
    }

    private fun initUI() {
        with(binding) {
            if (isImage) {
                textViewLabelImage.visibility = View.VISIBLE
                constrainLayoutImage.visibility = View.VISIBLE
            } else {
                textViewLabelImage.visibility = View.GONE
                constrainLayoutImage.visibility = View.GONE
            }

            if (isVideo) {
                textViewLabelVideo.visibility = View.VISIBLE
                constrainLayoutVideo.visibility = View.VISIBLE
            } else {
                textViewLabelVideo.visibility = View.GONE
                constrainLayoutVideo.visibility = View.GONE
            }

            if (isDocument) {
                textViewUploadDocument.visibility = View.VISIBLE
            } else {
                textViewUploadDocument.visibility = View.GONE
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        isclicked = false

        when (requestCode) {
            RequestCode.REQUEST_PICK_DOC -> {
                if (data != null) {
                    val selectedDocUri = data?.data
                    val docPath = Utils.getFileFromStorage(requireContext(), selectedDocUri!!)
                    //FileUtils.getFilePathFromURI(activity, selectedDocUri!!)
                    imagePickerResult?.onDocumentSelected(arrayListOf(docPath ?: ""))
                    dismiss()
                }
            }

            RequestCode.REQUEST_PICK_DOC_MULTIPLE -> {
                if (data != null) {
                    imagePickerResult?.onDocumentSelected(getSelectedDocs(data) as ArrayList<String>)
                    dismiss()
                }
            }

            RequestCode.TAKE_CAMERA_VIDEO -> {
                try {
                    selectedImage = imageUri /*data!!.data*/
                    val path = FileUtils.getFilePathFromURI(activity, selectedImage)
                    imagePickerResult!!.onVideoSelected(arrayListOf(path))
                    dismiss()
                } catch (e: Exception) {
                    Log.d("ERROR", ":::" + e.message)
                }
            }

            RequestCode.SELECT_SINGLE_VIDEO -> {
                try {
                    val uri = data!!.data
                    val path = FileUtils.getPath(activity, uri)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }

            RequestCode.SELECT_VIDEOS_KITKAT_MULTIPLE, RequestCode.SELECT_VIDEOS_MULTIPLE -> {
                // when single video selected then crop
                if (data != null) {
                    handleSelectedVideos(data)
                }
            }

            RequestCode.SELECT_IMAGES_KITKAT_MULTIPLE, RequestCode.SELECT_IMAGES_MULTIPLE -> {
                if (data != null) {
                    handleSelectedImages(data)
                    /*imagePickerResult?.onMultipleImagesSelected(
                            getSelectedImages(requestCode, data) as ArrayList<String>)
                    dismiss()*/
                }
            }

            UCrop.REQUEST_CROP -> {
                if (data != null) {
                    val resultUri = UCrop.getOutput(data)
                    try {
                        /*mCurrentPhotoPath = FileUtils.getPath(context, resultUri)*/
                        resultUri?.let {
                            Utils.getFileFromStorage(requireActivity(), it) { path ->
                                imagePickerResult!!.onImagesSelected(arrayListOf(path))
                                dismiss()
                            }
                        }
                        /*mCurrentPhotoPath = compressImage(mCurrentPhotoPath)*/
                        /*arrayListOf(mCurrentPhotoPath ?: "").let {
                            imagePickerResult!!.onImagesSelected(it)
                        }*/

                    } catch (e: Exception) {
                        e.printStackTrace()
                        dismiss()
                    }
                } else {
                    dismiss()
                }
            }

            else -> {
                Log.d("ERROR", "ImageAndVideoPicker :: Invalid request code")
                dismiss()
            }
        }
    }

    private fun getSelectedDocs(data: Intent): List<String> {

        val result = ArrayList<String>()

        val clipData = data.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount/*int i=0;i<clipData.getItemCount();i++*/) {
                val videoItem = clipData.getItemAt(i)
                val docUri = videoItem.uri
                docUri?.let {
                    val filePath = Utils.getFileFromStorage(requireContext(), it)
                    result.add(filePath ?: "")
                }

            }
        } else {
            val docUri = data.data
            docUri?.let {
                val filePath = Utils.getFileFromStorage(requireContext(), it)
                result.add(filePath ?: "")
            }
        }

        return result
    }


    private fun getSelectedVideos(requestCode: Int, data: Intent): List<String> {
        val result = ArrayList<String>()
        val clipData = data.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount/*int i=0;i<clipData.getItemCount();i++*/) {
                val videoItem = clipData.getItemAt(i)
                val videoURI = videoItem.uri
                videoURI?.let {
                    val filePath = Utils.getFileFromStorage(requireContext(), it)
                    result.add(filePath ?: "")
                }
            }
        } else {
            val videoURI = data.data
            videoURI?.let {
                val filePath = Utils.getFileFromStorage(requireContext(), it)
                result.add(filePath ?: "")
            }
        }
        return result
    }

    private fun getSelectedImages(requestCode: Int, data: Intent): List<String> {
        val result = ArrayList<String>()
        val clipData = data.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount/*int i=0;i<clipData.getItemCount();i++*/) {
                val imageItem = clipData.getItemAt(i)
                val imageURI = imageItem.uri
                imageURI?.let {
                    val filePath = Utils.getFileFromStorage(requireContext(), it)
                    result.add(filePath ?: "")
                }
            }
        } else {
            val imageURI = data.data
            imageURI?.let {
                val filePath = Utils.getFileFromStorage(requireContext(), it)
                result.add(filePath ?: "")
            }
        }
        return result
    }


    private fun handleSelectedImages(data: Intent) {
        val result = ArrayList<String>()
        val resultUri = ArrayList<Uri>()
        val clipData = data.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount/*int i=0;i<clipData.getItemCount();i++*/) {

                val imageItem = clipData.getItemAt(i)
                val imageURI = imageItem.uri
                /*resultUri.add(imageURI)
                imagePickerResult?.onImagesUriSelected(resultUri)
                dismiss()*/
                imageURI?.let {
                    (activity as BaseActivity).toggleLoader(true)
                    Utils.getFileFromStorage(requireActivity(), it) { path ->
                        val compressedFilePath = compressImage(path)
                        result.add(compressedFilePath)
                        if (i == clipData.itemCount - 1) {
                            (activity as BaseActivity).toggleLoader(false)
                            imagePickerResult?.onImagesSelected(result)
                            dismiss()
                        }
                    }
                }
            }
        } else {
            val imageURI = data.data

            /*imageURI?.let {
                val compressedFilePath = compressImageFromURI(imageURI)
                result.add(compressedFilePath)
                imagePickerResult?.onImagesSelected(result)
                dismiss()
            }*/

            imageURI?.let {
                (activity as BaseActivity).toggleLoader(true)
                Utils.getFileFromStorage(requireActivity(), it) { path ->
                    val compressedFilePath = compressImage(path)
                    result.add(compressedFilePath)
                    (activity as BaseActivity).toggleLoader(false)
                    imagePickerResult?.onImagesSelected(result)
                    dismiss()
                }
            }
        }
    }

    private fun handleSelectedVideos(data: Intent) {
        val result = ArrayList<String>()
        val clipData = data.clipData
        if (clipData != null) {
            for (i in 0 until clipData.itemCount/*int i=0;i<clipData.getItemCount();i++*/) {
                val videoUri = clipData.getItemAt(i)
                val imageURI = videoUri.uri
                imageURI?.let {
                    Utils.getFileFromStorage(requireContext(), it) { path ->
                        result.add(path)
                        if (i == clipData.itemCount - 1) {
                            imagePickerResult?.onVideoSelected(result)
                            dismiss()
                        }
                    }
                }
            }
        } else {
            val videoUri = data.data
            videoUri?.let {
                Utils.getFileFromStorage(requireContext(), it) { path ->
                    result.add(path)
                    imagePickerResult?.onVideoSelected(result)
                    dismiss()
                }
            }
        }
    }

    fun toCheckVideoLength(data: Uri): Int {
        try {
            val retriever = MediaMetadataRetriever()
            retriever.setDataSource(requireActivity().application, data)
            val mp = MediaPlayer.create(requireActivity().baseContext, data)
            val millis = mp.duration
            val video = FileUtils.getPath(activity, data)
            seconds = millis / 1000
            return if (seconds > 60) {
                60
            } else {
                seconds
            }
        } catch (e: Exception) {
            e.printStackTrace()
            return 0
        }
    }


    @Throws(IOException::class)
    private fun getBitmapFromUri(uri: Uri): Bitmap {
        val parcelFileDescriptor = requireContext().contentResolver.openFileDescriptor(uri, "r")
        val fileDescriptor = parcelFileDescriptor!!.fileDescriptor
        val image = BitmapFactory.decodeFileDescriptor(fileDescriptor)
        parcelFileDescriptor.close()
        return image
    }

    fun getCompressedBitmapFromPath(imagePath: String?): Bitmap {
        val bmOptions = BitmapFactory.Options()
        var bitmap = BitmapFactory.decodeFile(imagePath, bmOptions)
//       bitmap = Bitmap.createScaledBitmap(bitmap, 360, 360, true)
        var out = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out)
        var compressedBitmap = BitmapFactory.decodeStream(ByteArrayInputStream(out.toByteArray()))
        return compressedBitmap
    }

    fun storeImageToCache(data: Bitmap): String? {
        var thumbnail: Bitmap? = null
        try {
            val dateTime = Date()
            thumbnail = data
            val bytes = ByteArrayOutputStream()
            val filenamePath = /*"tmp2" + dateTime.toString()*/ randomFileName + ".jpg"
            thumbnail.compress(Bitmap.CompressFormat.JPEG, 90, bytes)
            val outputDir = requireContext().cacheDir
            val file = File(outputDir.path + "/" + filenamePath)
            file.createNewFile()
            val fo = FileOutputStream(file)
            fo.write(bytes.toByteArray())
            fo.close()
            return file.absolutePath.toString()
        } catch (e: Exception) {
            // TODO Auto-generated catch block
            e.printStackTrace()
            return null
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray,
    ) {
        /*super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            STORAGE_PERMISSION -> if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // selectImage();
                return
            } else {
                dismiss()
            }
        }*/

        if (requestCode == REQUEST_CAMERA_PERMISSION) {

            if (PermissionUtil.verifyPermissions(grantResults)) {
                dispatchTakePictureIntent()
            } else {
                setUpAlertDialog("Allow camera permission")
            }

        } else if (requestCode == REQUEST_GALLERY_PERMISSION) {

            if (PermissionUtil.verifyPermissions(grantResults)) {
                openGallory()
            } else {
                setUpAlertDialog("Allow storage permission")
            }

        } else if (requestCode == REQUEST_CAMERA_VIDEO_PERMISSION) {

            if (PermissionUtil.verifyPermissions(grantResults)) {
                takeCameraVideo()
            } else {
                setUpAlertDialog("Allow camera permission")
            }

        } else if (requestCode == REQUEST_GALLERY_VIDEO_PERMISSION) {

            if (PermissionUtil.verifyPermissions(grantResults)) {
                openVideoGallery()
            } else {
                setUpAlertDialog("Allow storage permission")
            }

        }

    }

    private fun setUpAlertDialog(message: String) {
        val alert = AlertDialog.Builder(requireActivity())
            .setPositiveButton("ok", DialogInterface.OnClickListener { dialogInterface, i ->
                dialogInterface.dismiss()
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                intent.data = Uri.parse("package:${BuildConfig.APPLICATION_ID}")
                startActivity(intent)
            })
            .setMessage(message)
            .setTitle(R.string.app_name)
            .create()

        alert.show()
    }

    override fun show(manager: FragmentManager, tag: String?) {
        if (manager.findFragmentByTag(tag) == null) {
            super.show(manager, tag)
        }
    }

    override fun dismiss() {
        super.dismissAllowingStateLoss()
    }

    override fun onDestroyView() {
        super.onDestroyView()
    }

    fun onClick(view: View) {
        when (view.id) {
            R.id.textViewUploadDocument -> {
                if (Build.VERSION.SDK_INT >= 23 && Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {

                    if (ActivityCompat.checkSelfPermission(
                            requireActivity(),
                            Manifest.permission.READ_EXTERNAL_STORAGE
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        requestPermissions(PERMISSIONS_DOCUMENT, REQUEST_CAMERA_PERMISSION)
                    } else {
                        pickDocument()
                    }

                } else {
                    pickDocument()
                }
            }

            R.id.imageViewCamera -> {

                if (Build.VERSION.SDK_INT >= 23) {

                    if (!cameraPermissionGranted) {
                        updateOrRequestPermission()
                    } else {
                        dispatchTakePictureIntent()
                    }

                } else
                    dispatchTakePictureIntent()
            }

            R.id.imageViewVideoCamera -> {
                if (Build.VERSION.SDK_INT >= 23) {

                    if (!cameraPermissionGranted) {
                        updateOrRequestPermission()
                    } else {
                        takeCameraVideo()
                    }

                } else
                    takeCameraVideo()
            }


            R.id.imageViewGallery -> {

                if (Build.VERSION.SDK_INT >= 23) {

                    if (!readPermissionGranted || (/*Build.VERSION.SDK_INT <= 28 && */!writePermissionGranted)) {
                        updateOrRequestPermission()
                    } else {
                        openGallory()
                    }

                } else {
                    openGallory()
                }
            }

            R.id.imageViewVideoGallery -> {

                if (Build.VERSION.SDK_INT >= 23) {

                    if (!readPermissionGranted || !writePermissionGranted) {
                        updateOrRequestPermission()
                    } else {
                        openVideoGallery()
                    }

                } else
                    openVideoGallery()
            }
        }
    }

    private fun pickDocument() {
        /* val allSupportedDocumentsTypesToExtensions = mapOf(
             "application/msword" to ".doc",
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document" to ".docx",
             "application/pdf" to ".pdf",
             "text/rtf" to ".rtf",
             "application/rtf" to ".rtf",
             "application/x-rtf" to ".rtf",
             "text/richtext" to ".rtf",
             "text/plain" to ".txt"
         )*/
        val allSupportedDocumentsTypesToExtensions = mapOf(
            "application/pdf" to ".pdf"
        )
        val supportedMimeTypes = allSupportedDocumentsTypesToExtensions.keys.toTypedArray()
//        val openDocumentIntent = Intent(Intent.ACTION_GET_CONTENT).apply {
//            addCategory(Intent.CATEGORY_OPENABLE)
//            type = "*/*"
//            putExtra(Intent.EXTRA_MIME_TYPES, supportedMimeTypes)
//            if (isMultipleSelection) {
//                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
//            }
//        }
        Intent.ACTION_GET_CONTENT
        val openDocumentIntent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, supportedMimeTypes)
            if (isMultipleSelection) {
                putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            }
        }


        if (isMultipleSelection) {
            startActivityForResult(openDocumentIntent, RequestCode.REQUEST_PICK_DOC_MULTIPLE)
        } else {
            startActivityForResult(openDocumentIntent, RequestCode.REQUEST_PICK_DOC)
        }
    }

    private fun openVideoGallery() {
        if (!isMultipleSelection) {
            // When single selection only
            val type = "video/*"
            val cameraVideoIntent =
                Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
            cameraVideoIntent.type = type
            cameraVideoIntent.putExtra("return-data", true)
            try {
                startActivityForResult(cameraVideoIntent, RequestCode.SELECT_SINGLE_VIDEO)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            // when multiple selection enabled
            if (Build.VERSION.SDK_INT < 19) {
                val intent = Intent()
                intent.type = "video/mp4"
                intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                intent.action = Intent.ACTION_GET_CONTENT
                startActivityForResult(
                    Intent.createChooser(intent, "Select videos"),
                    RequestCode.SELECT_VIDEOS_MULTIPLE
                )
            } else {
                val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
                intent.addCategory(Intent.CATEGORY_OPENABLE)
                intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
                intent.type = "video/mp4"
                startActivityForResult(intent, RequestCode.SELECT_VIDEOS_KITKAT_MULTIPLE)
            }
        }
    }

    private fun takeCameraVideo() {
        getSaveVideoUri()
        // start default camera
        Log.d(":::::", "" + selectedImagePath!!)
        val cameraIntent = Intent(MediaStore.ACTION_VIDEO_CAPTURE)
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri)
        cameraIntent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, 60)
        startActivityForResult(cameraIntent, RequestCode.TAKE_CAMERA_VIDEO)
    }

    fun getSaveVideoUri() {
        try {
            val root = File(
                activity?.getExternalFilesDir(Environment.DIRECTORY_MOVIES)
                    .toString() + "/${APP_DIRECTORY}/"
            )
            if (!root.exists()) {
                root.mkdirs()
            }
            val imageName = "video_" + System.currentTimeMillis() + ".mp4"
            val sdImageMainDirectory = File(root, imageName)
            val isNoget = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N
            if (isNoget) {
                imageUri = FileProvider.getUriForFile(
                    requireActivity(),
                    MyTatvaApp.FILE_PROVIDER_AUTHORITY,
                    sdImageMainDirectory
                )
                selectedImagePath = sdImageMainDirectory.absolutePath
            } else {
                imageUri = Uri.fromFile(sdImageMainDirectory)
                selectedImagePath = FileUtils.getPath(activity, imageUri)
            }
        } catch (e: Exception) {
            //  DebugLog.e("Incident Photo" + "Error occurred. Please try again later.");
        }
    }

    private fun openGallory() {
        // when multiple selection enabled
        if (Build.VERSION.SDK_INT < 19) {
            val intent = Intent()
            intent.type = FileUtils.MIME_TYPE_IMAGE
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, isMultipleSelection)
            intent.action = Intent.ACTION_GET_CONTENT
            try {
                startActivityForResult(
                    Intent.createChooser(intent, "Select images"),
                    RequestCode.SELECT_IMAGES_MULTIPLE
                )
            } catch (e: Exception) {
                //e.printStackTrace();
                dismiss()
                imagePickerResult!!.onFail("Fail to open gallery")
            }
        } else {
            val intent =
                Intent(Intent.ACTION_OPEN_DOCUMENT)/*Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI)*/
            intent.addCategory(Intent.CATEGORY_OPENABLE)
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, isMultipleSelection)
            intent.type = FileUtils.MIME_TYPE_IMAGE
            try {
                startActivityForResult(intent, RequestCode.SELECT_IMAGES_KITKAT_MULTIPLE)
            } catch (e: Exception) {
                //e.printStackTrace();
                dismiss()
                imagePickerResult!!.onFail("Fail to open gallery")
            }
        }
    }

    abstract class ImageVideoPickerResult {
        abstract fun onFail(message: String)
        open fun onVideoSelected(list: ArrayList<String>) {}
        open fun onImagesSelected(list: ArrayList<String>) {}
        open fun onDocumentSelected(list: ArrayList<String>) {}
    }

    private fun dispatchTakePictureIntent() {
        val file = File(activity?.filesDir, cameraImageFileName)
        val uri =
            FileProvider.getUriForFile(requireActivity(), MyTatvaApp.FILE_PROVIDER_AUTHORITY, file)
        cameraImageFilePath = file.path
        takePhoto.launch(uri)
    }

    fun getRealPathFromURI(context: Context, contentUri: Uri): String {
        var cursor: Cursor? = null
        try {
            val proj = arrayOf(MediaStore.Images.Media.DATA)
            cursor = context.contentResolver.query(contentUri, proj, null, null, null)
            val column_index = cursor!!.getColumnIndexOrThrow(MediaStore.Video.Media.DATA)
            cursor.moveToFirst()
            return cursor.getString(column_index)
        } finally {
            cursor?.close()
        }
    }

    fun compressImage(filePath: String): String {
        //return compressImageV2(filePath)
        /**
         * method requires EXTERNAL_STORAGE permission
         */

        var scaledBitmap: Bitmap? = null

        val options = BitmapFactory.Options()

        //      by setting this field as true, the actual bitmap pixels are not loaded in the memory. Just the bounds are loaded. If
        //      you try the use the bitmap here, you will get null.
        options.inJustDecodeBounds = true
        var bmp = BitmapFactory.decodeFile(filePath, options)


        var actualHeight = options.outHeight
        var actualWidth = options.outWidth

        //max Height and width values of the compressed image is taken as 816x612
        val maxHeight = 1920.0f//1280.0f;//816.0f;
        val maxWidth = 1080.0f//852.0f;//612.0f;

        var imgRatio = (actualWidth / actualHeight).toFloat()
        val maxRatio = maxWidth / maxHeight

        //width and height values are set maintaining the aspect ratio of the image
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                imgRatio = maxHeight / actualHeight
                actualWidth = (imgRatio * actualWidth).toInt()
                actualHeight = maxHeight.toInt()
            } else if (imgRatio > maxRatio) {
                imgRatio = maxWidth / actualWidth
                actualHeight = (imgRatio * actualHeight).toInt()
                actualWidth = maxWidth.toInt()
            } else {
                actualHeight = maxHeight.toInt()
                actualWidth = maxWidth.toInt()

            }
        }

        //setting inSampleSize value allows to load a scaled down version of the original image

        options.inSampleSize = calculateInSampleSize(options, actualWidth, actualHeight)

        //inJustDecodeBounds set to false to load the actual bitmap
        options.inJustDecodeBounds = false

        //this options allow android to claim the bitmap memory if it runs low on memory
        options.inPurgeable = true
        options.inInputShareable = true
        options.inTempStorage = ByteArray(16 * 1024)

        try {
            //          load the bitmap from its path
            bmp = BitmapFactory.decodeFile(filePath, options)
        } catch (exception: OutOfMemoryError) {
            exception.printStackTrace()
        }

        try {
            scaledBitmap = Bitmap.createBitmap(actualWidth, actualHeight, Bitmap.Config.ARGB_8888)
        } catch (exception: OutOfMemoryError) {
            exception.printStackTrace()
        }

        val ratioX = actualWidth / options.outWidth.toFloat()
        val ratioY = actualHeight / options.outHeight.toFloat()
        val middleX = actualWidth / 2.0f
        val middleY = actualHeight / 2.0f

        val scaleMatrix = Matrix()
        scaleMatrix.setScale(ratioX, ratioY, middleX, middleY)

        val canvas = Canvas(scaledBitmap!!)
        canvas.setMatrix(scaleMatrix)
        canvas.drawBitmap(
            bmp,
            middleX - bmp.width / 2,
            middleY - bmp.height / 2,
            Paint(Paint.FILTER_BITMAP_FLAG)
        )

        //check the rotation of the image and display it properly
        val exif: ExifInterface
        try {
            exif = ExifInterface(filePath)

            val orientation = exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION, 0
            )
            Log.d("EXIF", "Exif: " + orientation)
            val matrix = Matrix()
            if (orientation == 6) {
                matrix.postRotate(90f)
                Log.d("EXIF", "Exif: " + orientation)
            } else if (orientation == 3) {
                matrix.postRotate(180f)
                Log.d("EXIF", "Exif: " + orientation)
            } else if (orientation == 8) {
                matrix.postRotate(270f)
                Log.d("EXIF", "Exif: " + orientation)
            }
            scaledBitmap = Bitmap.createBitmap(
                scaledBitmap, 0, 0,
                scaledBitmap.width, scaledBitmap.height, matrix,
                true
            )
        } catch (e: IOException) {
            e.printStackTrace()
        }

        var out: FileOutputStream? = null
        val filename = filename
        try {
            out = FileOutputStream(filename)
            //write the compressed bitmap at the destination specified by filename.
            scaledBitmap!!.compress(Bitmap.CompressFormat.JPEG, 70, out)
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }

        return filename
    }

    fun compressImageV2(filePath: String): String {
        /**
         * method requires EXTERNAL_STORAGE permission
         */

        var scaledBitmap: Bitmap? = null

        val options = BitmapFactory.Options()

        val fis = FileInputStream(File(filePath))

        //      by setting this field as true, the actual bitmap pixels are not loaded in the memory. Just the bounds are loaded. If
        //      you try the use the bitmap here, you will get null.
        options.inJustDecodeBounds = true
        //var bmp = BitmapFactory.decodeFile(filePath, options)
        var bmp = BitmapFactory.decodeStream(fis, null, options)


        var actualHeight = options.outHeight
        var actualWidth = options.outWidth

        //max Height and width values of the compressed image is taken as 816x612
        val maxHeight = 1920.0f//1280.0f;//816.0f;
        val maxWidth = 1080.0f//852.0f;//612.0f;

        var imgRatio = (actualWidth / actualHeight).toFloat()
        val maxRatio = maxWidth / maxHeight

        //width and height values are set maintaining the aspect ratio of the image
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                imgRatio = maxHeight / actualHeight
                actualWidth = (imgRatio * actualWidth).toInt()
                actualHeight = maxHeight.toInt()
            } else if (imgRatio > maxRatio) {
                imgRatio = maxWidth / actualWidth
                actualHeight = (imgRatio * actualHeight).toInt()
                actualWidth = maxWidth.toInt()
            } else {
                actualHeight = maxHeight.toInt()
                actualWidth = maxWidth.toInt()

            }
        }

        //setting inSampleSize value allows to load a scaled down version of the original image

        options.inSampleSize = calculateInSampleSize(options, actualWidth, actualHeight)

        //inJustDecodeBounds set to false to load the actual bitmap
        options.inJustDecodeBounds = false

        //this options allow android to claim the bitmap memory if it runs low on memory
        options.inPurgeable = true
        options.inInputShareable = true
        options.inTempStorage = ByteArray(16 * 1024)

        try {
            //          load the bitmap from its path
            bmp = BitmapFactory.decodeFile(filePath, options)
        } catch (exception: OutOfMemoryError) {
            exception.printStackTrace()
        }

        try {
            scaledBitmap = Bitmap.createBitmap(actualWidth, actualHeight, Bitmap.Config.ARGB_8888)
        } catch (exception: OutOfMemoryError) {
            exception.printStackTrace()
        }

        val ratioX = actualWidth / options.outWidth.toFloat()
        val ratioY = actualHeight / options.outHeight.toFloat()
        val middleX = actualWidth / 2.0f
        val middleY = actualHeight / 2.0f

        val scaleMatrix = Matrix()
        scaleMatrix.setScale(ratioX, ratioY, middleX, middleY)

        val canvas = Canvas(scaledBitmap!!)
        canvas.setMatrix(scaleMatrix)
        canvas.drawBitmap(
            bmp!!,
            middleX - bmp.width / 2,
            middleY - bmp.height / 2,
            Paint(Paint.FILTER_BITMAP_FLAG)
        )

        //check the rotation of the image and display it properly
        val exif: ExifInterface
        try {
            exif = ExifInterface(filePath)

            val orientation = exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION, 0
            )
            Log.d("EXIF", "Exif: " + orientation)
            val matrix = Matrix()
            if (orientation == 6) {
                matrix.postRotate(90f)
                Log.d("EXIF", "Exif: " + orientation)
            } else if (orientation == 3) {
                matrix.postRotate(180f)
                Log.d("EXIF", "Exif: " + orientation)
            } else if (orientation == 8) {
                matrix.postRotate(270f)
                Log.d("EXIF", "Exif: " + orientation)
            }
            scaledBitmap = Bitmap.createBitmap(
                scaledBitmap, 0, 0,
                scaledBitmap.width, scaledBitmap.height, matrix,
                true
            )
        } catch (e: IOException) {
            e.printStackTrace()
        }

        var out: FileOutputStream? = null
        val filename = filename
        try {
            out = FileOutputStream(filename)
            //write the compressed bitmap at the destination specified by filename.
            scaledBitmap!!.compress(Bitmap.CompressFormat.JPEG, 70, out)
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }

        return filename
    }

    /*fun compressImageFromURI(uri: Uri): String {
        */
    /**
     * method requires EXTERNAL_STORAGE permission
     *//*

        var scaledBitmap: Bitmap? = null

        val options = BitmapFactory.Options()

        //      by setting this field as true, the actual bitmap pixels are not loaded in the memory. Just the bounds are loaded. If
        //      you try the use the bitmap here, you will get null.
        options.inJustDecodeBounds = true
        //var bmp = BitmapFactory.decodeFile(uri, options)

        val inputStream: InputStream? = requireActivity().contentResolver.openInputStream(uri)
        var bmp = BitmapFactory.decodeStream(inputStream, null, options)


        var actualHeight = options.outHeight
        var actualWidth = options.outWidth

        //      max Height and width values of the compressed image is taken as 816x612

        val maxHeight = 1920.0f//1280.0f;//816.0f;
        val maxWidth = 1080.0f//852.0f;//612.0f;

        var imgRatio = (actualWidth / actualHeight).toFloat()
        val maxRatio = maxWidth / maxHeight

        //      width and height values are set maintaining the aspect ratio of the image

        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                imgRatio = maxHeight / actualHeight
                actualWidth = (imgRatio * actualWidth).toInt()
                actualHeight = maxHeight.toInt()
            } else if (imgRatio > maxRatio) {
                imgRatio = maxWidth / actualWidth
                actualHeight = (imgRatio * actualHeight).toInt()
                actualWidth = maxWidth.toInt()
            } else {
                actualHeight = maxHeight.toInt()
                actualWidth = maxWidth.toInt()

            }
        }

        //setting inSampleSize value allows to load a scaled down version of the original image

        options.inSampleSize = calculateInSampleSize(options, actualWidth, actualHeight)

        //inJustDecodeBounds set to false to load the actual bitmap
        options.inJustDecodeBounds = false

        //this options allow android to claim the bitmap memory if it runs low on memory
        options.inPurgeable = true
        options.inInputShareable = true
        options.inTempStorage = ByteArray(16 * 1024)

        try {
            //          load the bitmap from its path
           // bmp = BitmapFactory.decodeFile(filePath, options)


            //val inputStream: InputStream? = requireActivity().contentResolver.openInputStream(uri)
             bmp = BitmapFactory.decodeStream(inputStream, null, options)

        } catch (exception: OutOfMemoryError) {
            exception.printStackTrace()

        }

        try {
            scaledBitmap = Bitmap.createBitmap(actualWidth, actualHeight, Bitmap.Config.ARGB_8888)
        } catch (exception: OutOfMemoryError) {
            exception.printStackTrace()
        }

        val ratioX = actualWidth / options.outWidth.toFloat()
        val ratioY = actualHeight / options.outHeight.toFloat()
        val middleX = actualWidth / 2.0f
        val middleY = actualHeight / 2.0f

        val scaleMatrix = Matrix()
        scaleMatrix.setScale(ratioX, ratioY, middleX, middleY)

        val canvas = Canvas(scaledBitmap!!)
        canvas.setMatrix(scaleMatrix)
        canvas.drawBitmap(
            bmp,
            middleX - bmp.width / 2,
            middleY - bmp.height / 2,
            Paint(Paint.FILTER_BITMAP_FLAG)
        )

        //      check the rotation of the image and display it properly
        val exif: ExifInterface
        try {

            exif = ExifInterface(filePath)

            val orientation = exif.getAttributeInt(
                ExifInterface.TAG_ORIENTATION, 0
            )
            Log.d("EXIF", "Exif: " + orientation)
            val matrix = Matrix()
            if (orientation == 6) {
                matrix.postRotate(90f)
                Log.d("EXIF", "Exif: " + orientation)
            } else if (orientation == 3) {
                matrix.postRotate(180f)
                Log.d("EXIF", "Exif: " + orientation)
            } else if (orientation == 8) {
                matrix.postRotate(270f)
                Log.d("EXIF", "Exif: " + orientation)
            }
            scaledBitmap = Bitmap.createBitmap(
                scaledBitmap, 0, 0,
                scaledBitmap.width, scaledBitmap.height, matrix,
                true
            )
        } catch (e: IOException) {
            e.printStackTrace()
        }

        var out: FileOutputStream? = null
        val filename = filename
        try {
            out = FileOutputStream(filename)
            //          write the compressed bitmap at the destination specified by filename.
            scaledBitmap!!.compress(Bitmap.CompressFormat.JPEG, 70, out)
        } catch (e: FileNotFoundException) {
            e.printStackTrace()
        }

        return filename

    }*/

    fun calculateInSampleSize(options: BitmapFactory.Options, reqWidth: Int, reqHeight: Int): Int {
        val height = options.outHeight
        val width = options.outWidth
        var inSampleSize = 1

        if (height > reqHeight || width > reqWidth) {
            val heightRatio = Math.round(height.toFloat() / reqHeight.toFloat())
            val widthRatio = Math.round(width.toFloat() / reqWidth.toFloat())
            inSampleSize = if (heightRatio < widthRatio) heightRatio else widthRatio
        }
        val totalPixels = (width * height).toFloat()
        val totalReqPixelsCap = (reqWidth * reqHeight * 2).toFloat()
        while (totalPixels / (inSampleSize * inSampleSize) > totalReqPixelsCap) {
            inSampleSize++
        }

        return inSampleSize
    }

    /**
     * cropImage
     * This method use UCrop for cropping*/
    private fun cropImage(uri: Uri) {
        val options: UCrop.Options = UCrop.Options()
        options.setToolbarColor(resources.getColor(R.color.colorPrimary, null))
        options.setStatusBarColor(resources.getColor(R.color.colorPrimary, null))
        options.setCropFrameColor(resources.getColor(R.color.colorPrimary, null))
        options.setCropGridColor(resources.getColor(R.color.colorPrimary, null))
        options.setActiveControlsWidgetColor(resources.getColor(R.color.white, null))
        options.setToolbarWidgetColor(resources.getColor(R.color.white, null))
        options.setFreeStyleCropEnabled(true)
//        options.setCropFrameStrokeWidth()

        activity?.let {
            UCrop.of(uri, getSaveImageUriDestination())
                .withOptions(options)
                .start(it, this)
        }
    }


    private fun getSaveImageUriDestination(): Uri {
        val destin: Uri
        val root = File(/*Environment.getExternalStorageDirectory()*/
            MyTatvaApp.mContext?.filesDir.toString() + "/${APP_DIRECTORY}/Images"
        )
        if (!root.exists()) {
            root.mkdirs()
        }
        val imageName = System.currentTimeMillis().toString() + ".jpg"
        val sdImageMainDirectory = File(root, imageName)
        destin = Uri.fromFile(sdImageMainDirectory)
        return destin
    }

    companion object {

        val randomFileName: String
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

        private val TRIIM_VIDEO = 45
        private val PICK_Camera_IMAGE = 2
        private val SELECT_FILE1 = 1
        private val STORAGE_PERMISSION = 3
        val CROP_IMAGE_ACTIVITY_REQUEST_CODE = 203

        fun newInstance(): ImageAndVideoPicker {
            val args = Bundle()
            val fragment = ImageAndVideoPicker()
            fragment.arguments = args
            return fragment
        }

        fun isValidFileSize(path: String, maxSizeMB: Int = 6): Boolean {
            val file = File(path)
            // Get length of file in bytes
            val fileSizeInBytes = file.length()
            // Convert the bytes to Kilobytes (1 KB = 1024 Bytes)
            val fileSizeInKB = fileSizeInBytes / 1024
            // Convert the KB to MegaBytes (1 MB = 1024 KBytes)
            val fileSizeInMB = fileSizeInKB / 1024;
            Log.d("FILESIZE", ":: - $fileSizeInMB")
            return fileSizeInMB <= maxSizeMB
        }
    }

    val REQUEST_CAMERA_PERMISSION = 1
    val REQUEST_GALLERY_PERMISSION = 2
    val REQUEST_CAMERA_VIDEO_PERMISSION = 3
    val REQUEST_GALLERY_VIDEO_PERMISSION = 4

    val PERMISSIONS_STORAGE = arrayOf(
        Manifest.permission.READ_EXTERNAL_STORAGE/*,
            Manifest.permission.WRITE_EXTERNAL_STORAGE*/
    )
    val PERMISSIONS_DOCUMENT = arrayOf(
        Manifest.permission.CAMERA,
        Manifest.permission.READ_EXTERNAL_STORAGE
    )
    val PERMISSIONS_CAMERA = arrayOf(
        Manifest.permission.CAMERA,
        Manifest.permission.READ_EXTERNAL_STORAGE/*,
            Manifest.permission.WRITE_EXTERNAL_STORAGE*/
    )
    val PERMISSIONS_RECORD_VIDEO = arrayOf<String>(
        Manifest.permission.CAMERA,
        Manifest.permission.READ_EXTERNAL_STORAGE,
        Manifest.permission.RECORD_AUDIO/*,
            Manifest.permission.WRITE_EXTERNAL_STORAGE*/
    )

    object RequestCode {
        //const val SELECT_SINGLE_IMAGE = 202
        const val SELECT_IMAGES_MULTIPLE = 203
        const val SELECT_IMAGES_KITKAT_MULTIPLE = 204

        const val TAKE_CAMERA_VIDEO = 205
        const val SELECT_SINGLE_VIDEO = 206
        const val SELECT_VIDEOS_MULTIPLE = 207
        const val SELECT_VIDEOS_KITKAT_MULTIPLE = 208

        const val REQUEST_PICK_DOC = 209
        const val REQUEST_PICK_DOC_MULTIPLE = 210
    }


}