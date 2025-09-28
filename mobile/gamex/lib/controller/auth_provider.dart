import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;

  String? get token => _token;
  UserModel? get user => _user;
  bool get isAuthenticated => _token != null;

  final String baseUrl = "http://192.168.1.110:8000/api";

  Future<void> login(String identifier, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login/");
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "identifier": identifier,
            "password": password
          })
      );

      print("Login response status: ${response.statusCode}");
      print("Login response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["access"] == null) {
          throw Exception("Token d'accès manquant dans la réponse");
        }

        _token = data["access"];

        // Vérifier que les données utilisateur existent
        if (data["user"] != null) {
          _user = UserModel.fromJson(data["user"]);
          print("Utilisateur créé: ${_user.toString()}");
        } else {
          print("Pas de données utilisateur dans la réponse");
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", _token!);

        notifyListeners();
      } else {
        throw Exception("Erreur login : ${response.body}");
      }
    } catch (e) {
      print("Erreur login: $e");
      rethrow; // Relancer l'erreur pour que l'UI puisse la gérer
    }
  }

  Future<void> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("token")) return;

      final savedToken = prefs.getString("token");
      if (savedToken == null) return;

      // Valider le token avec l'API
      final isValid = await _validateToken(savedToken);
      if (!isValid) {
        // Token invalide, on le supprime
        await prefs.remove("token");
        return;
      }

      _token = savedToken;
      notifyListeners();
    } catch (e) {
      print("Erreur tryAutoLogin: $e");
      // En cas d'erreur, on continue sans authentification
    }
  }

  Future<bool> _validateToken(String token) async {
    try {
      // Tu peux créer un endpoint pour valider le token
      // Pour l'instant, on assume que le token est valide s'il existe
      // Dans un vrai projet, tu ferais un appel API pour le vérifier
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> register(String firstName, String lastName, String username, String email, String number, int age, String password) async {
    try {
      final url = Uri.parse("$baseUrl/register/");
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "email": email,
            "number": number,
            "age": age,
            "password": password,
          })
      );

      if (response.statusCode == 201) {
        await login(email, password);
      } else {
        throw Exception("Erreur register : ${response.body}");
      }
    } catch (e) {
      print("Erreur register: $e");
      throw Exception("Erreur d'inscription");
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    notifyListeners();
  }
}