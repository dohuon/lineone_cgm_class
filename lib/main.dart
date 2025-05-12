import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:lineone_cgm_class/import/import_home_ui.dart';
import 'package:lineone_cgm_class/import/import_web_ui.dart';

import 'manage/manage_ui.dart';
import 'notice_view_ui.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  // Routes.defineRoutes();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: ImportHomeUi(),
            key: state.pageKey,
            name: '출결 알리미',
          );
        }),
    GoRoute(
        path: '/import',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: ImportWebUi(),
            key: state.pageKey,
            name: '출결 알리미',
          );
        }),
    GoRoute(
        path: '/wronglink',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: Material(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                    Text(
                      '잘못 된 링크!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '관리자 인증을 시작했던 브라우저로\n돌아가서 인증을 진행해 주세요.',
                      textAlign: TextAlign.center,
                    ),
                  ])),
            ),
            key: state.pageKey,
            name: '출결 알리미 관리자',
          );
        }),
    GoRoute(
        path: '/manager',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: ManageUi(),
            key: state.pageKey,
            name: '출결 알리미 관리자',
          );
        }),
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
  static const Color colorMain = Colors.green;
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
