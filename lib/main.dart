import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:zen_attendance/page/auth/login_page.dart';
import 'package:zen_attendance/page/home/main_page.dart';

import 'page/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    // providers: [
    //   // ChangeNotifierProvider(
    //   //   create: (context) => LoginProvider(),
    //   // ),
    // ],
    // child:
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashPage(),
        '/login-page': (context) => const LoginPage(),
        '/home-page': (context) => const MainPage(),
      },
    );
    // );
  }
}
