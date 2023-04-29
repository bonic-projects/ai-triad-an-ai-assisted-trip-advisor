import 'package:ai_triad/ui/widgets/customButton.dart';
import 'package:ai_triad/ui/widgets/option.dart';
import 'package:flutter/material.dart';

class LoginRegisterWidget extends StatelessWidget {
  final String loginText;
  final String registerText;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const LoginRegisterWidget({
    Key? key,
    required this.onLogin,
    required this.onRegister,
    required this.loginText,
    required this.registerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: CustomButton(
            onTap: onLogin,
            text: "Login",
            isLoading: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: CustomButton(
            onTap: onRegister,
            text: "Register",
            isLoading: false,
          ),
        ),
      ],
    );
  }
}
