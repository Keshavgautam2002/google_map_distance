import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class GeoLocationService{

  bool isServiceEnabled = false;
  LocationPermission? permission ;

  getCurrentGeoLocation(BuildContext context)
  async{
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!isServiceEnabled)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Service is not enabled")));
        return;
      }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission is not given")));
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission Denied")));
        }
      }

    if(permission == LocationPermission.deniedForever)
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Denied forever")));
        return;
      }

    return await Geolocator.getCurrentPosition();
  }

  getDistanceBetween(LatLng dest, LatLng current)
  async{
    final distance = await Geolocator.distanceBetween(current.latitude, current.longitude, dest.latitude, dest.longitude);
    debugPrint(distance.toString());
    return distance;
    //checkDist(distance,dest);
  }

  checkDist(double dist, LatLng dest)
  async{
    if(dist.toPrecision(0)/1000 > 1)
      {
        debugPrint("Show Map");
        //https://www.google.com/maps/search/?api=1&query=${TextStrings.homeLat},${TextStrings.homeLng}
        bool rep = await launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=${dest.latitude},${dest.longitude}"));
        return rep;
      }
    else{
      debugPrint("Inside the area");
    }
  }




}