import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_routes.dart';
import '../../controller/auth_provider.dart';
import '../../core/constants/app_constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isloading = false;
  bool _ispPasswordVisible = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isloading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        identifierController.text.trim(),
        passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
      print(e);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstant.paddingXL),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // En tête
                const Text(
                  "Bon Retour !",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 8),

                // Sous-Titre
                const Text(
                  "Continuer l'aventure avec GameX",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 48),

                // Email ou Username
                TextFormField(
                  controller: identifierController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email ou Username',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    filled: true,
                    fillColor: AppConstant.textFormFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppConstant.mainColor, width: 2)
                    )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer cotre email ou votre nom d'utilisateur";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: !_ispPasswordVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    suffixIcon:IconButton(
                      onPressed: () {
                        setState(() {
                          _ispPasswordVisible = !_ispPasswordVisible;
                        });
                      },
                      icon: Icon(
                          _ispPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white70
                      ),
                    ),
                    filled: true,
                    fillColor: AppConstant.textFormFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppConstant.mainColor, width: 2)
                    )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),
                
                _isloading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )
                    ),
                    child: const Text(
                      'Se Connecter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Mot de passe oublié
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implemanter réinitiallistation de mot de passe
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Reinitialisation de mot de passe à implémanter")),
                      );
                    },
                    child: Text(
                      "Mot de passe Oublié ?",
                      style: TextStyle(
                        color: AppConstant.mainColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white30,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstant.paddingXM),
                      child: Text(
                        'ou',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white30,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Pas encore de compte ?',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: Text(
                        'S\'inscrire',
                        style: TextStyle(
                          color: AppConstant.mainColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
