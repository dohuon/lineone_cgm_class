import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:lineone_cgm_class/notice_view_ui.dart';

import 'routes.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // Routes.defineRoutes();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    // GoRoute(
    //     path: '/',
    //     builder: (context, state) {
    //       return MaterialPage(
    //         child: NoticeViewUi('notice', uid, from: from),
    //         key: state.pageKey,
    //         name: '출결 알리미',
    //       );
    //     }),
    GoRoute(
        path: '/notice',
        pageBuilder: (context, state) {
          // final String uid = state.pathParameters['uid'] ?? 'uid';
          final String uid = state.uri.queryParameters['uid'] ?? 'uid';
          final String from = state.uri.queryParameters['from'] ?? 'from';
          // return MaterialPage(child: child)
          return MaterialPage(
            child: NoticeViewUi('notice', uid, from: from),
            key: state.pageKey,
            name: '출결 알리미',
          );
        }),
  ],
);

class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFE8F5E9),
        ),
        useMaterial3: true,
      ),
    );
  }
}
