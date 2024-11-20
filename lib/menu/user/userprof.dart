// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/login/loginPage.dart';
import 'package:flutter_template/menu/user/myacc.dart';
import 'package:flutter_template/menu/user/profmenu.dart';
import 'package:flutter_template/menu/user/profpic.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_template/utils/globalurl.dart' as globals;

class userProf extends StatefulWidget {
  const userProf({Key? key}) : super(key: key);

  @override
  _userProfState createState() => _userProfState();
}

class _userProfState extends State<userProf> {
  late String? name = '';
  late String? email = '';

  Future<bool> getData() async {
    final sname = await UserSecureStorage.getUsername();
    final semail = await UserSecureStorage.getEmail();
    setState(() {
      email = semail;
      name = sname;
    });

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[50],
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const ProfilePic(),
                  const SizedBox(height: 16),
                  _textInfo(name: name, email: email),
                  const SizedBox(
                    height: 30,
                  ),
                  ProfileMenu(
                    text: "My Account",
                    next: Iconsax.user,
                    press: () => {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const myAcc()),
                      )
                    },
                  ),
                  // ProfileMenu(
                  //   text: "Change Password",
                  //   next: Iconsax.unlock,
                  //   press: () => {
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //           builder: (context) => const changePass()),
                  //     )
                  //   },
                  // ),
                  ProfileMenu(
                    text: "Logout",
                    next: Iconsax.logout_1,
                    press: () async => {
                      await UserSecureStorage.delSession(),
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) =>
                            false, //if you want to disable back feature set to false
                      ),
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Version: " + globals.version,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

Widget _textInfo({name, email}) {
  return Column(
    children: <Widget>[
      Text(
        name,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'Poppins'),
      ),
      const SizedBox(
        height: 1,
      ),
      Container(
        child: Text(
          email,
          style: const TextStyle(
              fontSize: 16, color: Colors.grey, fontFamily: 'Poppins'),
        ),
      )
    ],
  );
}
