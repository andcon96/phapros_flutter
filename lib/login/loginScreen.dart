// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/utils/color.dart';

import 'loginPage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionDuration: const Duration(seconds: 1),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [orangeColor, orangeLightcolor],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter)),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 220, bottom: 30),
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  height: 150,
                ),
              ),
            ),
            const Text(
              'IMI Modules',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  fontFamily: 'Poppins'),
            )
          ],
        ),
      ),
    );
  }
}
