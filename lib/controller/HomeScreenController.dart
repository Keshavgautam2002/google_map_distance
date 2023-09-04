import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeScreenController extends GetxController{
  HomeScreenController();
  GoogleMapController? mapController;
  void updateMapController(GoogleMapController controller)
  {
    mapController = controller;
    update();
  }

  Set<Marker> markers = {
    const Marker(
      markerId: MarkerId("Post 1"),
      position: LatLng(37.42796133580664, -122.085749655962),
    ),
    const Marker(
      markerId: MarkerId("Post 2"),
      position: LatLng(38.42796133580662, -122.085749655882),
    ),
  };
  Set<Marker> get makersIds => markers;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  CameraPosition get position => _kGooglePlex;
}