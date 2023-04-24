// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pest_detection/auth/SignupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_screen.dart';
import 'AuthService.dart';
import 'UserService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserService _userService;

  @override
  void initState() {
    super.initState();
    _initUserService();
  }

  void _initUserService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userService = UserService(prefs: prefs);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _auth.signInWithEmailAndPassword(
          _emailController.text.trim(), _passwordController.text.trim());
      if (user != null) {
        await _userService.saveUserData(
            _emailController.text.trim(), _passwordController.text.trim());
        Get.to(const HomeScreen());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect email or password.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
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
                    onPressed: _handleLogin,
                    child: const Text('Login'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Don’t have any account yet? '),
                    InkWell(
                      onTap: () {
                        Get.to(() => const SignupScreen(),
                            transition: Transition.leftToRight);
                      },
                      child: const Text(
                        'Create an account',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ]),
                ]))));
  }
}
