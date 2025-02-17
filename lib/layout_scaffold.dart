import 'package:abbon_mobile_test/utils/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Destination {
  final String lebel;
  final IconData icon;

  const Destination({
    required this.lebel,
    required this.icon,
  });
}

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  LayoutScaffold({Key? key, required this.navigationShell})
      : super(key: key ?? const ValueKey<String>('LayoutScafford'));

  @override
  Widget build(BuildContext context) {

    List<Destination> destinations = [
    Destination(
      lebel: LocaleKeys.contacts.tr(),
      icon: Icons.contact_page_outlined,
    ),
    Destination(
      lebel: LocaleKeys.home.tr(),
      icon: Icons.home_outlined,
    ),
    Destination(
      lebel: LocaleKeys.settings.tr(),
      icon: Icons.settings_outlined,
    ),
  ];
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: navigationShell.goBranch,
          indicatorColor: Theme.of(context).primaryColor,
          destinations: destinations
              .map((destination) => NavigationDestination(
                  icon: Icon(
                    destination.icon,
                    color: Colors.white,
                  ),
                  label: destination.lebel))
              .toList()),
    );
  }
}
