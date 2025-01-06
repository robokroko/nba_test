import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_application/modules/security_module/security_module.dart';
import 'package:test_application/scenes/login_scene/login_screen.dart';
import 'package:test_application/scenes/nba_teams_provider_scene/nba_team_details_screen.dart';
import 'package:test_application/scenes/nba_teams_provider_scene/nba_team_list_screen.dart';
import 'package:test_application/scenes/splash_scene/splash_screen.dart';
import 'package:test_application/theme/themes.dart';

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> with WidgetsBindingObserver {
  Future<bool>? _autoLoginFuture;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _autoLoginFuture = context.read<SecurityModule>().autoLogin();

    _router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) {
            return FutureBuilder(
              future: _autoLoginFuture,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashSreen();
                }

                if (snapshot.data != null && snapshot.data == true) {
                  return const NBATeamListScreen();
                }
                return const LoginScreen();
              },
            );
          },
        ),
        GoRoute(
          path: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: NBATeamListScreen.routeName,
          builder: (context, state) => const NBATeamListScreen(),
        ),
        GoRoute(
          path: NBATeamDetailScreen.routeName,
          builder: (context, state) => const NBATeamDetailScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: {
          const Locale('en'),
        },
        locale: const Locale('en'),
        title: 'TestApp',
        theme: testApptheme,
        routerConfig: _router);
  }
}
