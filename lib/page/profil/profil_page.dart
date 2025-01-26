import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:zen_attendance/provider/profile/profile_provider.dart';

import '../../theme.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isLoading = false;
  bool loadStart = false;
  String token = '';

  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController genderController = TextEditingController(text: '');
  TextEditingController jobPositionController = TextEditingController(text: '');
  TextEditingController departementController = TextEditingController(text: '');

  @override
  void initState() {
    sessionGet().whenComplete(() => null);
    super.initState();
  }

  Future sessionGet() async {
    final SharedPreferences session = await SharedPreferences.getInstance();

    token = session.getString('token').toString();

    setState(() {});
    loadData();
  }

  Widget widgetData(title, conttrollerText) {
    return Container(
      margin: EdgeInsets.only(
        top: 20.sp,
        left: 20.sp,
        right: 20.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: secondaryTextStyle.copyWith(
              fontSize: 10.sp,
            ),
          ),
          TextFormField(
            controller: conttrollerText,
            enabled: false,
            style: primaryTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '',
              hintStyle: primaryTextStyle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: subtitleColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future loadData() async {
    setState(() {
      loadStart = true;
    });
    if (JwtDecoder.isExpired(token.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1800),
          backgroundColor: secondaryColor,
          content: Text(
            "Session Time Out Please Login Again",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      );
      final SharedPreferences share = await SharedPreferences.getInstance();
      share.clear();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login-page', (route) => false);
      }
      setState(() {
        loadStart = false;
      });
    } else {
      try {
        List data = await ProfileProvider().getData(
          token: token,
        );
        if (data.isEmpty) {
          if (context.mounted) {
            warningNotif("Error Cannot Reach Server", context);
          }
        } else if (data[0] == 400) {
          if (context.mounted) {
            warningNotif(data[1], context);
          }
        } else {
          setState(() {
            nameController.text = data[1];
            genderController.text = data[2];
            departementController.text = data[3];
            jobPositionController.text = data[4];
          });
        }
      } catch (e) {
        // print('gagal');
      }

      setState(() {
        loadStart = false;
      });
    }
  }

  Widget logoutButton() {
    return Container(
      height: 7.h,
      width: double.infinity,
      margin: EdgeInsets.only(top: 5.h, left: 90.sp, right: 90.sp, bottom: 4.h),
      child: TextButton(
        onPressed: () async {
          final SharedPreferences session =
              await SharedPreferences.getInstance();
          session.clear();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login-page', (route) => false);
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
        child: Text(
          'Logout',
          style: subtitleTextStyle.copyWith(
            fontSize: 13.sp,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }

  Widget loadDataList() {
    return Container(
      margin: EdgeInsets.only(
        top: 20.sp,
        left: 20.sp,
        right: 20.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: backgroundColor7,
            highlightColor: backgroundColor6,
            child: Card(
              color: backgroundColor7,
              child: Container(
                margin: EdgeInsets.only(
                  top: 20.sp,
                  bottom: 20.sp,
                  left: 40.sp,
                  right: 40.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: backgroundColor1,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                top: 20.sp,
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80.sp,
                    height: 80.sp,
                    margin: EdgeInsets.only(
                      top: 6.sp,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/image_profile.png'),
                      ),
                    ),
                  ),
                  loadStart == true
                      ? Column(
                          children: List.generate(5, (_) => loadDataList()),
                        )
                      : Column(
                          children: [
                            widgetData('Name', nameController),
                            widgetData('Gender', genderController),
                            widgetData('Departement', departementController),
                            widgetData('Job Position', jobPositionController),
                            logoutButton(),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
