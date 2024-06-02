import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

import 'board_ui.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  Routes.defineRoutes();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      onGenerateRoute: Routes.router.generator,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFE8F5E9),
          // foregroundColor: Colors.white
        ),
        useMaterial3: true,
      ),
    );
  }
}
