import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:my_trafindo/pages/absen/absen_masuk_page.dart';
import 'package:sizer/sizer.dart';
import 'package:zen_attendance/page/absen/absen_in_page.dart';
import 'package:zen_attendance/provider/absen/face_register_provider.dart';

import '../../theme.dart';
import 'absen_out_page.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({Key? key}) : super(key: key);

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  bool isLoading = false;
  String? faceId = 'false';
  XFile? imageFile;
  String stringImage = '';
  String token = '';
  @override
  void initState() {
    super.initState();
    sessionGet();
  }

  Future sessionGet() async {
    final SharedPreferences session = await SharedPreferences.getInstance();
    setState(() {
      faceId = session.getString('face_id').toString();
      token = session.getString('token').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget menu1() {
      return GridView.count(
        padding: EdgeInsets.only(
          top: 2.sp,
          right: 10.sp,
          left: 10.sp,
          bottom: 5.sp,
        ),
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AbsenInPage(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                            3.14159), // Melakukan rotasi sejauh 180 derajat
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.sp),
                          child: Icon(
                            Icons.exit_to_app_rounded,
                            size: 80.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.sp,
                      ),
                      Text(
                        "IN",
                        style: primaryTextStyle.copyWith(fontSize: 20.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AbsenOutPage(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 5.sp,
                right: 5.sp,
                bottom: 5.sp,
              ),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.sp,
                    left: 5.sp,
                    right: 5.sp,
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.sp),
                        child: Icon(
                          Icons.exit_to_app_rounded,
                          size: 80.sp,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 8.sp,
                      ),
                      Text(
                        "Out",
                        style: primaryTextStyle.copyWith(fontSize: 20.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Future<void> sendData() async {
      setState(() {
        isLoading = true;
      });
      if (isLoading) {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: 700,
          maxWidth: 900,
        );
        setState(() {
          imageFile = pickedFile!;
        });
        List result = await FaceRegisterProvider().save(
          faceImage: File(pickedFile!.path.toString()),
          token: token,
        );
        print(result);
        if (result[0] == 200) {
          if (context.mounted) {
            successNotif("Succces Register", context);
            final SharedPreferences session =
                await SharedPreferences.getInstance();
            setState(() {
              session.setString("face_id", 'true');
              faceId = "true";
            });
          }
        } else {
          if (context.mounted) {
            warningNotif(result[1], context);
          }
        }
      }
      setState(() {
        isLoading = false;
      });
      // Navigator.pop(context);
    }

    Widget registerFace() {
      return GridView.count(
          padding: EdgeInsets.only(
            top: 2.sp,
            right: 10.sp,
            left: 10.sp,
            bottom: 5.sp,
          ),
          crossAxisCount: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GestureDetector(
              onTap: () async {
                sendData();
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: 5.sp,
                  right: 5.sp,
                  bottom: 5.sp,
                ),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  elevation: 2,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 10.sp,
                      left: 5.sp,
                      right: 5.sp,
                    ),
                    child: Column(
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(
                              3.14159), // Melakukan rotasi sejauh 180 derajat
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.sp),
                            child: Icon(
                              Icons.person,
                              size: 200.sp,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.sp,
                        ),
                        Text(
                          "Register Face",
                          style: primaryTextStyle.copyWith(fontSize: 20.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]);
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor4,
              backgroundColor1,
            ],
          ),
        ),
        child: isLoading
            ? Center(
                child: Text(
                "Loading",
                style: primaryTextStyle.copyWith(
                  fontSize: 30.sp,
                ),
              ))
            : faceId == 'false'
                ? Container(
                    margin: EdgeInsets.only(
                      top: 100.sp,
                      bottom: 25.sp,
                    ),
                    child: registerFace())
                : ListView(
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            top: 20.sp,
                            bottom: 25.sp,
                          ),
                          child: Center(
                              child: Text(
                            "ABSEN PAGE",
                            style: primaryTextStyle.copyWith(
                              fontSize: 28.sp,
                              // color: Colors.white
                            ),
                          ))),
                      menu1(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 5.sp,
                          left: 15.sp,
                          right: 15.sp,
                        ),
                        child: Theme(
                          data: ThemeData(
                            dataTableTheme: DataTableThemeData(
                              dataRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white),
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.grey),
                              // Set the row color to white
                            ),
                          ),
                          child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Date',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'IN',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Out',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    '23-01-2024',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  )),
                                  DataCell(Text('07:45',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 12.sp,
                                      ))),
                                  DataCell(Text('17:10',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 12.sp,
                                      ))),
                                ],
                              ),
                              DataRow(
                                color: MaterialStateProperty.all(alertColor),
                                cells: <DataCell>[
                                  DataCell(Text(
                                    '24-01-2024',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  )),
                                  DataCell(Text('08:05',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 12.sp,
                                      ))),
                                  DataCell(Text('17:05',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 12.sp,
                                      ))),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    '25-01-2024',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  )),
                                  DataCell(Text('07:05',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 12.sp,
                                      ))),
                                  DataCell(Text('17:05',
                                      style: primaryTextStyle.copyWith(
                                        fontSize: 12.sp,
                                      ))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      );
    });
  }
}
