import 'package:flutter/material.dart';
import 'package:flutter_template/utils/secure_user_login.dart';

class myAcc extends StatefulWidget {
  const myAcc({Key? key}) : super(key: key);

  @override
  _myAccState createState() => _myAccState();
}

class _myAccState extends State<myAcc> {
  late String? name = '';
  late String? email = '';
  late String? cust = 'Not a Customer';
  late String? role = '';

  Future<bool> getData() async {
    final sname = await UserSecureStorage.getUsername();
    final semail = await UserSecureStorage.getEmail();
    final scust = await UserSecureStorage.getCust();
    final srole = await UserSecureStorage.getRole();

    setState(() {
      email = semail;
      name = sname;
      if (srole == 'customer') {
        cust = scust;
      }
      role = srole;
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
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        padding: const EdgeInsetsDirectional.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(65.0),
                          border: Border.all(
                              width: 1, color: const Color(0xffe0e0e0)),
                        ),
                        child: Image.asset(
                          'assets/user_photo_null.png',
                          width: 90,
                          height: 90,
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Center(
                    child: Text('My Account',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _textInfo(title: "Username", data: name),
                  const Divider(),
                  _textInfo(title: "Email", data: email),
                  const Divider(),
                ],
              ),
            )),
      ),
    );
  }
}

Widget _textInfo({
  data,
  title,
}) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 5, top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(
            height: 1,
          ),
          Container(
            child: Text(
              data,
              style: const TextStyle(
                  fontSize: 16, color: Colors.blueGrey, fontFamily: 'Poppins'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    ),
  );
}
