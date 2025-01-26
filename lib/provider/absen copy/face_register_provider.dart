import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../configuration.dart';

class FaceRegisterProvider with ChangeNotifier {
  Future<List> save({
    required File? faceImage,
    required String? token,
  }) async {
    try {
      var url = "$urlApi/register_face";
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers.addAll(headers);
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
      print(data);

      if (response.statusCode == 200) {
        if (data['success'] == false) {
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
