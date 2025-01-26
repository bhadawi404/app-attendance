// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zen_attendance/page/absen/absen_page.dart';
import '../../theme.dart';
import 'package:sizer/sizer.dart';

import '../profil/profil_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> outApp() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Keluar ?',
                style: TextStyle(fontSize: 12.sp),
              ),
              content: Text(
                'Apakah Anda Yakin Ingin Keluar Dari Aplikasi Ini',
                style: TextStyle(fontSize: 13.sp),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Tidak',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(
                    'Ya',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          )) ??
          false;
    }

    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.sp),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.red,
          unselectedItemColor: backgroundColor1,
          backgroundColor: backgroundColor4,
          currentIndex: currentIndex,
          onTap: (value) async {
            setState(() {
              currentIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(top: 10.sp),
                child: Icon(
                  Icons.home,
                  size: 20.sp,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(top: 10.sp),
                child: Icon(
                  Icons.filter_center_focus_sharp,
                  size: 20.sp,
                ),
              ),
              label: 'Absen',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.only(top: 10.sp),
                child: Icon(
                  Icons.person,
                  size: 20.sp,
                ),
              ),
              label: 'Profile',
            ),
          ],
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return Center(
              child: Text(
            "Home",
            style: primaryTextStyle.copyWith(fontSize: 30.sp),
          ));
        case 1:
          return const AbsenPage();
        case 2:
          return const ProfilPage();
        default:
          return Center(
              child: Text(
            "Home",
            style: primaryTextStyle.copyWith(fontSize: 30.sp),
          ));
      }
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: () {
          return outApp();
        },
        child: Scaffold(
          backgroundColor: backgroundColor1,
          bottomNavigationBar: customBottomNav(),
          body: body(),
        ),
      );
    });
  }
}
