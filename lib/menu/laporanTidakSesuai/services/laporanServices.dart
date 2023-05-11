import 'dart:io';

import 'package:flutter_template/menu/laporanTidakSesuai/model/laporanModel.dart';
import 'package:flutter_template/utils/secure_user_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_template/utils/globalurl.dart' as globals;

class laporanServices {
  static String baseUrl = '${globals.globalurl}/getpolaporan';

  static Future<List<laporanModel>> getdata() async {
    final token = await UserSecureStorage.getToken();

    final response = await http.get(Uri.parse(baseUrl), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    }).timeout(const Duration(seconds: 20));

    List<laporanModel> list = parseResponse(response.body);

    return list;
  }

  static Future<List<laporanModel>> searchdata(String response) async {
    List<laporanModel> list = parseResponse(response);

    return list;
  }

  static List<laporanModel> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<laporanModel>((json) => laporanModel.fromJson(json))
        .toList();
  }
}
