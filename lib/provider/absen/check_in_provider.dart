import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../configuration.dart';

class CheckInProvider with ChangeNotifier {
  Future<List> checkIn({
    required String? name,
    required String? checkIn,
    required double? checkInLat,
    required double? checkInLong,
    required bool? was,
    required String? faceImage,
    required String? token,
  }) async {
    try {
      
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '$urlApi/check_in_check_out_attendance'));
      request.fields.addAll({
        'check_in': checkIn!.split('.')[0],
        'check_in_lat': checkInLat.toString(),
        'check_in_long': checkInLong.toString(),
        'status_attendance': 'IN',
        'work_area_status_in': was.toString(),
        'face_image': faceImage!,
        'name': name!
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.toBytes();
      var data = jsonDecode(utf8.decode(responseData));
      print("jdksjdksjdksjksjd");
      print(data);
      print(response.statusCode);

      if (response.statusCode == 200) {
        if (data['status'] != true) {
          return [400, 'Failed'];
        } else {
          return [200, 'Success'];
        }
      } else {
        return [400, data['message'].toString()];
      }
    } catch (e) {
      return [400, "Internal Server Error"];
    }
  }
}
