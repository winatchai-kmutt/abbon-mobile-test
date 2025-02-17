import 'package:abbon_mobile_test/utils/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class Destination {
  final String label;
  final IconData icon;

  const Destination({
    required this.label,
    required this.icon,
  });
}

class LayoutScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LayoutScaffold({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  @override
  Widget build(BuildContext context) {
    List<Destination> destinations = [
      Destination(
        label: LocaleKeys.contacts.tr(),
        icon: Icons.contact_page,
      ),
      Destination(
        label: LocaleKeys.home.tr(),
        icon: Icons.home,
      ),
      Destination(
        label: LocaleKeys.settings.tr(),
        icon: Icons.settings,
      ),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          margin: EdgeInsets.symmetric(horizontal: 104),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: destinations.asMap().entries.map(
              (entry) {
                int index = entry.key;
                Destination destination = entry.value;
                bool isSelected = navigationShell.currentIndex == index;
                return GestureDetector(
                  onTap: () => navigationShell.goBranch(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              isSelected ? Colors.white : Colors.black,
                        ),
                        child: Icon(
                          destination.icon,
                          color: isSelected ? Colors.black : Colors.grey,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

// NavigationDestination(
//               icon: Icon(
//                 destination.icon,
//                 color: Colors.white,
//               ),
//               label: destination.lebel,
//             )
