import 'package:GameX/screens/auth/login_screen.dart';
import 'package:GameX/screens/auth/register_screen.dart';
import 'package:GameX/screens/auth/welcome_screen.dart';
import 'package:GameX/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_routes.dart';
import 'controller/auth_provider.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MyApp(hasSeenWelcome: hasSeenWelcome),
        )
    );
  } catch (e) {
    print("Erreur dans main: $e");
    // Lancer une version basique sans SharedPreferences
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MyApp(hasSeenWelcome: false),
        )
    );
  }
}

class MyApp extends StatelessWidget {
  final bool hasSeenWelcome;
  const MyApp({super.key, required this.hasSeenWelcome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TestGameX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeAppContent(hasSeenWelcome: hasSeenWelcome),

      // AJOUT DES ROUTES NOMMÉES
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(), // Si vous l'avez
        AppRoutes.home: (context) => const HomeScreen(),
      },

      // Gestion des routes inconnues
      onUnknownRoute: (settings) {
        print("Route inconnue: ${settings.name}");
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );
      },
    );
  }
}

class SafeAppContent extends StatefulWidget {
  final bool hasSeenWelcome;
  const SafeAppContent({super.key, required this.hasSeenWelcome});

  @override
  State<SafeAppContent> createState() => _SafeAppContentState();
}

class _SafeAppContentState extends State<SafeAppContent> {
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.tryAutoLogin();
    } catch (e) {
      print("Erreur detecté : $e");
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Une erreur est survenue'),
              const SizedBox(height: 8),
              Text(
                error!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    error = null;
                    isLoading = true;
                  });
                  _initializeApp();
                },
                child: const Text('Réessayer'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Utiliser la route nommée
                  Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                },
                child: const Text('Continuer vers Welcome'),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        print("Auth state: ${auth.isAuthenticated}");
        print("HasSeenWelcome: ${widget.hasSeenWelcome}");

        Widget targetScreen;
        try {
          if (auth.isAuthenticated) {
            targetScreen = const HomeScreen();
          } else if (widget.hasSeenWelcome) {
            targetScreen = const LoginScreen();
          } else {
            targetScreen = const WelcomeScreen();
          }
        } catch (e) {
          print("Erreur choix écran: $e");
          targetScreen = const WelcomeScreen();
        }

        return targetScreen;
      },
    );
  }
}