
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:shorebird/sandbox/util/SharedPrefrence.dart';

class LocationService{


 late Location _location=Location();
late bool _serviceEnabled=false;
 PermissionStatus? _permissionGranted;
 LocationData? _locationData;

 LocationData get loc=>_locationData!;


   Future<void> getLocation()async{





       _permissionGranted = await _location.requestPermission();



     _locationData = await _location.getLocation();
       final coordinates = new Coordinates(_locationData!.latitude, _locationData!.longitude);
       var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
       var   first = addresses.first;
       print("${first.featureName} : ${first.addressLine}");

       SharedStorage.instance.saveLocation("${_locationData!.latitude}+${_locationData!.longitude}");

   }


 Future<LocationData> fetchLocation()async{





   _permissionGranted = await _location.requestPermission();



   _locationData = await _location.getLocation();
   final coordinates = new Coordinates(_locationData!.latitude, _locationData!.longitude);
   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
   var   first = addresses.first;
   print("${first.featureName} : ${first.addressLine}");


   return _locationData!;
 }




}