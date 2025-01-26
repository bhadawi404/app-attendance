import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:face_camera/face_camera.dart';
import 'package:sizer/sizer.dart';
import 'package:zen_attendance/theme.dart';

import '../../provider/absen/check_in_provider.dart';
import '../home/main_page.dart';
import 'absen_in_page.dart';

class FaceCamInPage extends StatefulWidget {
  final String name;
  final double checkInLat;
  final double checkInLong;
  final bool was;
  final String token;

  const FaceCamInPage(
    this.name,
    this.checkInLat,
    this.checkInLong,
    this.was,
    this.token, {
    Key? key,
  }) : super(key: key);

  @override
  State<FaceCamInPage> createState() => _FaceCamInPageState();
}

class _FaceCamInPageState extends State<FaceCamInPage> {
  File? _capturedImage;
  bool isLoading = false;

  String status = "no";
  String message = "";
  @override
  void initState() {
    super.initState();
  }

  Widget backButton() {
    return Container(
      height: 6.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
      child: TextButton(
        onPressed: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home-page', (route) => false);
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        child: Text(
          'OK',
          style: subtitleTextStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }

  Widget retryButton() {
    return Container(
      height: 6.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
      child: TextButton(
        onPressed: () async {
          setState(() => _capturedImage = null);
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        child: Text(
          'Retry',
          style: subtitleTextStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return Container(
      height: 6.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
      child: TextButton(
        onPressed: () async {
          save(_capturedImage);
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        child: Text(
          'Send',
          style: subtitleTextStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }

  Future<void> save(image) async {
    // final imageBytes = File(image!.path.toString()).readAsBytesSync();
    // String imgstr = base64.encode(imageBytes);
    // List result = await CheckInProvider().checkIn(
    //   name: widget.name,
    //   checkIn: DateTime.now().toString(),
    //   checkInLat: widget.checkInLat,
    //   checkInLong: widget.checkInLong,
    //   was: widget.was,
    //   faceImage: imgstr,
    //   token: widget.token,
    // );
    // print(result[0]);
    // if (result[0] == 200) {
    //   setState(() {
    //     status = "sukses";
    //   });
    // } else {
    //   message = result[1];
    //   status = "failed";
    // }
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Center(
              child: Text(
                'IN',
                style: primaryTextStyle.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
          body: isLoading
              ? Center(
                  child: SizedBox(
                    height: 60.sp,
                    width: 60.sp,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                    ),
                  ),
                )
              : Builder(builder: (context) {
                  if (_capturedImage != null) {
                    return Center(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView(
                            children: [
                              status == 'no'
                                  ? SizedBox()
                                  : status == 'failed'
                                      ? Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: 20.sp,
                                              bottom: 20.sp,
                                            ),
                                            child: Text(
                                              message,
                                              style: primaryTextStyle.copyWith(
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                            top: 20.sp,
                                            bottom: 20.sp,
                                          ),
                                          child: Text(
                                            'Success Absen',
                                            style: primaryTextStyle.copyWith(
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ),
                              Image.file(
                                _capturedImage!,
                                // width: double.maxFinite,
                                // fit: BoxFit.fitWidth,
                              ),
                              status == 'failed'
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          bottom: 20.sp,
                                          left: 20.sp,
                                          right: 20.sp),
                                      child: retryButton(),
                                    )
                                  : status == 'sukses'
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom: 20.sp,
                                              left: 20.sp,
                                              right: 20.sp),
                                          child: backButton(),
                                        )
                                      : _capturedImage != null
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 20.sp,
                                                  left: 20.sp,
                                                  right: 20.sp),
                                              child: sendButton(),
                                            )
                                          : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return SmartFaceCamera(
                    autoCapture: true,
                    defaultCameraLens: CameraLens.front,
                    onCapture: (File? image) async {
                      setState(() {
                        _capturedImage = image;
                        // isLoading = true;
                      });
                    },
                    onFaceDetected: (Face? face) {
                      //Do something
                    },
                    messageBuilder: (context, face) {
                      if (face == null) {
                        return _message('Place your face in the camera');
                      }
                      if (!face.wellPositioned) {
                        return _message('Center your face in the square');
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }),
        ),
      );
    });
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
      );
}
