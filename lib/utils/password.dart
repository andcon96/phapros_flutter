import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'styles.dart';

class textPassword extends StatelessWidget {
  const textPassword({
    Key? key,
    required this.text,
    required this.hint,
    required this.hide,
    required this.cont,
    this.press,
    this.next,
  }) : super(key: key);

  final String text, hint;
  final bool hide;
  final VoidCallback? press;
  final IconData? next;
  final TextEditingController cont;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hide,
      controller: cont,
      validator: (value) {
        if (value == null || value == '') {
          return "Cannot Be Empty";
        }
        return null;
      },
      style: content,
      decoration: InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,
          hintText: hint,
          hintStyle: hintForm,
          prefixIcon: Icon(next),
          suffixIcon: GestureDetector(
            onTap: press,
            child: Icon(
              hide ? Iconsax.eye : Iconsax.eye_slash,
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none)),
    );
  }
}
