package com.example.crypto_app

//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()


import android.util.Log
import android.app.Activity
import android.content.Intent
import android.location.LocationManager
import android.os.Bundle
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.PendingIntent


class MainActivity : FlutterActivity() {
    private val CHANNEL = "face_detection_channel"
    private lateinit var locationManager: LocationManager
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSatelliteInfo") {
                getSatelliteCount(result)
            } else {
                result.notImplemented()
            }
        }
    }


    private fun getSatelliteCount(result: MethodChannel.Result) {
        val intent = Intent(this, CameraActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            CAMERA_REQUEST_CODE,
            intent,
            PendingIntent.FLAG_IMMUTABLE // Specify the flag
        )

        // If you're using PendingIntent in a specific way, you'd call it here
        // But typically, you'd start the activity directly instead.
        // startActivityForResult(pendingIntent.intent, CAMERA_REQUEST_CODE) // This is incorrect!
        startActivityForResult(intent, CAMERA_REQUEST_CODE) // Use this for starting the activity directly
    }



    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if ( resultCode == Activity.RESULT_OK) {
            val satelliteData: MutableMap<String, String> = HashMap()
            data?.getStringExtra("filePath")?.let { filePath ->
                satelliteData["filePath"] = filePath
                Log.d("CameraActivity", "Received file path: ${satelliteData["filePath"]}")
            }
            // Send the result back to Flutter
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("satelliteData", satelliteData)
            }
        } else {
            // Handle errors or cancellations
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("error", "Activity result was not OK")
            }
        }
    }


    companion object {
        private const val CAMERA_REQUEST_CODE = 1001 // Request code for CameraActivity
    }
}