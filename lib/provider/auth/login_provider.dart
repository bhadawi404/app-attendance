import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../configuration.dart';

class LoginProvider with ChangeNotifier {
  Future<List> login({
    required String? username,
    required String? password,
    required String? org,
    required String? deviceId,
  }) async {
    try {
      var url = "$urlApi/login";
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = jsonEncode({
        'username': username,
        'password': password,
        'org': org,
        'device_id': deviceId,
      });
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        
        final SharedPreferences share = await SharedPreferences.getInstance();
        share.setString("token", data['access_token']);
        share.setString("employee_id", data['id'].toString());
        share.setString("face_id", data['face_id'].toString());
        return [200, 'Success Login'];
      } else {
        return [400, data['msg']];
      }
    } catch (e) {
      return [400, "Internal Server Error"];
    }
  }
}
