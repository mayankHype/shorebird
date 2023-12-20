import 'package:flutter/material.dart';
import 'package:shorebird/feature/location/location_service.dart';
import 'package:shorebird/sandbox/listview/GridViewTest.dart';
import 'package:shorebird/sandbox/util/SharedPrefrence.dart';

import 'package:shorebird_code_push/shorebird_code_push.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  LocationService().getLocation();
  await SharedStorage.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dev',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: GridViewTest(),
    );
  }
}