import 'package:flutter_template/menu/laporanTidakSesuai/model/laporanModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class laporanServices{
  static String baseUrl = "http://192.168.18.40:8000/api/getpolaporan";

  static Future<List<laporanModel>> getdata() async {
    final response = await http
            .get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 20));
    
    List<laporanModel> list = parseResponse(response.body);
    
    return list;
  }

  static Future<List<laporanModel>> searchdata(String response) async {

    
    List<laporanModel> list = parseResponse(response);
    
    return list;
  }
  
  static List<laporanModel> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    
    return parsed.map<laporanModel>((json) => laporanModel.fromJson(json)).toList();
  }
}