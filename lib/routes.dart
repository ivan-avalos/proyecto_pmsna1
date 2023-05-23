import 'package:flutter/material.dart';
import 'package:linkchat/screens/chat_screen.dart';
import 'package:linkchat/screens/favorites_screen.dart';
import 'package:linkchat/screens/new_chat_screen.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/register_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/onboard': (BuildContext context) => const OnboardingScreen(),
    '/dash': (BuildContext context) => const DashboardScreen(),
    '/new': (BuildContext context) => const NewChatScreen(),
    '/chat': (BuildContext context) => const ChatScreen(),
    '/favorites': (BuildContext context) => const FavoritesScreen(),
  };
}
