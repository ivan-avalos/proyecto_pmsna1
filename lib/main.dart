import 'package:dynamic_color/dynamic_color.dart';
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
    final ThemeEnum themeEnum = provider.theme;

    return StreamBuilder(
        stream: _auth.userChanges,
        builder: (context, snapshot) =>
            DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
              provider.syncFromPrefs();
              ThemeData lightTheme = ThemeSettings.lightTheme(lightDynamic);
              ThemeData darkTheme = ThemeSettings.darkTheme(darkDynamic);
              ThemeData? theme;
              switch (themeEnum) {
                case ThemeEnum.light:
                  theme = lightTheme;
                case ThemeEnum.dark:
                  theme = darkTheme;
                case ThemeEnum.auto:
                  theme = null;
              }
              return MaterialApp(
                theme: theme ?? lightTheme,
                darkTheme: theme ?? darkTheme,
                //theme: theme ?? ThemeSettings.lightTheme(lightDynamic),
                //darkTheme: theme ?? ThemeSettings.darkTheme(darkDynamic),
                themeMode: ThemeMode.system,
                routes: getApplicationRoutes(),
                home: (snapshot.hasData && !snapshot.data!.isAnonymous)
                    ? const DashboardScreen()
                    : const LoginScreen(),
              );
            }));
  }
}
