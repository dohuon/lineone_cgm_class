import 'dart:developer';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'board_ui.dart';
import 'main.dart';

class Routes {
  static final router = FluroRouter();

  static var firstScreen = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    // if (!Myst.isMobile(context!)) {
    //   return DeskHomeUi();
    // }
        log('paarmsf ' + params.toString());
    return BoardUi(title: 'hi');
  });

  static var placeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        // if (!Myst.isMobile(context!)) {
        //   return DeskFanpageUi(params["slug"][0]);
        // }
        log('paarms ' + params.toString());

        return BoardUi(title: '1' + params["slug"][0]);
      });

  static var boardArticle = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
        // if (!Myst.isMobile(context!)) {
        //   return DeskFanpageUi(params["slug"][0]);
        // }
        log('paarms1 ' + params.toString());

        return BoardUi(title: '2'+ params["board"][0] + ' ' + params["article"][0] );
      });

  static dynamic defineRoutes() {
    router.define("/",
        handler: firstScreen, transitionDuration: const Duration(seconds: 0));
    router.define("/:slug",
        handler: placeHandler, transitionDuration: const Duration(seconds: 0));
    router.define("/:board/:article",
        handler: boardArticle, transitionDuration: const Duration(seconds: 0));
  }
}
