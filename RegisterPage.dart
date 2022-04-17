// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Enter your Details Bellow",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          TextFormField(
            controller: _emailController,
            cursorColor: Colors.blue,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            controller: _passwordController1,
            cursorColor: Colors.blue,
            decoration: const InputDecoration(hintText: "Enter Password"),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            controller: _passwordController2,
            cursorColor: Colors.blue,
            decoration:
                const InputDecoration(hintText: "Re enter your password"),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(25),
            ),
            icon: const Icon(Icons.email_outlined),
            label: const Text("Register", style: TextStyle(fontSize: 20)),
            onPressed: () async {
              if (_passwordController2.text == _passwordController1.text &&
                  _passwordController1.text != "") {
                try {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()));

                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController1.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registered")));

                  Navigator.of(context).popUntil((route) => route.isFirst);
                } on FirebaseException catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$e.text')));
                  Navigator.of(context).pop();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("Passwords do not match! \nNo password given!")));
              }
            },
          ),
          const SizedBox(height: 40),
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
}
