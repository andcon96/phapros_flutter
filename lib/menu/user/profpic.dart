import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
              padding: const EdgeInsetsDirectional.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(65.0),
                border: Border.all(width: 1, color: const Color(0xffe0e0e0)),
              ),
              child: Image.asset('assets/user_photo_null.png')),
          Positioned(
            right: -2,
            bottom: 5,
            child: SizedBox(
              height: 35,
              width: 35,
              child: TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Color(0xff64b5f6)),
                      ),
                      primary: Colors.blueGrey,
                      backgroundColor: const Color(0xff64b5f6),
                      padding: const EdgeInsetsDirectional.only(bottom: 0)),
                  onPressed: () {},
                  child: const Icon(
                    Iconsax.add,
                    size: 24,
                    color: Colors.white,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
