// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AuthService.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _auth.registerWithEmailAndPassword(
          _emailController.text.trim(), _passwordController.text.trim());
      if (user != null) {
        Get.to(const LoginScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to create account.')));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sign up')),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password.';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _handleSignup,
                    child: const Text('Sign up'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Already have an account? '),
                    InkWell(
                      onTap: () {
                        Get.to(() => const LoginScreen(),
                            transition: Transition.leftToRight);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ]),
                ]))));
  }
}
