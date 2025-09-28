import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constant.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstant.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppConstant.mainColor,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Icon(
                  Icons.games,
                  color: Colors.white,
                  size: 60,
                ),
              ),

              SizedBox(height: 32,),
              
              const Text(
                'GameX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 16),

              const Text(
                'Le reseaux social des gameur\nPartage tes moments gaming !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 64),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('hasSeenWelcome', true);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen()
                      )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                    )
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
