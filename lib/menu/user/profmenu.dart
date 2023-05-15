import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    this.press,
    this.next,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;
  final IconData? next;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.blueGrey,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(next),
            const SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: const TextStyle(fontFamily: 'Poppins'),
            )),
            const Icon(Iconsax.arrow_right_3),
          ],
        ),
      ),
    );
  }
}
