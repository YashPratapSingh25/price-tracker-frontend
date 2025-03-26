import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/components/auth_button.dart';
import 'package:web_scraper_price_tracker/components/auth_text_field.dart';
import 'package:web_scraper_price_tracker/components/google_auth_button.dart';
import 'package:web_scraper_price_tracker/pages/authentication/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                "Welcome Back! You have been missed!",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){},
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 20,),
              AuthButton(onTap: (){}, text: "Login",),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account ?",
                    style: TextStyle(
                      fontSize: 17
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Register(),)),
                    child: const Text(
                      "Register Here",
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
