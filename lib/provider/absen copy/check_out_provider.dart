import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../configuration.dart';

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
      print("dddvmdkvdmkvdm");
      var url = "$urlApi/check_in_check_out";
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers.addAll(headers);
      // Tambahkan data teks ke dalam permintaan
      request.fields['name'] = name!;
      request.fields['check_out'] = checkOut!;
      request.fields['check_out_lat'] = checkOutLat.toString();
      request.fields['check_out_long'] = checkOutLong.toString();
      request.fields['status_attendance'] = 'OUT';
      request.fields['work_area_status_out'] =
          was.toString(); // Ubah boolean menjadi string

      // Tambahkan file gambar ke dalam permintaan
      if (faceImage != null) {
        var mimeType = lookupMimeType(faceImage.path);
        var fileStream = http.ByteStream(Stream.castFrom(faceImage.openRead()));
        var length = await faceImage.length();

        var multipartFile = http.MultipartFile(
          'face_image',
          fileStream,
          length,
          filename: 'face_image',
          contentType: MediaType.parse(mimeType!),
        );

        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var data = jsonDecode(utf8.decode(responseData));
      print("dddddddd");
      print(data);
      if (response.statusCode == 200) {
        if (data['success'] == false) {
          return [400, 'Failed'];
        } else {
          return [200, 'Success'];
        }
      } else {
        if (data['message'] == null) {
          return [400, data['msg'].toString()];
        } else {
          return [400, data['message'].toString()];
        }
      }
    } catch (e) {
      return [400, "Internal Server Error"];
    }
  }
}
