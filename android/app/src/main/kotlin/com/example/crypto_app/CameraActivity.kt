package com.example.crypto_app
import android.annotation.SuppressLint
import android.os.Bundle
import android.graphics.Color
import android.widget.Button
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.content.ContextCompat
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.face.Face
import com.google.mlkit.vision.face.FaceContour
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions
import java.util.concurrent.Executors
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import androidx.camera.core.ImageCapture
import androidx.camera.core.ImageCaptureException
import androidx.camera.core.ImageCapture.OutputFileOptions
import android.content.Intent
import android.app.Activity
import android.util.Log


class CameraActivity : AppCompatActivity() {
    private var cameraProvider: ProcessCameraProvider? = null
    private var previewView: PreviewView? = null
    private var captureButton: ImageView? = null
    private var imgLeftTop: ImageView? = null
    private var isCameraEnable = false
    private lateinit var imageCapture: ImageCapture
    private val TAG = "CameraActivity"


    companion object {
        const val CAMERA_REQUEST_CODE = 1001
    }

    private var detector = FaceDetection.getClient(
        FaceDetectorOptions.Builder()
            .setPerformanceMode(FaceDetectorOptions.PERFORMANCE_MODE_FAST)
            .setContourMode(FaceDetectorOptions.CONTOUR_MODE_ALL)
            .setClassificationMode(FaceDetectorOptions.CLASSIFICATION_MODE_ALL)
            .enableTracking()
            .build()
    )

    override fun onStart() {
        super.onStart()
        startCamera()
    }

    override fun onStop() {
        super.onStop()
        // Optionally unbind the camera
        cameraProvider?.unbindAll()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        previewView = findViewById(R.id.previewView)
        captureButton = findViewById(R.id.captureButton)
        imgLeftTop = findViewById(R.id.imgLeftTop);
        captureButton?.isEnabled = false
        captureButton?.setOnClickListener {
            Log.d("CameraActivity", "Capture button clicked")

            if(isCameraEnable){
                takePhoto()
            }

        }
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(this)
        cameraProviderFuture.addListener({
            try {
                cameraProvider = cameraProviderFuture.get()
                bindPreview(cameraProvider)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }, ContextCompat.getMainExecutor(this))
    }

    private fun bindPreview(cameraProvider: ProcessCameraProvider?) {
        val preview = Preview.Builder().build()
        val cameraSelector = CameraSelector.DEFAULT_FRONT_CAMERA

        val imageAnalysis = ImageAnalysis.Builder()
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()

        imageCapture = ImageCapture.Builder().build()

        imageAnalysis.setAnalyzer(ContextCompat.getMainExecutor(this)) { imageProxy ->
            @SuppressLint("UnsafeOptInUsageError")
            val image = InputImage.fromMediaImage(
                imageProxy.image!!,
                imageProxy.imageInfo.rotationDegrees
            )

            // Perform face detection
            detector.process(image)
                .addOnSuccessListener { faces ->
                    captureButton?.isEnabled = checkEarsDetected(faces)

                       if(checkEarsDetected(faces)){
                           isCameraEnable = true
                           imgLeftTop?.setColorFilter(Color.parseColor("#00FF00"));

                           captureButton?.setImageDrawable(getResources().getDrawable(R.drawable.img_camera));
                       }else{
                           isCameraEnable = false
                           imgLeftTop?.setColorFilter(Color.parseColor("#FF0000"));
                           captureButton?.setImageDrawable(getResources().getDrawable(R.drawable.img_camera_gray));
                       }
                    imageProxy.close() // Release image resource
                }
                .addOnFailureListener {
                    imageProxy.close() // Handle errors
                }
        }

        cameraProvider?.bindToLifecycle(this, cameraSelector, preview, imageAnalysis, imageCapture)
        preview.setSurfaceProvider(previewView?.surfaceProvider)
    }

    private fun checkEarsDetected(faces: List<Face>): Boolean {
        for (face in faces) {
            val leftCheek = face.getContour(FaceContour.LEFT_CHEEK) != null
            val rightCheek = face.getContour(FaceContour.RIGHT_CHEEK) != null
            val leftEyebrowTop = face.getContour(FaceContour.LEFT_EYEBROW_TOP) != null
            val rightEyebrowTop = face.getContour(FaceContour.RIGHT_EYEBROW_TOP) != null
            val leftEyebrowBottom = face.getContour(FaceContour.LEFT_EYEBROW_BOTTOM) != null
            val rightEyebrowBottom = face.getContour(FaceContour.RIGHT_EYEBROW_BOTTOM) != null
            val leftEye = face.getContour(FaceContour.LEFT_EYE) != null
            val rightEye = face.getContour(FaceContour.RIGHT_EYE) != null
            val mouthLeft = face.getContour(FaceContour.UPPER_LIP_TOP) != null
            val mouthRight = face.getContour(FaceContour.UPPER_LIP_BOTTOM) != null
            val mouthBottom = face.getContour(FaceContour.LOWER_LIP_BOTTOM) != null
            val noseBridge = face.getContour(FaceContour.NOSE_BRIDGE) != null
            val noseBottom = face.getContour(FaceContour.NOSE_BOTTOM) != null

//            println("Left Cheek detected: $leftCheek")
//            println("Right Cheek detected: $rightCheek")
//            println("Left Eyebrow Top detected: $leftEyebrowTop")
//            println("Right Eyebrow Top detected: $rightEyebrowTop")
//            println("Left Eyebrow Bottom detected: $leftEyebrowBottom")
//            println("Right Eyebrow Bottom detected: $rightEyebrowBottom")
//            println("Left Eye detected: $leftEye")
//            println("Right Eye detected: $rightEye")
//            println("Mouth Left detected: $mouthLeft")
//            println("Mouth Right detected: $mouthRight")
//            println("Mouth Bottom detected: $mouthBottom")
//            println("Nose Bridge detected: $noseBridge")
//            println("Nose Bottom detected: $noseBottom")

            if (leftCheek && rightCheek &&leftEyebrowTop&& rightEyebrowTop&& leftEyebrowBottom&& rightEyebrowBottom&& leftEye&& rightEye&& mouthLeft&& mouthRight&& mouthBottom&& noseBridge&& noseBottom) {

                return true // Both ears detected
            }
        }
        return false
    }

    private fun sendResultBack(filePath: String) {
        val resultIntent = Intent()
        Log.e(TAG,"Photo capture failed1: ${filePath.toString()}")
        resultIntent.putExtra("filePath", filePath)
        setResult(Activity.RESULT_OK, resultIntent)
        finish() // Finish the activity and return to MainActivity
    }

    private fun takePhoto() {
        val photoFile = createImageFile()
        val outputOptions = OutputFileOptions.Builder(photoFile).build()

        imageCapture.takePicture(
            outputOptions, ContextCompat.getMainExecutor(this),
            object : ImageCapture.OnImageSavedCallback {
                override fun onError(exc: ImageCaptureException) {
                    Log.e(TAG, "Photo capture failed: ${exc.message}", exc)
                }

                override fun onImageSaved(output: ImageCapture.OutputFileResults) {
                    sendResultBack(photoFile.absolutePath)
                    val msg = "Photo capture succeeded: ${photoFile.absolutePath}"
                    Log.d(TAG, msg)
                }
            }
        )
    }


    private fun createImageFile(): File {
        // Create a unique file name based on the timestamp
        val timeStamp: String = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
        val storageDir: File? = externalCacheDir  // Use cache or external storage directory
        return File.createTempFile(
            "JPEG_${timeStamp}_",
            ".jpg",
            storageDir
        )
    }

}
