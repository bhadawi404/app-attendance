import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:zen_attendance/page/absen/face_cam_in_page.dart';
import 'package:zen_attendance/provider/absen/check_in_provider.dart';

import '../../provider/profile/profile_provider.dart';
import '../../theme.dart';

class AbsenInPage extends StatefulWidget {
  const AbsenInPage({Key? key}) : super(key: key);

  @override
  State<AbsenInPage> createState() => _AbsenInPageState();
}

class _AbsenInPageState extends State<AbsenInPage> {
  String? token;
  GoogleMapController? mapController;
  LatLng? currentLocation;
  LatLng? circleLocation;
  final Set<Marker> _markers = {};
  Circle? _circle;
  bool isInCircle = false;
  bool isDevMode = true;
  bool developerModes = false;
  String stringImage = '';
  XFile? imageFile;
  String deviceIdentifier = '';
  String? name;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sessionGet();
  }

  Future loadData() async {
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
        Navigator.pushNamedAndRemoveUntil(
            context, '/login-page', (route) => false);
      }
    } else {
      try {
        List data = await ProfileProvider().getlat(
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
            circleLocation = LatLng(data[1], data[2]);
            name = data[3];
          });
        }
      } catch (e) {
        // print('gagal');
      }
    }
    cekdevice();
  }

  Future sessionGet() async {
    final SharedPreferences session = await SharedPreferences.getInstance();
    setState(() {
      token = session.getString('token').toString();
    });
    loadData();
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
    checkDevelopmentMode();
  }

  Future<void> checkDevelopmentMode() async {
    bool developerMode = await FlutterJailbreakDetection.developerMode;

    if (!mounted) return;
    // _getCurrentLocation();
    setState(() {
      developerModes = developerMode;
      if (developerMode == false) {
        _getCurrentLocation();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    _handleLocationPermission();
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      _addCircle(circleLocation!);
      // _addCircle(LatLng(workLocationLang!, workLocationLong!));
      //  _addCircle(const LatLng(-6.283522, 106.711293));
      // Tambahkan marker berkedip berbentuk titik
      // _addMarker(const LatLng(-6.1841426, 106.5737366));
      _addMarker(currentLocation!);
      // _addMarker(circleLocation!);

      if (_circle != null) {
        final distance = Geolocator.distanceBetween(
          currentLocation!.latitude,
          currentLocation!.longitude,
          _circle!.center.latitude,
          _circle!.center.longitude,
        );

        isInCircle = distance <= _circle!.radius;
      }
    });

    // mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    mapController!.animateCamera(CameraUpdate.newLatLng(circleLocation!));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        warningNotif(
            'Location services are disabled. Please enable the services',
            context);
      }
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          warningNotif('Location permissions are denied', context);
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        warningNotif(
            'Location permissions are permanently denied, we cannot request permissions.',
            context);
      }
      return false;
    }
    return true;
  }

  void _addMarker(LatLng position) {
    _markers.add(
      Marker(
        markerId: const MarkerId("current_location"),
        position: position,
        infoWindow: const InfoWindow(title: "My Location"),
      ),
    );
  }

  void _addCircle(LatLng center) {
    setState(() {
      _circle = Circle(
        circleId: const CircleId('my_circle'),
        center: center,
        radius: 300, // Radius dalam meter (300 meter dalam hal ini)
        fillColor:
            const Color.fromRGBO(255, 0, 0, 0.3), // Warna merah transparan
        strokeWidth: 0, // Ketebalan garis lingkaran (0 untuk tidak ada garis)
      );
    });
  }

  Widget dialogWarning(context) {
    return AlertDialog(
      title: const Text("Warning"),
      content: const Text(
          "Are you sure you want to take absen outside the office area ???"),
      actions: [
        TextButton(
          child: const Text("Continue"),
          onPressed: () {
            Navigator.pop(context);
            sendData(false);
          },
        ),
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget refreshButton() {
    return Center(
      child: Container(
        height: 5.h,
        width: 30.w,
        margin: EdgeInsets.only(top: 3.h),
        child: TextButton(
          onPressed: () async {
            _getCurrentLocation();
          },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
          ),
          child: Text(
            'Refresh',
            style: subtitleTextStyle.copyWith(
              fontSize: 12.sp,
              fontWeight: medium,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendData(bool was) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FaceCamInPage(
    //       name.toString(),
    //       currentLocation!.latitude,
    //       currentLocation!.longitude,
    //       was,
    //       token.toString(),
    //     ),
    //   ),
    // );

    setState(() {
      isLoading = true;
    });
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 700,
      maxWidth: 900,
    );

    final imageBytes = File(pickedFile!.path.toString()).readAsBytesSync();
    setState(() {
      stringImage = base64.encode(imageBytes);
    });
    List result = await CheckInProvider().checkIn(
      name: name,
      checkIn: DateTime.now().toString(),
      checkInLat: currentLocation!.latitude,
      checkInLong: currentLocation!.longitude,
      was: was,
      faceImage: stringImage,
      token: token,
    );
    if (result[0] == 200) {
      if (context.mounted) {
        successNotif("Succces Absen", context);
        Navigator.pushNamedAndRemoveUntil(
            context, '/home-page', (route) => false);
      }
    } else {
      if (context.mounted) {
        warningNotif(result[1], context);
      }
    }

    setState(() {
      isLoading = false;
    });
    // Navigator.pop(context);
  }

  Widget absenButton() {
    return Center(
      child: Container(
        height: 10.h,
        width: 20.w,
        margin: EdgeInsets.only(top: 3.h),
        child: TextButton(
          onPressed: () async {
            if (isInCircle) {
              sendData(true);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialogWarning(context);
                },
              );
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
          ),
          child: Icon(
            Icons.filter_center_focus_sharp,
            size: 30.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home-page', (route) => false);
            }),
        backgroundColor: backgroundColor4,
        centerTitle: true,
        title: Text(
          "IN",
          style:
              headerTextStyle1.copyWith(fontSize: 20.sp, color: Colors.white),
        ),
        elevation: 0,
      );
    }

    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        appBar: header(),
        body: developerModes == false
            ? const Center(
                child: Text("Please Turn Off Your Development Mode !!!"))
            : Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: currentLocation ?? const LatLng(0.0, 0.0),
                        zoom: 15.0,
                      ),
                      onMapCreated: (controller) {
                        setState(() {
                          mapController = controller;
                        });
                      },
                      markers: _markers,
                      circles:
                          _circle != null ? <Circle>{_circle!} : <Circle>{},
                    ),
                  ),
                  // Tambahkan widget Column di sini
                  Container(
                    margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                    child: isLoading
                        ? Center(
                            child: SizedBox(
                              height: 20.sp,
                              width: 20.sp,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(primaryColor),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              currentLocation == null
                                  ? const SizedBox()
                                  : absenButton(),
                              refreshButton(),
                            ],
                          ),
                  ),
                ],
              ),
      );
    });
  }
}
