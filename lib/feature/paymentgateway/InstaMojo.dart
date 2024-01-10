// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:instamojo/controllers/instamojo_controller.dart';
// import 'package:instamojo/instamojo.dart';
// import 'package:instamojo/models/create_order_body.dart';
// import 'package:http/http.dart' as http;
//
// import 'data/remote.dart';
// class InstamojoScreen extends StatefulWidget {
//
//
//   const InstamojoScreen(
//       {Key? key})
//       : super(key: key);
//
//   @override
//   _InstamojoScreenState createState() => _InstamojoScreenState();
// }
//
// class _InstamojoScreenState extends State<InstamojoScreen>
//     implements InstamojoPaymentStatusListener {
//   final flutterWebviewPlugin = new FlutterWebviewPlugin();
//   Future createRequest(String name,String email,String phone) async {
//     Map<String, String> body = {
//       "amount": "100", //amount to be paid
//       "purpose": "Advertising",
//       "buyer_name": name,
//       "email": email,
//       "phone": phone,
//       "allow_repeated_payments": "true",
//       "send_email": "false",
//       "send_sms": "false",
//       "redirect_url": "http://www.example.com/redirect/",
//       //Where to redirect after a successful payment.
//       "webhook": "http://www.example.com/webhook/",
//     };
// //First we have to create a Payment_Request.
// //then we'll take the response of our request.
//
//
//
//
//     var resps=await http.post(Uri.parse("https://test.instamojo.com/oauth2/token/"),
//     body: {
//       "grant_type":"client_credentials",
//       "client_id":"test_mfTYzuD78p5Pg2UwBg9yDvigbUsNkLvV5Ij",
//       "client_secret":"test_8FwXeyLpGYDDpvMpVsPsvHRUiKTbGswzhgolOFU2j3coxVzfe3NsdL1VAd7cALN5EMvHggIdFuARKAV5TiC2YEzof2sEiH5SZi0SOGKz0MC8y58N3g4uu42gNr4"
//     }
//     );
//
//    if(resps.statusCode==200){
//      log("${jsonDecode(resps.body)["access_token"]}\n");
//      var long=await http.post(Uri.parse("https://test.instamojo.com/v2/payment_requests"),
//      headers: {
//        "Authorization":"Bearer ${jsonDecode(resps.body)["access_token"]}"
//      },
// body: body
//      );
//
// if(long.statusCode==201){
//   String selectedUrl = json.decode(resps.body)['longurl'].toString() + "?embed=form";
//   flutterWebviewPlugin.close();
// //Let's open the url in webview.
//   flutterWebviewPlugin.launch(selectedUrl,
//       rect: new Rect.fromLTRB(
//           5.0,
//           MediaQuery.of(context).size.height / 7,
//           MediaQuery.of(context).size.width - 5.0,
//           7 * MediaQuery.of(context).size.height / 7),
//       userAgent: kAndroidUserAgent
//   );
// }
// else{
//   log(long.statusCode.toString()+json.decode(resps.body).toString());
// }
//
//    }
//
//
//
// //If request is successful take the longurl.
//
//
//
// //If something is wrong with the data we provided to
// //create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
//
//   }
//   @override
//   void initState() {
//     createRequest("sdf","sdf@gmail.com","sdf"); //creating the HTTP request
// // Add a listener on url changed
//     flutterWebviewPlugin.onUrlChanged.listen((String url) {
//       if (mounted) {
//         if (url.contains(
//             'http://www.example.com/redirect')) {
//           Uri uri = Uri.parse(url);
// //Take the payment_id parameter of the url.
//           String? paymentRequestId = uri.queryParameters['payment_id'];
// //calling this method to check payment status
//         log(paymentRequestId!);
// //           _checkPaymentStatus(paymentRequestId);
//         }
//       }
//     });
//     // TODO: implement initState
//     super.initState();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Instamojo Flutter'),
//         ),
//         body: SafeArea(
//           child: Column(
//             children: [
//
//             ],
//           ),
//             // child: Instamojo(
//             //   isConvenienceFeesApplied: false,
//             //   listener: this,
//             //   environment: Environment.TEST,
//             //   apiCallType: ApiCallType.createOrder(
//             //       createOrderBody: CreateOrderBody(amount: '20', buyerEmail: 'test@yopmail.com', buyerName: 'sdf', buyerPhone: '12345679808', description: 'sdf',
//             //
//             //
//             //
//             //       ),
//             //       // orderCreationUrl:"https://test.instamojo.com/@mayank_pandey"
//             //   ),
//             //   stylingDetails: StylingDetails(
//             //       buttonStyle: ButtonStyling(
//             //           buttonColor: Colors.amber,
//             //           buttonTextStyle: const TextStyle(
//             //             color: Colors.black,
//             //           )),
//             //       listItemStyle: ListItemStyle(
//             //           borderColor: Colors.grey,
//             //           textStyle: const TextStyle(color: Colors.black, fontSize: 18),
//             //           subTextStyle: const TextStyle(color: Colors.grey, fontSize: 14)),
//             //       loaderColor: Colors.amber,
//             //       inputFieldTextStyle: InputFieldTextStyle(
//             //           textStyle: const TextStyle(color: Colors.black, fontSize: 18),
//             //           hintTextStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//             //           labelTextStyle: const TextStyle(color: Colors.grey, fontSize: 14)),
//             //       alertStyle: AlertStyle(
//             //         headingTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
//             //         messageTextStyle: const TextStyle(color: Colors.black, fontSize: 12),
//             //         positiveButtonTextStyle:
//             //         const TextStyle(color: Colors.redAccent, fontSize: 10),
//             //         negativeButtonTextStyle:
//             //         const TextStyle(color: Colors.amber, fontSize: 10),
//             //       )),
//             // )
//
//
//         ));
//   }
//
//   @override
//   void paymentStatus({Map<String, String>? status}) {
//     Navigator.pop(context, status);
//   }
// }