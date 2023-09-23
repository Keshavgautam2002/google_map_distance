package com.example.google_maps_app

import android.R.attr.bitmap
import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "google_maps_app.flutter.dev/image"

    @SuppressLint("WrongThread")
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "applyWaterMark") {


                //Get resolution from image
                val decodedString: ByteArray = Base64.decode(call.argument<String>("image"), Base64.DEFAULT)
                val decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
                val imageWidth = decodedByte.width
                val imageHeight = decodedByte.height


                //find out the font size
                println("$imageHeight $imageWidth")
//                val fontSize = 0.05f * minOf(imageWidth, imageHeight)
                val fontSize = (imageWidth * 2.5 / 100).toFloat();



                //add watermark
                val watermarkBitmap = decodedByte.copy(Bitmap.Config.ARGB_8888, true)
                val canvas = Canvas(watermarkBitmap)
                val paint = Paint()
                paint.alpha = 90
                paint.color = Color.WHITE
                paint.textSize = fontSize
                paint.isAntiAlias = true




                // Position the text (adjust x and y as needed)
                val x = (imageWidth * 0.05).toFloat();
                val y = (imageHeight * 0.9).toFloat();
                //val waterMark : String = call.argument<String>("waterMark").toString();
                val address : String = call.argument<String>("location").toString();
                val empCode : String = call.argument<String>("emp_code").toString();
                val name : String = call.argument<String>("name").toString();
                val date : String = call.argument<String>("date").toString();
                //waterMark.replace(" ","\n");
                //println(waterMark);

                //draw a rectangle first
                var intialHeight = imageHeight - (3 * fontSize);
                var x1 = imageHeight - (6*fontSize)
                var y1 = imageWidth * 0.4f
                var margin = 5;
                canvas.drawRect(x-margin,intialHeight - fontSize,y1, (intialHeight+(1.5 * fontSize)).toFloat(),paint)
                paint.color = Color.BLACK

                canvas.drawText(name, x, intialHeight, paint)
                intialHeight += fontSize;
                canvas.drawText(address, x, intialHeight, paint)

            // Now 'watermarkBitmap' contains the original image with the watermark



                //convert the bitmap to base 64 string
                val outputStream = ByteArrayOutputStream();
                watermarkBitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                val base64String : String =  Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT);
                val ans = mapOf("image" to base64String);
                result.success(ans);

            }
            else {
                result.notImplemented()
            }
        }
        }
}
