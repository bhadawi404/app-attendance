import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? authTimer;
  String? versi;
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () => sessionCek());
    super.initState();
  }

  Future<void> sessionCek() async {
    final SharedPreferences session = await SharedPreferences.getInstance();
    if (session.getString('token')==null) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login-page', (route) => false);
      }
    } else if (JwtDecoder.isExpired(session.getString('token').toString())) {
      if (context.mounted) {
        warningNotif("Session Time Out Please Login Again", context);
        session.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, '/login-page', (route) => false);
      }
    } else {
      if (context.mounted) {
        Navigator.pushNamed(context, '/home-page');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2.sp),
              child: Center(
                child: Text(
                  "Zen Software",
                  style: headerTextStyle2.copyWith(fontSize: 30.sp),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10.sp),
                width: 160.sp,
                height: 160.sp,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/logo.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30.sp),
                child: SizedBox(
                  height: 50.sp,
                  width: 50.sp,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
