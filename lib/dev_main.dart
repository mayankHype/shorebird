import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shorebird/UpdateScreen.dart';


import 'package:shorebird_code_push/shorebird_code_push.dart';

void main() async{


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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  void _incrementCounter() async{

    final shorebirdCodePush = ShorebirdCodePush();
    final isUpdateAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();

// Download a new patch.
    await shorebirdCodePush.downloadUpdateIfAvailable();

    if(isUpdateAvailable){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Kro")));
    }
    setState(() {

      _counter++;
    });
  }


  @override
  void initState() {



    // TODO: implement initState
    super.initState();

    checkForUpdate();
  }

Future<void> checkForUpdate()async{
 InAppUpdate.checkForUpdate().then((value) {
     log(value.updateAvailability.toString());
     if(value.updateAvailability==UpdateAvailability.updateAvailable){

       InAppUpdate.performImmediateUpdate().then((value) {
         log("Ye hai answer:"+value.name.toString());
         if(value==AppUpdateResult.userDeniedUpdate){
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateScreen()));
         }
         else if(value==AppUpdateResult.success){
           showDialog(context: context, builder: (context){
             return AlertDialog(
               title: Text("Hurray! 🎉"),
             );
           });
         }
       }).catchError((e){
         log("Update Error:"+e.toString());
       });
     }



   }).catchError((onError){
     log(onError.toString());
 });


    if(InAppUpdate.checkForUpdate()==UpdateAvailability.updateAvailable){
   await   InAppUpdate.performImmediateUpdate().catchError((e){
        log(e.toString());
      });
    }
}



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("This is dev mode"),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              ' sdff dfg You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(onPressed: (){

            }, child:const Text("Tap to restart"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
