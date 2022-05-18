import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BaseNetworkDua {
  static final String baseUrl = "https://api.github.com";

  static Future<List<dynamic>> get(String partUrl) async {
    final String fullUrl = baseUrl + "/" + partUrl;
    debugPrint("BaseNetwork - fullUrl : $fullUrl");

    final response = await http.get(Uri.parse(fullUrl));

    // debugPrint("BaseNetwork - response : ${response.body}");
    return _processResponse(response);
  }

  static Future<List<dynamic>> _processResponse(http.Response response) async{
    debugPrint("BaseNetwork - response : ${response.body}");
    final body = response.body;
    if(body.isNotEmpty) {
      final jsonBody = json.decode(body);
      return jsonBody;
    } else{
      print("processResponse error");
      return [];
    }
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}