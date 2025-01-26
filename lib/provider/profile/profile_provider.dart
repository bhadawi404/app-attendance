import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../configuration.dart';

class ProfileProvider with ChangeNotifier {
  Future<List> getData({
    required String? token,
  }) async {
    try {
      var url = "$urlApi/get_profile";
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
        
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return [200, data['data']['name'],data['data']['gender'],data['data']['department'],data['data']['job_position']];
      } else {
        return [400, data['msg']];
      }
    } catch (e) {
      return [400, 'Internal Server Error'];
    }
  }

  Future<List> getlat({
    required String? token,
  }) async {
    try {
      var url = "$urlApi/get_profile";
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      var response = await http.get(
        Uri.parse(url),
        headers: headers,
        
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return [200, data['data']['work_location_lang'],data['data']['work_location_long'],data['data']['name']];
      } else {
        return [400, data['msg']];
      }
    } catch (e) {
      return [400, 'Internal Server Error'];
    }
  }
}
