import 'package:flutter/material.dart';
import 'package:linkchat/widgets/cached_avatar.dart';
import 'package:provider/provider.dart';

import '../firebase/auth.dart';
import '../providers/theme_provider.dart';
import '../settings/themes.dart';
import '../widgets/recent_chats.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Auth _auth;

  @override
  void initState() {
    super.initState();
    _auth = Auth();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Inicio'),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_outline),
                onPressed: () {
                  Navigator.of(context).pushNamed('/favorites');
                },
              )
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: RecentChats(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CachedAvatar(_auth.currentUser?.photoURL),
              accountName: Text(_auth.currentUser?.displayName ?? "Lincite"),
              accountEmail: _auth.currentUser?.email != null
                  ? Text(_auth.currentUser!.email!)
                  : null,
            ),
            ListTile(
              title: const Text('Tema'),
              trailing: SegmentedButton<ThemeData?>(
                segments: [
                  const ButtonSegment<ThemeData?>(
                    value: null,
                    icon: Icon(Icons.brightness_auto),
                  ),
                  ButtonSegment<ThemeData?>(
                    value: ThemeSettings.lightTheme,
                    icon: const Icon(Icons.light_mode),
                  ),
                  ButtonSegment<ThemeData?>(
                      value: ThemeSettings.darkTheme,
                      icon: const Icon(Icons.dark_mode)),
                ],
                selected: <ThemeData?>{themeProvider.theme},
                onSelectionChanged: ((Set<ThemeData?> newSelection) {
                  themeProvider.theme = newSelection.first;
                }),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Cerrar sesión'),
              leading: const Icon(Icons.logout),
              onTap: () => signOut(context),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo'),
        icon: const Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).pushNamed('/new');
        },
      ),
    );
  }

  void signOut(BuildContext context) {
    /*_auth.signOut().then((success) {
      if (success) {
        Navigator.of(context).popUntil(ModalRoute.withName('/login'));
      }
    });*/
    _auth.signOut().then((success) {
      if (success) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }
}
