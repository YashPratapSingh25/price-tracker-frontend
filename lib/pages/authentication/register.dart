import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/pages/authentication/login.dart';

import '../../components/auth_button.dart';
import '../../components/auth_text_field.dart';
import '../../components/google_auth_button.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome! Good to have you onboard!",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 30
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40,),
              const AuthTextField(hintText: "Enter E-Mail"),
              const SizedBox(height: 20,),
              const AuthTextField(hintText: "Enter Password"),
              const SizedBox(height: 20,),
              AuthButton(onTap: (){}, text: "Register",),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account ?",
                    style: TextStyle(
                        fontSize: 17
                    ),
                  ),
                  TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),)),
                      child: const Text(
                        "Login Here",
                        style: TextStyle(
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
                ],
              ),
              const SizedBox(height: 20),
              const GoogleAuthButton()
            ],
          ),
        ),
      ),
    );
  }
}
