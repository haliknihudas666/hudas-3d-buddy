import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hudas_3d_buddy/router/router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Hudas 3D Buddy'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              goToPage(context, CustomRouter.kHomeRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printers'),
            onTap: () {
              goToPage(context, CustomRouter.kPrinterRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_circle),
            title: const Text('Filaments'),
            onTap: () {
              goToPage(context, CustomRouter.kFilamentRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Calculate History'),
            onTap: () {
              goToPage(context, CustomRouter.kHistoryRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Calculator Settings'),
            onTap: () {
              goToPage(context, CustomRouter.kCalcuSettingsRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('App Settings'),
            onTap: () {
              goToPage(context, CustomRouter.kSettingsRoute);
            },
          ),
        ],
      ),
    );
  }

  void goToPage(BuildContext context, String path) {
    final String location = GoRouterState.of(context).location;

    if (location == path) {
      context.pop();
    } else {
      context.replace(path);
    }
  }
}
