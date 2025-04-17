import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:themewstore/app/modules/generic/controllers/LoginOutController.dart';
import 'app/routes/app_pages.dart';

Future main() async{
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  Get.put(LogInOutController());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onReady: () => Get.find<LogInOutController>().initNavigationListener(),
      title: "Application",
      initialRoute: AppPages.INITIAL, //splash
      getPages: AppPages.routes,
      theme: ThemeData(
        fontFamily: 'Inter'
      ),
    ),
  );
}