import 'package:GameX/screens/auth/login_screen.dart';
import 'package:GameX/screens/auth/register_screen.dart';
import 'package:GameX/screens/auth/welcome_screen.dart';
import 'package:GameX/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Routes principales que tu utilises actuellement
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
      // Route par défaut si aucune route correspondante n'est trouvée
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route non trouvée'),
            ),
          ),
        );
    }
  }

  // Méthodes de navigation utiles
  static Future<T?> push<T>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushAndClearStack<T>(
      BuildContext context,
      String routeName, {
        Object? arguments,
      }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }
}