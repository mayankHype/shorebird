


import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedStorage{
  SharedPreferences? _sharedData;
  /// Ensuring single instance
  SharedStorage._();
  static final SharedStorage instance=SharedStorage._();

  Future<void> init()async{
    _sharedData=await SharedPreferences.getInstance();
  }


  Future<void> saveCity(String value)async{

    await _sharedData!.setString("destination", value);


  }

  Future<void> saveLocation(String value) async{
    await _sharedData!.setString('location', value).then((value) => log("value saved"));
  }


  Future<void> containsKey()async{
    await _sharedData!.containsKey('destination');
  }



  String? get city=> _sharedData!.getString("destination");
  String? get location=>_sharedData!.getString("location");


}
