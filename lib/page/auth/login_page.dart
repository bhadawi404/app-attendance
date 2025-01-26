// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../provider/auth/login_provider.dart';
import '../../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool isLoading = false;
  bool hidePassword = true;
  String deviceIdentifier = '';

  @override
  void initState() {
    cekdevice();
    super.initState();
  }

  Future<void> cekdevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }
    setState(() {});
    print(deviceIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> outApp() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Go out ?',
                style: TextStyle(fontSize: 12.sp),
              ),
              content: Text(
                'Are You Sure You Want To Exit This Application ?',
                style: TextStyle(fontSize: 13.sp),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    }

    Widget usernameInput() {
      return Container(
        margin: EdgeInsets.only(top: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 13.sp),
              decoration: BoxDecoration(
                  color: backgroundColor3,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 17.sp,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 13.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: usernameController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your Username',
                          hintStyle:
                              subtitleTextStyle.copyWith(fontSize: 11.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget passwordInput() {
      return Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: primaryTextStyle.copyWith(
                fontSize: 12.sp,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Container(
              height: 7.h,
              padding: EdgeInsets.symmetric(horizontal: 13.sp),
              decoration: BoxDecoration(
                  color: backgroundColor3,
                  borderRadius: BorderRadius.circular(12.sp)),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 17.sp,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 13.sp,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: passwordController,
                        style: subtitleTextStyle.copyWith(fontSize: 11.sp),
                        obscureText: hidePassword,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Your password',
                          hintStyle:
                              subtitleTextStyle.copyWith(fontSize: 11.sp),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: hidePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      color: primaryColor,
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget loginButton() {
      return Container(
        height: 6.h,
        width: double.infinity,
        margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
        child: TextButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            if (usernameController.text == '' ||
                passwordController.text == '') {
              warningNotif(
                  "Username or Password has not been filled in yet", context);
            } else {
              List log = await LoginProvider().login(
                username: usernameController.text,
                password: passwordController.text,
                org: "zen_software_migrate",
                // deviceId: "SP1A.210812.016",
                deviceId: deviceIdentifier,
                // deviceId: "UP1A.231005.007"
              );

              if (log.isEmpty) {
                if (context.mounted) {
                  warningNotif("Error Cannot Reach Server", context);
                }
              } else if (log[0] == 400) {
                if (context.mounted) {
                  warningNotif(log[1], context);
                }
              } else {
                if (context.mounted) {
                  successNotif("Login Success", context);
                  Navigator.pushNamed(context, '/home-page');
                }
              }
            }
            setState(() {
              isLoading = false;
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
          ),
          child: Text(
            'Login',
            style: subtitleTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: medium,
            ),
          ),
        ),
      );
    }

    Widget loadingButton() {
      return Container(
        height: 35.sp,
        width: double.infinity,
        margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.sp))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16.sp,
                height: 16.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 0.7.w,
                  valueColor: AlwaysStoppedAnimation(primaryTextColor),
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                'Loading',
                style: primaryTextStyle.copyWith(
                  fontSize: 13.sp,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget footer() {
      return Container(
        margin: EdgeInsets.only(
          bottom: 2.h,
          top: 3.h,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                    text: 'Forget Password? ',
                    style: subtitleTextStyle.copyWith(fontSize: 10.sp),
                    children: [
                      TextSpan(
                          text: 'here',
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          style: subtitleTextStyle.copyWith(
                            fontSize: 10.sp,
                            decoration: TextDecoration.underline,
                          ))
                    ]),
              ),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
        ),
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () {
          return outApp();
        },
        child: Scaffold(
          backgroundColor: backgroundColor1,
          resizeToAvoidBottomInset: true,
          body: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: primaryColor,
                height: 100.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 43.sp),
                        child: CircleAvatar(
                          backgroundColor: backgroundColor1,
                          radius: 90,
                          child: Icon(
                            Icons.person,
                            size: 70.sp,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.sp, bottom: 20.sp),
                        child: Text(
                          'Login',
                          style: primaryTextStyle.copyWith(fontSize: 25.sp),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20.sp,
                            right: 20.sp,
                            top: 10.sp,
                            bottom: 20.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.sp),
                            topRight: Radius.circular(25.sp),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 5.sp,
                            ),
                            usernameInput(),
                            passwordInput(),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 19.sp),
                              child: footer(),
                            ),
                            isLoading == true
                                ? loadingButton()
                                : Container(
                                    // margin: EdgeInsets.only(bottom: 20.sp),
                                    child: loginButton()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
