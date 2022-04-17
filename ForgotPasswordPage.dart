// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Enter your registered email",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          TextFormField(
            controller: _emailController,
            cursorColor: Colors.blue,
            decoration:
                const InputDecoration(hintText: "Enter registered email"),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(25),
            ),
            icon: const Icon(Icons.email_outlined),
            label: const Text("Reset Password", style: TextStyle(fontSize: 20)),
            onPressed: Resetpass,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to login!'),
          ),
        ]),
      ),
    ));
  }

  Future Resetpass() async {
    {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));

      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password Reset mail Sent")));

        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e.text')));
        Navigator.of(context).pop();
      }
    }
  }
}
