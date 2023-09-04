import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_app/AppCommon/services/GeoLocationService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Position? currentPosition;
  bool showWidget = false;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(26.85526477803854, 75.83360298535659),
    zoom: 14.4746,
  );

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};



  GoogleMapController? _controller ;
  double dist = 0;

  Set<Marker> markers = {
    const Marker(
      markerId: MarkerId("Post 1"),
      position: LatLng(26.85526477803854, 75.83360298535659),
      infoWindow: InfoWindow(
        title: "Jhalana Safari"
      )
    ),
    // const Marker(
    //   markerId: MarkerId("Post 2"),
    //   position: LatLng(26.85512798346257, 75.83070697210495),
    // ),
  };

  getLocation()
  async{
    currentPosition = await GeoLocationService().getCurrentGeoLocation(context);
    if(currentPosition != null && _controller != null)
      {
        _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
          currentPosition!.latitude, currentPosition!.longitude,
        ), zoom: 14)));
        markers.add(Marker(markerId: MarkerId(currentPosition.toString(),),position: LatLng(currentPosition!.latitude,currentPosition!.longitude)));
        setState(() {});
      }
    GeoLocationService().getDistanceBetween(markers.elementAt(0).position, LatLng(currentPosition!.latitude, currentPosition!.longitude));

  }

  findDistance()
  async{

  }
  //26.85526477803854, 75.83360298535659
  //26.85512798346257, 75.83070697210495


  @override
  void initState() {
    getLocation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            markers: markers,
            trafficEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _controller = controller;
              setState(() {});
            },

          ),
          showWidget ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              //padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Have you reached the location?"),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap : () async {
                              // setState(() {
                              //         showWidget = !showWidget;
                              //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Moved to next screen")));
                              //     });
                              if(dist.toPrecision(0) / 1000 > 1)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are not on location.")));
                                  await Future.delayed(const Duration(seconds: 1));
                                  showWidget = await GeoLocationService().checkDist(dist, markers.elementAt(0).position);
                                  setState(() {});
                                }
                              else {
                                setState(() {
                                  showWidget = !showWidget;
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Moved to next screen")));
                                });
                              }

                          },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))
                              ),
                              child: const Text("Yes",style: TextStyle(color: Colors.white)),
                            ),
                          )),
                      Expanded(
                          child: InkWell(
                            onTap: () async{
                                showWidget = await GeoLocationService().checkDist(dist, markers.elementAt(0).position);
                                setState(() {});
                              },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))
                              ),
                              child: const Text("Get Directions again",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ) : const SizedBox(),
        ]
      ),
      floatingActionButton: showWidget ? const SizedBox() :FloatingActionButton.extended(
        onPressed: ()async{
          dist = await GeoLocationService().getDistanceBetween(markers.elementAt(0).position, LatLng(currentPosition!.latitude, currentPosition!.longitude));
          setState(() {});
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Distance is ${dist.toPrecision(0)/1000} km")));
          if(dist.toPrecision(0)/1000 > 1)
            {
              showWidget = await GeoLocationService().checkDist(dist, markers.elementAt(0).position);
              setState(() {});
            }
          else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("You are already on location")));
          }
        },
        label: const Text("Get Directions"),
      ),
    );
  }
}
