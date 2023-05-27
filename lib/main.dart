import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linkchat/screens/dashboard_screen.dart';
import 'package:linkchat/screens/login_screen.dart';
import 'package:linkchat/screens/onboarding_screen.dart';
import 'package:linkchat/settings/preferences.dart';
import 'package:linkchat/widgets/loading_modal_widget.dart';
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
      builder: (context, authSnapshot) => DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
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
            themeMode: ThemeMode.system,
            routes: getApplicationRoutes(),
            home: FutureBuilder(
              initialData: const LoadingModal(),
              future: getHomeScreen(context, authSnapshot.data),
              builder: (context, homeSnapshot) {
                if (homeSnapshot.hasData) {
                  return homeSnapshot.data!;
                } else if (homeSnapshot.hasError) {
                  return const LoginScreen();
                } else {
                  return const LoadingModal();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Future<Widget> getHomeScreen(BuildContext context, User? user) async {
    if (user != null && !user.isAnonymous && user.emailVerified) {
      bool showOnboarding = await Preferences.getShowOnboarding();
      if (showOnboarding) {
        return const OnboardingScreen();
      } else {
        return const DashboardScreen();
      }
    } else {
      return const LoginScreen();
    }
  }
}
