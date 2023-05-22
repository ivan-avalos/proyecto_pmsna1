import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linkchat/screens/dashboard_screen.dart';
import 'package:linkchat/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'firebase/auth.dart';
import 'providers/theme_provider.dart';
import 'routes.dart';
import 'settings/themes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const MainContent());
}

class MainContent extends StatefulWidget {
  const MainContent({super.key});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int contador = 0;

  @override
  void initState() {
    super.initState();
    contador = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: LinkChat(),
    );
  }
}

class LinkChat extends StatelessWidget {
  final Auth _auth = Auth();

  LinkChat({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider provider = context.watch<ThemeProvider>();
    final ThemeData? theme = provider.theme;
    provider.syncFromPrefs();
    return MaterialApp(
        theme: theme ?? ThemeSettings.lightTheme,
        darkTheme: theme ?? ThemeSettings.darkTheme,
        themeMode: ThemeMode.system,
        routes: getApplicationRoutes(),
        // initialRoute: '/login',
        home: StreamBuilder(
          stream: _auth.userChanges,
          builder: (context, snapshot) {
            return (snapshot.hasData && !snapshot.data!.isAnonymous)
                ? const DashboardScreen()
                : const LoginScreen();
          },
        ));
  }
}
