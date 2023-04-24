// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously
// ignore_for_file: deprecated_member_use, unused_field
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite/tflite.dart';

import 'auth/LoginScreen.dart';
import 'auth/UserService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State {
  File? imageFile;
  String? email;

  // Future<PickedFile>? file
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool _loading = true;
  List? _output;
  loadMode() async {
    await Tflite.loadModel(
        model: 'assets/ci.tflite', labels: 'assets/label.txt');
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    loadMode().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _handleSignOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      UserService userService = UserService(prefs: prefs);
      await userService.removeUserData();
      FirebaseAuth.instance.signOut();
      Get.to(const LoginScreen());
    }

    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          const DrawerHeader(
              child: Icon(
            Icons.person,
            size: 100,
          )),
          Center(child: Text('$email')),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Signout'),
            onTap: _handleSignOut,
          )
        ],
      )),
      appBar: AppBar(
        title: const Text("Pest Detection"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              child: (imageFile == null)
                  ? const Text("")
                  : Image.file(
                      File(imageFile!.path),
                      width: 400,
                      height: 400,
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            _output != null
                ? Text('this is a ${_output![0]['label']}')
                : const SizedBox(
                    width: 250,
                    child: Text(""),
                  ),
            MaterialButton(
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: () {
                _showChoiceDialog(context);
              },
              child: const Text("Select Image"),
            )
          ],
        ),
      ),
    );
  }

  final picker = ImagePicker();
  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    detectImage(imageFile!);
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    detectImage(imageFile!);

    Navigator.pop(context);
  }
}
