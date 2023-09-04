import 'package:get/get.dart';
import 'package:google_maps_app/controller/HomeScreenController.dart';
import 'package:google_maps_app/controller/SplashScreenController/SplashScreenController.dart';
import 'package:google_maps_app/view/SplashScreen/SplashScreen.dart';

import '../view/HomeScreen/HomeScreen.dart';


class AppRoutes{
  static String home = '/';
  static String splashScreen = '/splash';




  //List Of Get Pages
  static List<GetPage> routes = [

    GetPage(
        name: home,
        page: () => HomeScreen(),
        binding: BindingsBuilder(() {
      Get.lazyPut(() => HomeScreenController());
    })),
    GetPage(
        name: splashScreen,
        page: () => SplashScreen(),
        binding: BindingsBuilder(() {
      Get.lazyPut(() => SplashScreenController());
    })),


  ];
}