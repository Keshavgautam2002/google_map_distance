import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_app/RouteHelper/AppRoutes.dart';
import 'package:google_maps_app/view/FileUpload/fileUpload.dart';
import 'package:google_maps_app/view/HomeScreen/HomeScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
      home: const FileUpload(),
    );
  }
}
