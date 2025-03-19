// import 'dart:developer';

// import 'package:fluro/fluro.dart';
// import 'package:flutter/material.dart';

// import 'notice_view_ui.dart';

// class Routes {
//   static final router = FluroRouter();

//   static var firstScreen = Handler(
//       handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//     // if (!Myst.isMobile(context!)) {
//     //   return DeskHomeUi();
//     // }
//     log('paarmsf ' + params.toString());
//     // return BoardUi(title: 'hi');
//     return Text(
//       '404 Not Found',
//       style: TextStyle(color: Colors.black),
//     );
//   });

//   static var placeHandler = Handler(
//       handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//     // log('router paarms ' + params.toString());

//     // return BoardUi(title: '1' + params["slug"][0]);

//     String slug = params["slug"][0];
//     String uid = params["uid"][0];
//     String from = params["from"][0];

//     // log('router placeHandler ${slug} ${uid} ${from}');
//     return NoticeViewUi(slug, uid, from: from);
//   });

//   // static var boardArticle = Handler(
//   //     handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//   //   // if (!Myst.isMobile(context!)) {
//   //   //   return DeskFanpageUi(params["slug"][0]);
//   //   // }
//   //   log('Routes paarms1 ' + params.toString());
//   //   log('Routes paarms1 ${params["group"][0]} ${params["article"][0]}');

//   //   return NoticeViewUi(params["group"][0], params["uid"][0],
//   //       from: params["from"][0]);
//   // });

//   static dynamic defineRoutes() {
//     router.define("/",
//         handler: firstScreen, transitionDuration: const Duration(seconds: 0));
//     router.define("/:slug",
//         handler: placeHandler, transitionDuration: const Duration(seconds: 0));
//     // router.define("/:group/:article",
//     //     handler: boardArticle, transitionDuration: const Duration(seconds: 0));
//   }
// }
