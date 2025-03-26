import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  const AuthTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2)
          ),
          hintText: hintText
      ),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      obscureText: hintText == "Enter Password",
    );
  }
}
