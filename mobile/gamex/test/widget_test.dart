import 'package:GameX/controller/auth_provider.dart';
import 'package:GameX/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Vérifie l\'affichage initial selon hasSeenWelcome et auth',
          (WidgetTester tester) async {
        // On crée un AuthProvider mock
        final authProvider = AuthProvider();

        // Construire l'app dans le test
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: const MyApp(hasSeenWelcome: false), // simuler première ouverture
          ),
        );

        // Pump pour attendre le FutureBuilder
        await tester.pumpAndSettle();

        // Vérifier que la page de bienvenue s'affiche
        expect(find.text('Bienvenue'), findsOneWidget); // adapter au texte exact de WelcomeScreen

        // Simuler que l'utilisateur a déjà vu l'écran de bienvenue
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: const MyApp(hasSeenWelcome: true),
          ),
        );

        await tester.pumpAndSettle();

        // Vérifier que la page de login s'affiche
        expect(find.text('Se connecter'), findsOneWidget); // adapter au texte exact de LoginScreen
      });
}
