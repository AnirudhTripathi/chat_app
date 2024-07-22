import 'package:chat_app/constants/theme/theme.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/init_dependancy.dart';
import 'package:chat_app/routes/routes_helper.dart';
import 'package:chat_app/view/auth_screen/login_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  InitDependancy.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    // webRecaptchaSiteKey: 'RECAPTCHA_SITE_KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.7, 872.7),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Chat App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightMode,
          // ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          //   useMaterial3: true,
          // ),
          home: LoginScreen(),
          getPages: RoutesHelper.routes,
        );
      },
    );
  }
}
