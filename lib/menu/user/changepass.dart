import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_template/utils/styles.dart';
import 'package:flutter_template/utils/password.dart';
import 'package:flutter_template/utils/color.dart';
import 'userprof.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_template/utils/globalurl.dart' as globals;

class changePass extends StatefulWidget {
  const changePass({Key? key}) : super(key: key);

  @override
  _changePassState createState() => _changePassState();
}

class _changePassState extends State<changePass> {
  final _formKey = GlobalKey<FormState>();

  bool _showPassOld = true;
  bool _showPassNew = true;
  bool _showPassCon = true;

  late TextEditingController _oldPass = TextEditingController();
  late TextEditingController _newPass = TextEditingController();
  late TextEditingController _conPass = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future savePass() async {
    final token = await UserSecureStorage.getToken();
    final userid = await UserSecureStorage.getUsername();
    final response =
        await http.post(Uri.parse('${globals.globalurl}/changepass'), body: {
      "id": userid,
      "password": _newPass.text,
      "oldpass": _oldPass.text,
      "confpass": _conPass.text,
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      setState(() {
        loading = false;
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                title: "Timeout",
                text: "Failed to save data"));
      });
      return http.Response('Error', 500);
    });

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
        isLoading: loading,
        opacity: 0.8,
        progressIndicator:
            SpinKitFadingCube(color: Colors.blueGrey[300], size: 70.0),
        color: Colors.grey[100],
        child: Scaffold(
            body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text('Change Password',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      textPassword(
                        hint: 'Old Password',
                        cont: _oldPass,
                        hide: _showPassOld,
                        next: Iconsax.lock,
                        text: '123',
                        press: () => {
                          setState(() {
                            _showPassOld = !_showPassOld;
                          })
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      textPassword(
                        hint: 'New Password',
                        cont: _newPass,
                        hide: _showPassNew,
                        next: Iconsax.lock5,
                        text: '123',
                        press: () => {
                          setState(() {
                            _showPassNew = !_showPassNew;
                          })
                        },
                      ),
                      // Divider(),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: _showPassCon,
                        controller: _conPass,
                        validator: (value) {
                          if (value == null || value == '') {
                            return "Cannot Be Empty";
                          } else if (value != _newPass.text) {
                            return "Confirm Password Doesn't Match New Password";
                          }
                          return null;
                        },
                        style: content,
                        decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            filled: true,
                            hintText: 'Confirm Password',
                            hintStyle: hintForm,
                            prefixIcon: const Icon(Iconsax.lock5),
                            suffixIcon: GestureDetector(
                              onTap: () => {
                                setState(() {
                                  _showPassCon = !_showPassCon;
                                })
                              },
                              child: Icon(_showPassCon
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none)),
                      ),
                      // Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              savePass().then((value) async {
                                if (value == null) {
                                  print('error timeout');
                                } else if (value['message'] == 'Error') {
                                  setState(() => loading = false);
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.danger,
                                          title: "Error",
                                          text: value['error']));
                                } else {
                                  setState(() => loading = false);
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => const userProf()),
                                  );
                                  // Navigator.pushAndRemoveUntil<dynamic>(
                                  //   context,
                                  //   MaterialPageRoute<dynamic>(
                                  //     builder: (BuildContext context) => userProf(),
                                  //   ),
                                  //       (route) => false,//if you want to disable back feature set to false
                                  // );
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          title: "Success",
                                          text: "Password updated"));
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.all(0.0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [orangeColor, orangeLightcolor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Save".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: buttonPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        )));
  }
}
