import 'package:abbon_mobile_test/blocs/contact_bloc.dart';
import 'package:abbon_mobile_test/layout_scaffold.dart';
import 'package:abbon_mobile_test/pages/contact_page.dart';
import 'package:abbon_mobile_test/pages/home_page.dart';
import 'package:abbon_mobile_test/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Routes {
  Routes._();
  static const String contactPage = '/contact';
  static const String homePage = '/home';
  static const String settingsPage = '/settings';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.homePage,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (
          context,
          state,
          navigationShell,
        ) =>
            LayoutScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.contactPage,
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => ContactBloc(),
                    child: const ContactPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.homePage,
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settingsPage,
                builder: (context, state) => SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ]);
