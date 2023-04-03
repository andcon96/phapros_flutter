// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get.dart';

class ReviewSignaturePage extends StatelessWidget {
  final Uint8List signature;
  const ReviewSignaturePage({Key? key, required this.signature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
              onPressed: () => saveSignature(context),
              icon: const Icon(Icons.save),
            ),
          ],
          centerTitle: true,
          title: const Text('Save Signature'),
        ),
        body: Center(
          child: Image.memory(signature),
        ));
  }

  Future? saveSignature(BuildContext context) async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    //making signature name unique
    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time';

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccessful = result['isSuccess'];

    if (isSuccessful) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Get.snackbar('Success', 'Signature saved to device',
          backgroundColor: Colors.white, colorText: Colors.green);
    } else {
      Get.snackbar('Success', 'Signature saved to device',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
