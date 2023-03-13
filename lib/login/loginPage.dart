import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_template/menu/home.dart';
import 'package:flutter_template/utils/color.dart';
import 'package:flutter_template/utils/loading.dart';
import 'package:flutter_template/utils/styles.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _userCon = TextEditingController();
  late final TextEditingController _passCon = TextEditingController();
  bool _showPassCon = true;

  final _formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  Future LoginUser() async {
    final response = await http
        .post(Uri.parse('http://192.168.18.40:8000/api/login'), body: {
      "email": _userCon.text,
      "password": _passCon.text,
    }).timeout(const Duration(seconds: 20), onTimeout: () {
      setState(() {
        loading = false;
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Error",
                text: "Failed to login"));  
      });
      return http.Response('Timeout', 500);
    });

    return json.decode(response.body);
  }

  bool loading = false;

  DateTime lastPressed = DateTime.now();

  Future<bool> _willPopCallback() async {
    final difference = DateTime.now().difference(lastPressed);
    final isExitWarning = difference >= const Duration(seconds: 2);

    lastPressed = DateTime.now();

    if (isExitWarning) {
      const message = "Press back again to exit";
      Fluttertoast.showToast(msg: message, fontSize: 18);

      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: loading
            ? const Loading()
            : Scaffold(
                body: Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [orangeColor, orangeLightcolor],
                            end: Alignment.topRight,
                            begin: Alignment.topLeft,
                          ),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white54),
                                ),
                                const Text(
                                  "IMI Modules",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Poppins'),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          child: Image.asset(
                                            "assets/logo.png",
                                            height: 130,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.575,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40)),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 30),
                                  child: Column(
                                    children: [
                                      _textInput(
                                        hint: "Email",
                                        icon: Iconsax.sms,
                                        controller: _userCon,
                                      ),
                                      // _textPassword(hint: "Password", icon: Icons.lock, controller: _passCon),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                          ),
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            obscureText: _showPassCon,
                                            controller: _passCon,
                                            validator: (value) {
                                              if (value == null ||
                                                  value == '') {
                                                return "Cannot Be Empty";
                                              }
                                              return null;
                                            },
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Password',
                                              prefixIcon:
                                                  const Icon(Iconsax.lock),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 15),
                                              suffixIcon: GestureDetector(
                                                onTap: () => {
                                                  setState(() {
                                                    _showPassCon =
                                                        !_showPassCon;
                                                  })
                                                },
                                                child: Icon(
                                                  _showPassCon
                                                      ? Iconsax.eye
                                                      : Iconsax.eye_slash,
                                                ),
                                              ),
                                            ),
                                          )),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          // ignore: avoid_print
                                          onPressed: () => print(
                                              'Forgot Password Button Pressed'),
                                          style: TextButton.styleFrom(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0)),
                                          child: Text(
                                            'Forgot Password?',
                                            style: TextStyle(
                                              color: orangeColor,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50.0,
                                        margin: const EdgeInsets.only(top: 40),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // print(await UserSecureStorage.getUsername());
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() => loading = true);
                                              LoginUser().then((value) async {
                                                // print(value);
                                                if (value == null) {
                                                } else if (value['message'] ==
                                                    "Error") {
                                                  setState(
                                                      () => loading = false);
                                                  CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    title: 'Error',
                                                    text:
                                                        'Username / Password Invalid',
                                                    loopAnimation: false,
                                                  );
                                                } else {

                                                  await UserSecureStorage
                                                      .setUsername(
                                                          value['username']
                                                              .toString());
                                                  await UserSecureStorage
                                                      .setCustid(value['custid']
                                                          .toString());
                                                  await UserSecureStorage
                                                      .setUsercreate(
                                                          value['username']
                                                              .toString());
                                                  await UserSecureStorage
                                                      .setToken(value['success']
                                                              ['token']
                                                          .toString());

                                                  await UserSecureStorage
                                                      .setName(value['user']
                                                              ['username']
                                                          .toString());
                                                  await UserSecureStorage
                                                      .setEmail(value['user']
                                                              ['email']
                                                          .toString());
                                                  await UserSecureStorage
                                                      .setRole(value['user']
                                                              ['menuroles']
                                                          .toString());
                                                  await UserSecureStorage.setCust(
                                                      '${value['user']['initial'].toString()} '
                                                      '- ${value['user']['name'].toString()}');

                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pushAndRemoveUntil<
                                                      dynamic>(
                                                    context,
                                                    MaterialPageRoute<dynamic>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const HomePage(),
                                                    ),
                                                    (route) =>
                                                        false, //if you want to disable back feature set to false
                                                  );
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) => HomePage()),
                                                  // );
                                                }
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          80.0)),
                                              padding:
                                                  const EdgeInsets.all(0.0)),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  orangeColor,
                                                  orangeLightcolor
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "LOGIN",
                                                textAlign: TextAlign.center,
                                                style: buttonPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Iconsax.copyright,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            'PT Intelegensia Mustaka Indonesia',
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )));
  }
}

Widget _textInput({controller, hint, icon}) {
  return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value == '') {
            return "Cannot Be Empty";
          }
          return null;
        },
        style: const TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 14),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(icon),
            contentPadding: const EdgeInsets.only(top: 15)),
      ));
}
