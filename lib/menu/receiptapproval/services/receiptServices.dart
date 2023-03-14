import 'package:flutter/material.dart';
import 'package:flutter_template/menu/receiptapproval/model/receiptModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_template/utils/secure_user_login.dart';

class receiptServices {
  static String baseUrl = "http://192.168.0.3:8000/api/getreceipt";

  static Future<List<receiptModel>> getdata() async {
    final response =
        await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 20));

    List<receiptModel> list = parseResponse(response.body);

    return list;
  }

  static Future<List<receiptModel>> searchdata(String response) async {
    List<receiptModel> list = parseResponse(response);

    return list;
  }

  static List<receiptModel> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<receiptModel>((json) => receiptModel.fromJson(json))
        .toList();
  }
}
