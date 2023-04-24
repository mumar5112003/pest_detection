// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

//...

class UserService {
  final SharedPreferences prefs;

  UserService({required this.prefs});

  // save user data to local storage
  Future saveUserData(String email, String password) async {
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  // retrieve user data from local storage
  Future<Map<String, String>> getUserData() async {
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    return {'email': email ?? '', 'password': password ?? ''};
  }

  Future removeUserData() async {
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
