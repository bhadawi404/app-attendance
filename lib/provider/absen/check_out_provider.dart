import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../configuration.dart';
import 'package:intl/intl.dart';

class CheckOutProvider with ChangeNotifier {
  Future<List> checkOut({
    required String? name,
    required String? checkOut,
    required double? checkOutLat,
    required double? checkOutLong,
    required bool? was,
    required File? faceImage,
    required String? token,
  }) async {
    try {
      print(faceImage);
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.zentechsoft.com/attendance/check_in_check_out'),
      );
      request.fields.addAll({
        'name': name!,
        'check_out':  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'check_out_lat': checkOutLat.toString(),
        'check_out_long': checkOutLong.toString(),
        'status_attendance': 'OUT',
        'work_area_status_out': 'True',
        // 'face_image': faceImage!,
      });
      request.files.add(await http.MultipartFile.fromPath('face_image', faceImage!.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var responseData = await response.stream.toBytes();
      var data = jsonDecode(utf8.decode(responseData));

      print('Server Response: $data');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          return [200, 'Success'];
        } else {
          return [400, 'Failed'];
        }
      } else {
        return [response.statusCode, data['message'].toString()];
      }
    } catch (e) {
      print('Error: $e');
      return [400, 'Internal Server Error'];
    }
  }
}