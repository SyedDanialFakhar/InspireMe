import 'package:flutter/material.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/favorites_screen.dart';

class AppRouter {
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
        '/': (_) => const HomeScreen(),
        FavoritesScreen.routeName: (_) => const FavoritesScreen(),
      };
}


